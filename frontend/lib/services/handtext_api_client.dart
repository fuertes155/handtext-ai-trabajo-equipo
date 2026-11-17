// Reinicio 2026-11-17: las regiones marcadas están pendientes de LUISDACA.
// Los comentarios anteriores describen requisitos; no son verificación del código actual.
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
    throw UnimplementedError("T038 pendiente de LUISDACA");
  }

  @override
  Future<RecognitionResult> recognize(
    Uint8List imageBytes,
    ImageFormat format,
  ) async {
    throw UnimplementedError("T038 pendiente de LUISDACA");
  }

  @override
  Future<Uint8List> export(String text, ExportFormat format) async {
    throw UnimplementedError("T038 pendiente de LUISDACA");
  }

  AppFailure _failureFromResponse(
    http.Response response, {
    required FailureKind fallback,
  }) {
    throw UnimplementedError("T038 pendiente de LUISDACA");
  }

  /// Interpreta la respuesta 200 del reconocimiento.
  RecognitionResult _parseRecognition(http.Response response) {
    throw UnimplementedError("T038 pendiente de LUISDACA");
  }
}
