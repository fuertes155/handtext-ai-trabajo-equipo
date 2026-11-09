import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:handtext_ai/models/app_failure.dart';
import 'package:handtext_ai/models/user_account.dart';
import 'package:handtext_ai/services/local_auth_api.dart';
import 'package:handtext_ai/services/session_store.dart';
import 'package:handtext_ai/state/auth_controller.dart';

class _MemoryAccountStore implements LocalAccountStore {
  final List<LocalAccountRecord> accounts = [];

  @override
  Future<List<LocalAccountRecord>> read() async => accounts.toList();

  @override
  Future<void> write(List<LocalAccountRecord> value) async {
    accounts
      ..clear()
      ..addAll(value);
  }
}

Future<FailureKind> _failureOf(Future<Object?> operation) async {
  try {
    await operation;
  } on AppFailure catch (failure) {
    return failure.kind;
  }
  fail('Se esperaba un AppFailure');
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _MemoryAccountStore store;
  late LocalAuthApi auth;

  setUp(() {
    store = _MemoryAccountStore();
    auth = LocalAuthApi(accounts: store);
  });

  test('registra una cuenta local y no conserva la contraseña', () async {
    final result = await auth.register(
      displayName: '  Ana   María ',
      email: ' ANA@Correo.COM ',
      password: 'clave-segura-1',
      acceptsDataPolicy: true,
    );

    expect(result.user.displayName, 'Ana María');
    expect(result.user.email, 'ana@correo.com');
    expect(result.user.id, matches(RegExp(r'^[0-9a-f-]{36}$')));
    expect(store.accounts, hasLength(1));
    expect(store.accounts.single.passwordHash, startsWith('argon2id-v1:'));
    expect(store.accounts.single.sessionToken, result.token);
    expect(await auth.me(result.token), result.user);
  });

  test('no permite registrar dos veces el mismo correo', () async {
    await auth.register(
      displayName: 'Ana',
      email: 'ana@correo.com',
      password: 'clave-segura-1',
      acceptsDataPolicy: true,
    );

    expect(
      await _failureOf(
        auth.register(
          displayName: 'Otra Ana',
          email: ' ANA@CORREO.COM ',
          password: 'clave-segura-2',
          acceptsDataPolicy: true,
        ),
      ),
      FailureKind.emailAlreadyRegistered,
    );
    expect(store.accounts, hasLength(1));
  });

  test('el ingreso local conserva acceso tras crear otro servicio', () async {
    await auth.register(
      displayName: 'Ana',
      email: 'ana@correo.com',
      password: 'clave-segura-1',
      acceptsDataPolicy: true,
    );
    final nextRun = LocalAuthApi(accounts: store);

    final result = await nextRun.login(
      email: ' ANA@CORREO.COM ',
      password: 'clave-segura-1',
    );

    expect(await nextRun.me(result.token), result.user);
  });

  test('registro, reanudación, cierre e ingreso funcionan sin HTTP', () async {
    FlutterSecureStorage.setMockInitialValues({});
    AuthController newController() => AuthController(
      api: LocalAuthApi(accounts: SecureLocalAccountStore()),
      sessions: SecureSessionStore(),
    );

    var httpAttempts = 0;
    await HttpOverrides.runZoned(
      () async {
        final first = newController();
        await first.initialize();
        expect(first.status, AuthStatus.signedOut);
        expect(
          await first.register(
            displayName: 'Persona de prueba',
            email: 'offline@example.test',
            password: 'clave-de-prueba',
            acceptsDataPolicy: true,
          ),
          isTrue,
        );
        final user = first.user;
        first.dispose();

        final restored = newController();
        await restored.initialize();
        expect(restored.status, AuthStatus.signedIn);
        expect(restored.user?.toJson(), user?.toJson());
        await restored.signOut();
        restored.dispose();

        final signedOut = newController();
        await signedOut.initialize();
        expect(signedOut.status, AuthStatus.signedOut);
        expect(
          await signedOut.signIn(
            email: 'offline@example.test',
            password: 'clave-de-prueba',
          ),
          isTrue,
        );
        expect(signedOut.user?.toJson(), user?.toJson());
        signedOut.dispose();
      },
      createHttpClient: (_) {
        httpAttempts++;
        throw StateError('La prueba de autenticación no admite HTTP');
      },
    );
    expect(httpAttempts, 0);
  });

  test('una contraseña incorrecta no inicia sesión', () async {
    await auth.register(
      displayName: 'Ana',
      email: 'ana@correo.com',
      password: 'clave-segura-1',
      acceptsDataPolicy: true,
    );

    expect(
      await _failureOf(
        auth.login(email: 'ana@correo.com', password: 'incorrecta'),
      ),
      FailureKind.invalidCredentials,
    );
  });

  test(
    'migra una cuenta SHA-256 solo al ingresar con la clave correcta',
    () async {
      const password = 'clave-de-prueba';
      const salt = 'salt-de-prueba';
      const user = UserAccount(
        id: 'anterior',
        displayName: 'Ana',
        email: 'ana@example.test',
      );
      final oldHash = sha256.convert(utf8.encode('$salt:$password')).toString();
      store.accounts.add(
        LocalAccountRecord(user: user, salt: salt, passwordHash: oldHash),
      );

      expect(
        await _failureOf(auth.login(email: user.email, password: 'incorrecta')),
        FailureKind.invalidCredentials,
      );
      expect(store.accounts.single.passwordHash, oldHash);

      final result = await auth.login(email: user.email, password: password);
      expect(result.user, user);
      expect(store.accounts.single.salt, isNot(salt));
      expect(store.accounts.single.passwordHash, startsWith('argon2id-v1:'));
      final nextRun = LocalAuthApi(accounts: store);
      expect(await nextRun.me(result.token), user);
      expect(
        (await nextRun.login(email: user.email, password: password)).user,
        user,
      );
    },
  );

  test('cerrar sesión invalida el token pero conserva la cuenta', () async {
    final result = await auth.register(
      displayName: 'Ana',
      email: 'ana@correo.com',
      password: 'clave-segura-1',
      acceptsDataPolicy: true,
    );

    await auth.logout(result.token);

    expect(await _failureOf(auth.me(result.token)), FailureKind.sessionExpired);
    expect(store.accounts, hasLength(1));
    expect(store.accounts.single.sessionToken, isNull);
  });

  test('eliminar requiere la contraseña y borra la cuenta local', () async {
    final result = await auth.register(
      displayName: 'Ana',
      email: 'ana@correo.com',
      password: 'clave-segura-1',
      acceptsDataPolicy: true,
    );

    expect(
      await _failureOf(auth.deleteAccount(result.token, 'incorrecta')),
      FailureKind.invalidCredentials,
    );
    expect(store.accounts, hasLength(1));

    await auth.deleteAccount(result.token, 'clave-segura-1');
    expect(store.accounts, isEmpty);
  });

  test('rechaza el registro sin aceptar la política', () async {
    expect(
      await _failureOf(
        auth.register(
          displayName: 'Ana',
          email: 'ana@correo.com',
          password: 'clave-segura-1',
          acceptsDataPolicy: false,
        ),
      ),
      FailureKind.dataPolicyNotAccepted,
    );
    expect(store.accounts, isEmpty);
  });
}
