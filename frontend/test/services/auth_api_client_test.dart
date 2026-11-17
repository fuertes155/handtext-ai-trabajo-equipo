import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:handtext_ai/models/app_failure.dart';
import 'package:handtext_ai/services/auth_api_client.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

const user = {
  'id': 'synthetic-user',
  'display_name': 'Persona',
  'email': 'test@example.invalid',
};
http.Response response(Object body, int status) => http.Response.bytes(
  utf8.encode(jsonEncode(body)),
  status,
  headers: {'content-type': 'application/json'},
);
Matcher failure(FailureKind kind) =>
    throwsA(isA<AppFailure>().having((e) => e.kind, 'kind', kind));

void main() {
  test('registro/ingreso envían el contrato y decodifican UTF-8', () async {
    final sent = <http.Request>[];
    final api = AuthApiClient(
      baseUrl: Uri.parse('https://example.invalid/base/'),
      httpClient: MockClient((request) async {
        sent.add(request);
        return response({
          'token': 'synthetic-token',
          'user': user,
        }, request.url.path.endsWith('register') ? 201 : 200);
      }),
    );
    final registered = await api.register(
      displayName: 'Persona',
      email: 'test@example.invalid',
      password: 'synthetic-password',
      acceptsDataPolicy: true,
    );
    final logged = await api.login(
      email: 'test@example.invalid',
      password: 'synthetic-password',
    );
    expect(registered.user.id, user['id']);
    expect(logged.token, 'synthetic-token');
    expect(sent.first.url.path, '/base/api/v1/auth/register');
    expect(jsonDecode(sent.first.body)['accepts_data_policy'], true);
    expect(jsonDecode(sent.last.body), {
      'email': 'test@example.invalid',
      'password': 'synthetic-password',
    });
  });
  test(
    'me/logout/eliminar usan Bearer y contraseña solo en la eliminación',
    () async {
      final sent = <http.Request>[];
      final api = AuthApiClient(
        baseUrl: Uri.parse('https://example.invalid/'),
        httpClient: MockClient((request) async {
          sent.add(request);
          return request.method == 'GET'
              ? response({'user': user}, 200)
              : http.Response('', 204);
        }),
      );
      expect((await api.me('synthetic-token')).email, user['email']);
      await api.logout('synthetic-token');
      await api.deleteAccount('synthetic-token', 'synthetic-password');
      expect(sent.map((r) => r.method), ['GET', 'POST', 'DELETE']);
      for (final request in sent) {
        expect(request.headers['authorization'], 'Bearer synthetic-token');
      }
      expect(sent[1].body, isEmpty);
      expect(jsonDecode(sent[2].body), {'password': 'synthetic-password'});
    },
  );
  test('rechazos y respuestas dañadas tienen un fallo seguro', () async {
    for (final entry in [
      ('INVALID_CREDENTIALS', 401, FailureKind.invalidCredentials),
      ('TOO_MANY_ATTEMPTS', 429, FailureKind.tooManyAttempts),
      ('ACCOUNTS_UNAVAILABLE', 503, FailureKind.accountsUnavailable),
    ]) {
      final api = AuthApiClient(
        baseUrl: Uri.parse('https://example.invalid/'),
        httpClient: MockClient(
          (_) async => response({
            'error': {'code': entry.$1, 'message': 'safe'},
          }, entry.$2),
        ),
      );
      await expectLater(
        api.login(email: 'test@example.invalid', password: 'synthetic'),
        failure(entry.$3),
      );
    }
    final api = AuthApiClient(
      baseUrl: Uri.parse('https://example.invalid/'),
      httpClient: MockClient((_) async => http.Response('<html>', 200)),
    );
    await expectLater(
      api.login(email: 'test@example.invalid', password: 'synthetic'),
      failure(FailureKind.invalidServerResponse),
    );
  });
}
