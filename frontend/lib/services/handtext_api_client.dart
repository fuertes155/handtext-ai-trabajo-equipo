// Cliente de la API de documentos (tareas T038 y T121; contracts/api.md).
//
// - recognize: envía la imagen como cuerpo binario a POST /api/v1/recognitions.
// - export: envía el texto confirmado a POST /api/v1/exports y recibe el archivo.
// - Spec 002: cada solicitud lleva `Authorization: Bearer <token>` de la sesión. Si la
//   API responde 401, el fallo es `sessionExpired` y la app pide ingresar de nuevo.
// - Los errores se traducen con api_errors.dart (mensajes en español, constitución §5).
// - Espera como máximo 60 segundos (SC-009).
// - Spec 003: la respuesta de reconocimiento trae también las palabras dudosas.

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

import '../config/app_config.dart';
import '../models/app_failure.dart';
import '../models/export_format.dart';
import '../models/image_format.dart';
import '../models/recognition_result.dart';
import 'api_errors.dart';
import 'uncertain_ranges.dart';

/// Lo que el controlador necesita de la API. Las pruebas usan una versión falsa.
abstract interface class HandTextApi {
  Future<RecognitionResult> recognize(Uint8List imageBytes, ImageFormat format);

  Future<Uint8List> export(String text, ExportFormat format);
}

class HandTextApiClient implements HandTextApi {
  HandTextApiClient({
    required Uri baseUrl,
    String? Function()? tokenProvider,
    String localDevToken = AppConfig.localDevApiToken,
    http.Client? httpClient,
    Duration recognitionTimeout = AppConfig.recognitionTimeout,
    Duration exportTimeout = AppConfig.exportTimeout,
  }) : _baseUrl = baseUrl,
       _tokenProvider = tokenProvider,
       _localDevToken = localDevToken,
       _client =
           httpClient ??
           IOClient(
             HttpClient()..connectionTimeout = AppConfig.apiConnectionTimeout,
           ),
       _recognitionTimeout = recognitionTimeout,
       _exportTimeout = exportTimeout;

  final Uri _baseUrl;

  /// Devuelve el token del backend, si existe. Las cuentas locales no emiten uno válido
  /// para los endpoints remotos de documentos.
  final String? Function()? _tokenProvider;
  final String _localDevToken;
  final http.Client _client;
  final Duration _recognitionTimeout;
  final Duration _exportTimeout;

  /// Cabecera de autenticación [SC-202] más las cabeceras propias de la solicitud.
  Map<String, String> _headers(Map<String, String> extra) {
    final token = _tokenProvider?.call();
    if (token != null && token.isNotEmpty) {
      return {...extra, 'Authorization': 'Bearer $token'};
    }
    if (kDebugMode &&
        _localDevToken.isNotEmpty &&
        const ['127.0.0.1', '::1', '10.0.2.2'].contains(_baseUrl.host)) {
      return {...extra, 'X-HandText-Local-Dev': _localDevToken};
    }
    return extra;
  }

  @override
  Future<RecognitionResult> recognize(
    Uint8List imageBytes,
    ImageFormat format,
  ) async {
    final headers = _headers({'Content-Type': format.mimeType});
    final response = await sendRequest(
      () => _client.post(
        _baseUrl.resolve('api/v1/recognitions'),
        headers: headers,
        body: imageBytes,
      ),
      timeout: _recognitionTimeout,
      timeoutFailure: FailureKind.recognitionTimeout,
    );
    if (response.statusCode != 200) {
      throw _failureFromResponse(
        response,
        fallback: FailureKind.recognitionFailed,
        hadSession: headers.containsKey('Authorization'),
      );
    }
    return _parseRecognition(response);
  }

  @override
  Future<Uint8List> export(String text, ExportFormat format) async {
    final headers = _headers({
      'Content-Type': 'application/json; charset=utf-8',
    });
    final response = await sendRequest(
      () => _client.post(
        _baseUrl.resolve('api/v1/exports'),
        headers: headers,
        body: jsonEncode({'text': text, 'format': format.apiValue}),
      ),
      timeout: _exportTimeout,
      timeoutFailure: FailureKind.exportTimeout,
    );
    if (response.statusCode != 200) {
      throw _failureFromResponse(
        response,
        fallback: FailureKind.exportFailed,
        hadSession: headers.containsKey('Authorization'),
      );
    }
    if (!format.matchesContent(response.bodyBytes)) {
      throw const AppFailure(FailureKind.exportFailed);
    }
    return response.bodyBytes;
  }

  AppFailure _failureFromResponse(
    http.Response response, {
    required FailureKind fallback,
    required bool hadSession,
  }) {
    if (response.statusCode == 401) {
      // Un rechazo sin Bearer no invalida una cuenta local. Se recuerda lo
      // enviado, aunque la sesión cambie mientras llega la respuesta.
      return AppFailure(
        hadSession
            ? FailureKind.sessionExpired
            : FailureKind.backendAuthenticationRequired,
      );
    }
    return failureFromResponse(response, fallback: fallback);
  }

  /// Interpreta la respuesta 200 del reconocimiento.
  RecognitionResult _parseRecognition(http.Response response) {
    try {
      final json = decodeJson(response);
      if (json case {
        'status': final String status,
        'text': final String text,
        'request_id': String(),
      } when status == 'text_found' || status == 'no_text') {
        final hasText = status == 'text_found' && text.trim().isNotEmpty;
        return RecognitionResult(
          hasText: hasText,
          text: hasText ? text : '',
          uncertainRanges: hasText
              ? rangesFromApi(text, (json as Map)['uncertain_words'])
              : const [],
        );
      }
    } on FormatException {
      throw const AppFailure(FailureKind.invalidServerResponse);
    }
    throw const AppFailure(FailureKind.invalidServerResponse);
  }

  void close() => _client.close();
}
