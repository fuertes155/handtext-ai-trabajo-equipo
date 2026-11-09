import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart' show sha256;
import 'package:cryptography/cryptography.dart';
import 'package:flutter/foundation.dart' show compute;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/app_failure.dart';
import '../models/user_account.dart';
import 'account_rules.dart';
import 'auth_api_client.dart';

// Versión de los parámetros de derivación que acompaña al hash guardado.
const _argon2idV1 = 'argon2id-v1:';
final _legacyHash = RegExp(r'^[0-9a-f]{64}$');

Future<String> _derivePasswordHash((String, String) input) async {
  final (password, salt) = input;
  final key =
      await Argon2id(
        memory: 19 * 1024,
        iterations: 2,
        parallelism: 1,
        hashLength: 32,
      ).deriveKeyFromPassword(
        password: password,
        nonce: base64Url.decode(base64Url.normalize(salt)),
      );
  return '$_argon2idV1${base64UrlEncode(await key.extractBytes())}';
}

class LocalAccountRecord {
  const LocalAccountRecord({
    required this.user,
    required this.salt,
    required this.passwordHash,
    this.sessionToken,
  });

  final UserAccount user;
  final String salt;
  final String passwordHash;
  final String? sessionToken;

  factory LocalAccountRecord.fromJson(Object? json) => switch (json) {
    {
      'user': final Object user,
      'salt': final String salt,
      'password_hash': final String passwordHash,
      'session_token': final String? sessionToken,
    } =>
      LocalAccountRecord(
        user: UserAccount.fromJson(user),
        salt: salt,
        passwordHash: passwordHash,
        sessionToken: sessionToken,
      ),
    _ => throw const FormatException('Cuenta local con formato inesperado'),
  };

  Map<String, Object?> toJson() => {
    'user': user.toJson(),
    'salt': salt,
    'password_hash': passwordHash,
    'session_token': sessionToken,
  };
}

abstract interface class LocalAccountStore {
  Future<List<LocalAccountRecord>> read();

  Future<void> write(List<LocalAccountRecord> accounts);
}

class SecureLocalAccountStore implements LocalAccountStore {
  SecureLocalAccountStore({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  static const _key = 'handtext_local_accounts';

  final FlutterSecureStorage _storage;

  @override
  Future<List<LocalAccountRecord>> read() async {
    final raw = await _storage.read(key: _key);
    if (raw == null) return [];
    try {
      return switch (jsonDecode(raw)) {
        final List<Object?> items =>
          items.map(LocalAccountRecord.fromJson).toList(growable: false),
        _ => throw const FormatException('Lista de cuentas no válida'),
      };
    } on FormatException {
      throw const AppFailure(FailureKind.unexpected);
    }
  }

  @override
  Future<void> write(List<LocalAccountRecord> accounts) => _storage.write(
    key: _key,
    value: jsonEncode(accounts.map((account) => account.toJson()).toList()),
  );
}

class LocalAuthApi implements AuthApi {
  LocalAuthApi({required LocalAccountStore accounts}) : _accounts = accounts;

  final LocalAccountStore _accounts;
  final Random _random = Random.secure();

  @override
  Future<AuthResult> register({
    required String displayName,
    required String email,
    required String password,
    required bool acceptsDataPolicy,
  }) async {
    final name = displayName.trim().split(RegExp(r'\s+')).join(' ');
    final normalizedEmail = email.trim().toLowerCase();
    if (name.isEmpty || name.length > displayNameMaxChars) {
      throw const AppFailure(FailureKind.invalidDisplayName);
    }
    if (!isValidEmail(normalizedEmail)) {
      throw const AppFailure(FailureKind.invalidEmail);
    }
    if (password.length < passwordMinChars ||
        password.length > passwordMaxChars ||
        password.trim().isEmpty) {
      throw const AppFailure(FailureKind.weakPassword);
    }
    if (!acceptsDataPolicy) {
      throw const AppFailure(FailureKind.dataPolicyNotAccepted);
    }

    final accounts = await _readAccounts();
    if (accounts.any((account) => account.user.email == normalizedEmail)) {
      throw const AppFailure(FailureKind.emailAlreadyRegistered);
    }

    final salt = _randomToken();
    final user = UserAccount(
      id: _uuidV4(),
      displayName: name,
      email: normalizedEmail,
    );
    final token = _randomToken();
    final account = LocalAccountRecord(
      user: user,
      salt: salt,
      passwordHash: await compute(_derivePasswordHash, (password, salt)),
      sessionToken: token,
    );
    await _writeAccounts([...accounts, account]);
    return AuthResult(token: token, user: user);
  }

  @override
  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    if (validateLoginForm(email: email, password: password) != null) {
      throw const AppFailure(FailureKind.missingCredentials);
    }
    final accounts = (await _readAccounts()).toList();
    final index = accounts.indexWhere(
      (account) => account.user.email == email.trim().toLowerCase(),
    );
    if (index < 0) throw const AppFailure(FailureKind.invalidCredentials);

    final account = accounts[index];
    if (!await _matchesPassword(account, password)) {
      throw const AppFailure(FailureKind.invalidCredentials);
    }
    // Conserva las cuentas de la prueba anterior y actualiza el hash al ingresar.
    final needsUpgrade = _legacyHash.hasMatch(account.passwordHash);
    final salt = needsUpgrade ? _randomToken() : account.salt;
    final token = _randomToken();
    accounts[index] = LocalAccountRecord(
      user: account.user,
      salt: salt,
      passwordHash: needsUpgrade
          ? await compute(_derivePasswordHash, (password, salt))
          : account.passwordHash,
      sessionToken: token,
    );
    await _writeAccounts(accounts);
    return AuthResult(token: token, user: account.user);
  }

  @override
  Future<UserAccount> me(String token) async {
    final account = (await _readAccounts())
        .where((account) => account.sessionToken == token)
        .firstOrNull;
    if (account == null) throw const AppFailure(FailureKind.sessionExpired);
    return account.user;
  }

  @override
  Future<void> logout(String token) async {
    final accounts = (await _readAccounts()).toList();
    final index = accounts.indexWhere(
      (account) => account.sessionToken == token,
    );
    if (index < 0) return;
    final account = accounts[index];
    accounts[index] = LocalAccountRecord(
      user: account.user,
      salt: account.salt,
      passwordHash: account.passwordHash,
    );
    await _writeAccounts(accounts);
  }

  @override
  Future<void> deleteAccount(String token, String password) async {
    final accounts = (await _readAccounts()).toList();
    final index = accounts.indexWhere(
      (account) => account.sessionToken == token,
    );
    if (index < 0) throw const AppFailure(FailureKind.sessionExpired);

    final account = accounts[index];
    if (!await _matchesPassword(account, password)) {
      throw const AppFailure(FailureKind.invalidCredentials);
    }
    accounts.removeAt(index);
    await _writeAccounts(accounts);
  }

  Future<List<LocalAccountRecord>> _readAccounts() async {
    try {
      return await _accounts.read();
    } on AppFailure {
      rethrow;
    } on Exception {
      throw const AppFailure(FailureKind.unexpected);
    }
  }

  Future<void> _writeAccounts(List<LocalAccountRecord> accounts) async {
    try {
      await _accounts.write(accounts);
    } on AppFailure {
      rethrow;
    } on Exception {
      throw const AppFailure(FailureKind.unexpected);
    }
  }

  Future<bool> _matchesPassword(
    LocalAccountRecord account,
    String password,
  ) async {
    final stored = account.passwordHash;
    final String candidate;
    if (stored.startsWith(_argon2idV1)) {
      candidate = await compute(_derivePasswordHash, (password, account.salt));
    } else if (_legacyHash.hasMatch(stored)) {
      candidate = sha256
          .convert(utf8.encode('${account.salt}:$password'))
          .toString();
    } else {
      return false;
    }
    return Mac(candidate.codeUnits) == Mac(stored.codeUnits);
  }

  String _randomToken() => base64UrlEncode(
    List<int>.generate(32, (_) => _random.nextInt(256)),
  ).replaceAll('=', '');

  String _uuidV4() {
    final bytes = List<int>.generate(16, (_) => _random.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;
    final hex = bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0'));
    final value = hex.join();
    return '${value.substring(0, 8)}-${value.substring(8, 12)}-'
        '${value.substring(12, 16)}-${value.substring(16, 20)}-'
        '${value.substring(20)}';
  }
}
