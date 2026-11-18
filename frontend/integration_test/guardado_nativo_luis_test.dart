// T908: diálogo Android real, documento sintético generado por la API temporal.
// El controlador/selector no se sustituyen para el guardado de esta prueba.
import 'dart:convert';
import 'dart:io';
import 'package:cryptography/cryptography.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:handtext_ai/models/export_format.dart';
import 'package:handtext_ai/services/auth_api_client.dart';
import 'package:handtext_ai/services/file_save_service.dart';
import 'package:handtext_ai/services/handtext_api_client.dart';
import 'package:handtext_ai/state/document_flow_controller.dart';

void event(String phase, [Map<String, Object> fields = const {}]) {
  debugPrint('NATIVE_EVENT ${jsonEncode({'phase': phase, ...fields})}');
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('T908: nombre propuesto, guardado Android real y cancelación', (
    tester,
  ) async {
    expect(Platform.isAndroid, isTrue);
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: Text('Prueba nativa T908: solo datos sintéticos')),
      ),
    );
    final base = Uri.parse(
      const String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: 'http://10.0.2.2:8765/',
      ),
    );
    final httpClient = http.Client();
    final accounts = AuthApiClient(baseUrl: base, httpClient: httpClient);
    const password = 'synthetic-native-test-only';
    final grant = await accounts.register(
      displayName: 'Prueba sintética',
      email: 'native-${DateTime.now().microsecondsSinceEpoch}@example.test',
      password: password,
      acceptsDataPolicy: true,
    );
    final api = HandTextApiClient(
      baseUrl: base,
      tokenProvider: () => grant.token,
    );
    addTearDown(() async {
      await accounts.deleteAccount(grant.token, password);
      api.close();
      httpClient.close();
    });
    final bytes = await api.export(
      'Hoja sintética HandText AI\nPrueba de guardado sin datos personales.',
      ExportFormat.pdf,
    );
    expect(ExportFormat.pdf.matchesContent(bytes), isTrue);
    final name = suggestedFileName(
      ExportFormat.pdf,
      DateTime.now(),
      title: 'HandText nativo ${DateTime.now().microsecondsSinceEpoch} /',
    );
    final hash = await Sha256().hash(bytes);
    final digest = hash.bytes
        .map((b) => b.toRadixString(16).padLeft(2, '0'))
        .join();
    const saver = SystemFileSaver(dialogTitle: _title);
    event('save', {'name': name});
    final result = await saver.save(bytes: bytes, fileName: name);
    expect(result, isA<SaveCompleted>());
    event('saved', {'name': name, 'sha256': digest, 'bytes': bytes.length});
    final cancelName =
        'HandText_cancelado_${DateTime.now().microsecondsSinceEpoch}.pdf';
    event('cancel', {'name': cancelName});
    final cancelled = await saver.save(bytes: bytes, fileName: cancelName);
    expect(cancelled, isA<SaveCancelled>());
    event('complete');
  });
}

String _title() => 'Guardar prueba sintética';
