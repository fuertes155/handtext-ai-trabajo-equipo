// Cuándo la app está bloqueada (tarea T1005; spec 011; research.md de 011, R3).
//
// - Con el bloqueo activo, la app empieza bloqueada si abre con una sesión guardada
//   [BL-H2-E1]. Sin sesión no hay nada que bloquear [BL-H2-E5].
// - Al volver después de más de 1 minuto en segundo plano, se bloquea; si pasó menos,
//   no [BL-H2-E4] (supuesto 2).
// - Desbloquear o activar el bloqueo pide la verificación del teléfono
//   (DeviceAuthenticator); si se cancela o falla, nada cambia [BL-H2-E3] [SC-1102].
// La hora se recibe desde afuera para probar sin esperar.

import 'package:flutter/widgets.dart';

import '../services/device_authenticator.dart';
import 'auth_controller.dart';
import 'settings_controller.dart';

class AppLockController extends ChangeNotifier with WidgetsBindingObserver {
  AppLockController({
    required SettingsController settings,
    required AuthController auth,
    required this.authenticator,
    DateTime Function() now = DateTime.now,
    this.timeout = const Duration(minutes: 1),
  }) : _settings = settings,
       _auth = auth,
       _now = now,
       // [BL-H2-E1] Con el bloqueo activo, la app abre bloqueada.
       _locked = settings.settings.appLock;

  final SettingsController _settings;
  final AuthController _auth;
  final DateTime Function() _now;

  /// Verificación del teléfono (huella, rostro o bloqueo de pantalla).
  final DeviceAuthenticator authenticator;

  /// Tiempo en segundo plano que hace bloquear al volver (supuesto 2).
  final Duration timeout;

  bool _locked;
  bool _verifying = false;
  DateTime? _backgroundedAt;
  bool _started = false;
  bool _disposed = false;
  late AuthStatus _previousStatus = _auth.status;

  /// [SC-1101] true: se ve la pantalla de bloqueo en lugar de la app. Solo con el
  /// bloqueo activo y una sesión iniciada.
  bool get isLocked {
    return _settings.settings.appLock &&
        _auth.status == AuthStatus.signedIn &&
        _locked;
  }

  /// Empieza a observar la app (al abrirla).
  void start() {
    if (_started || _disposed) return;
    _started = true;
    _previousStatus = _auth.status;
    WidgetsBinding.instance.addObserver(this);
    _auth.addListener(_onAuthChanged);
    _settings.addListener(notifyListeners);
  }

  @override
  void dispose() {
    _disposed = true;
    WidgetsBinding.instance.removeObserver(this);
    _auth.removeListener(_onAuthChanged);
    _settings.removeListener(notifyListeners);
    super.dispose();
  }

  /// [BL-H2-E5] Sin sesión no hay nada que bloquear; quien ingresa con su contraseña
  /// ya se verificó.
  void _onAuthChanged() {
    if (_auth.status == AuthStatus.signedOut ||
        (_auth.status == AuthStatus.signedIn &&
            _previousStatus == AuthStatus.signedOut)) {
      _locked = false;
      _backgroundedAt = null;
    }
    _previousStatus = _auth.status;
    notifyListeners();
  }

  /// [BL-H2-E4] Al volver después de más de [timeout] en segundo plano, se bloquea.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_verifying || _disposed) return;
    if (state == AppLifecycleState.resumed) {
      final departed = _backgroundedAt;
      _backgroundedAt = null;
      if (departed != null && _now().difference(departed) > timeout) {
        _locked = true;
        notifyListeners();
      }
    } else {
      // inactive/hidden/paused se suceden tanto al salir como al volver. La primera
      // marca permanece hasta resumed para no reiniciar el minuto al regresar.
      _backgroundedAt ??= _now();
    }
  }

  /// [BL-H2-E2] [BL-H2-E3] Pide la verificación; solo una a la vez.
  Future<void> unlock(String reason) async {
    if (_verifying || !isLocked || _disposed) return;
    _verifying = true;
    try {
      if (await authenticator.authenticate(reason)) {
        _locked = false;
        _backgroundedAt = null;
      }
    } catch (_) {
      // Un fallo del plugin nunca abre la app ni expone detalles del dispositivo.
    } finally {
      _verifying = false;
      if (!_disposed) notifyListeners();
    }
  }

  /// [BL-H1-E2] [BL-H1-E3] [SC-1104] Activa el bloqueo solo si la verificación es
  /// correcta. Devuelve si quedó activo.
  Future<bool> enable(String reason) async {
    if (_verifying || _disposed) return false;
    _verifying = true;
    try {
      if (!await authenticator.isAvailable() ||
          !await authenticator.authenticate(reason)) {
        return false;
      }
      await _settings.setAppLock(true);
      _locked = false;
      return true;
    } catch (_) {
      return false;
    } finally {
      _verifying = false;
      if (!_disposed) notifyListeners();
    }
  }

  /// [BL-H3-E1] Desactiva el bloqueo: la app deja de pedir la verificación.
  Future<void> disable() async {
    await _settings.setAppLock(false);
    _locked = false;
    _backgroundedAt = null;
    if (!_disposed) notifyListeners();
  }
}
