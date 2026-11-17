// Controlador de la sesión (tarea T125; spec 002, Historias 1 y 2).
//
// Decide si se muestra la bienvenida (sin sesión) o la app (con sesión), y concentra
// el registro, el ingreso, el cierre de sesión, la eliminación de la cuenta y el
// vencimiento de la sesión. No contiene widgets (constitución §4).
// Etiquetas: [CU-H1-E2] = spec 002, Historia 1, escenario 2.

import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/app_failure.dart';
import '../models/operation_status.dart';
import '../models/user_account.dart';
import '../services/auth_api_client.dart';
import '../services/session_store.dart';

/// Estado de la sesión: comprobando (al abrir la app), sin sesión o con sesión.
enum AuthStatus { checking, signedOut, signedIn }

class AuthController extends ChangeNotifier {
  AuthController({required AuthApi api, required SessionStore sessions})
    : _api = api,
      _sessions = sessions;

  final AuthApi _api;
  final SessionStore _sessions;

  AuthStatus _status = AuthStatus.checking;
  StoredSession? _session;
  bool _isBusy = false;
  AppFailure? _failure;
  StatusEvent? _notice;
  bool _isDisposed = false;

  AuthStatus get status {
    return _status;
  }

  /// Cuenta con sesión (null sin sesión).
  UserAccount? get user {
    return _session?.user;
  }

  /// Token para la cabecera Authorization (lo lee HandTextApiClient).
  String? get token {
    return _session?.token;
  }

  /// [SC-008] Hay una operación de cuenta en curso.
  bool get isBusy {
    return _isBusy;
  }

  /// Último fallo del registro, el ingreso o la eliminación (para mostrarlo).
  AppFailure? get failure {
    return _failure;
  }

  /// Aviso para la bienvenida: sesión vencida, sesión cerrada o cuenta eliminada.
  StatusEvent? get notice {
    return _notice;
  }

  /// Al abrir la app, comprueba la sesión guardada con el servicio de autenticación.
  Future<void> initialize() async {
    if (_isBusy || _isDisposed) return;
    _isBusy = true;
    _failure = null;
    try {
      final saved = await _sessions.read();
      if (saved == null) {
        _status = AuthStatus.signedOut;
        return;
      }
      try {
        final account = await _api.me(saved.token);
        // Un token nunca debe cambiar de propietario al recuperar una sesión.
        if (account.id != saved.user.id) {
          throw const AppFailure(FailureKind.sessionExpired);
        }
        _session = StoredSession(token: saved.token, user: account);
        await _saveQuietly(_session!);
        _status = AuthStatus.signedIn;
      } on AppFailure catch (error) {
        if (error.kind == FailureKind.noConnection ||
            error.kind == FailureKind.accountsUnavailable) {
          _session = saved;
          _status = AuthStatus.signedIn;
        } else {
          _session = null;
          _status = AuthStatus.signedOut;
          if (error.kind == FailureKind.sessionExpired) {
            _notice = StatusEvent.sessionExpired;
          }
          _failure = error;
          await _clearQuietly();
        }
      }
    } catch (_) {
      _session = null;
      _status = AuthStatus.signedOut;
      _failure = const AppFailure(FailureKind.unexpected);
    } finally {
      _isBusy = false;
      _notify();
    }
  }

  /// [CU-H1-E2] Crea la cuenta e inicia la sesión. Devuelve true si lo logró.
  Future<bool> register({
    required String displayName,
    required String email,
    required String password,
    required bool acceptsDataPolicy,
  }) {
    return _startSession(
      () => _api.register(
        displayName: displayName.trim().split(RegExp(r'\s+')).join(' '),
        email: email.trim().toLowerCase(),
        password: password,
        acceptsDataPolicy: acceptsDataPolicy,
      ),
    );
  }

  /// [CU-H1-E6] Inicia sesión con correo y contraseña.
  Future<bool> signIn({required String email, required String password}) {
    return _startSession(
      () => _api.login(email: email.trim().toLowerCase(), password: password),
    );
  }

  Future<bool> _startSession(Future<AuthResult> Function() request) async {
    if (_isBusy || _isDisposed) return false;
    _isBusy = true;
    _failure = null;
    _notice = null;
    _notify();
    try {
      final grant = await request();
      if (grant.token.isEmpty || grant.user.id.isEmpty) {
        throw const AppFailure(FailureKind.invalidServerResponse);
      }
      final session = StoredSession(token: grant.token, user: grant.user);
      await _saveQuietly(session);
      _session = session;
      _status = AuthStatus.signedIn;
      return true;
    } on AppFailure catch (error) {
      _failure = error;
      return false;
    } catch (_) {
      _failure = const AppFailure(FailureKind.unexpected);
      return false;
    } finally {
      _isBusy = false;
      _notify();
    }
  }

  /// [CU-H2-E1] Cierra la sesión. [beforeSignOut] borra antes los datos locales de la
  /// cuenta (el borrador), si la pantalla lo pidió con confirmación [CU-H2-E2].
  Future<void> signOut({Future<void> Function()? beforeSignOut}) async {
    if (_isBusy || _isDisposed || _session == null) return;
    _isBusy = true;
    _failure = null;
    _notify();
    try {
      await beforeSignOut?.call();
      try {
        await _api.logout(_session!.token);
      } on AppFailure catch (error) {
        // Sin red se puede cerrar la sesión del teléfono. La sesión del servidor
        // mantiene su vencimiento habitual; nunca se inventa una revocación remota.
        if (error.kind != FailureKind.noConnection &&
            error.kind != FailureKind.sessionExpired) {
          rethrow;
        }
      }
      await _sessions.clear();
      _session = null;
      _status = AuthStatus.signedOut;
      _notice = StatusEvent.signedOut;
    } on AppFailure catch (error) {
      _failure = error;
    } catch (_) {
      _failure = const AppFailure(FailureKind.unexpected);
    } finally {
      _isBusy = false;
      _notify();
    }
  }

  /// [CU-H2-E3] Elimina la cuenta confirmando con la contraseña. Devuelve true si lo
  /// logró; con una contraseña incorrecta la cuenta se conserva [CU-H2-E4].
  Future<bool> deleteAccount(
    String password, {
    Future<void> Function()? beforeSignOut,
  }) async {
    if (_isBusy || _isDisposed || _session == null) return false;
    _isBusy = true;
    _failure = null;
    _notify();
    try {
      await _api.deleteAccount(_session!.token, password);
      await beforeSignOut?.call();
      await _sessions.clear();
      _session = null;
      _status = AuthStatus.signedOut;
      _notice = StatusEvent.accountDeleted;
      return true;
    } on AppFailure catch (error) {
      _failure = error;
      return false;
    } catch (_) {
      _failure = const AppFailure(FailureKind.unexpected);
      return false;
    } finally {
      _isBusy = false;
      _notify();
    }
  }

  /// [CU-H2-E5] La API rechazó la sesión (401): se vuelve a la bienvenida. El borrador
  /// de esta persona se conserva y se recupera cuando vuelva a ingresar.
  void handleSessionExpired() {
    _session = null;
    _status = AuthStatus.signedOut;
    _notice = StatusEvent.sessionExpired;
    unawaited(_clearQuietly());
    _notify();
  }

  /// Borra el fallo mostrado (por ejemplo, al cambiar de pantalla).
  void clearFailure() {
    _failure = null;
    _notify();
  }

  Future<void> _saveQuietly(StoredSession session) async {
    // No registrar errores del almacenamiento seguro: pueden incluir datos privados.
    try {
      await _sessions.save(session);
    } catch (_) {
      throw const AppFailure(FailureKind.unexpected);
    }
  }

  Future<void> _clearQuietly() async {
    try {
      await _sessions.clear();
    } catch (_) {
      _failure = const AppFailure(FailureKind.unexpected);
      _notify();
    }
  }

  void _notify() {
    if (!_isDisposed) notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
