import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:handtext_ai/models/app_settings.dart';
import 'package:handtext_ai/services/session_store.dart';
import 'package:handtext_ai/state/app_lock_controller.dart';
import 'package:handtext_ai/state/auth_controller.dart';
import 'package:handtext_ai/state/settings_controller.dart';
import '../support/fakes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('cancelar, verificar y desactivar mantienen el estado seguro', () async {
    final store = InMemorySettingsStore();
    final settings = SettingsController(store: store);
    await settings.load();
    final auth = AuthController(
      api: FakeAuthApi(),
      sessions: InMemorySessionStore()
        ..stored = const StoredSession(token: 'synthetic', user: testUser),
    );
    await auth.initialize();
    final verifier = FakeDeviceAuthenticator()..result = false;
    var clock = DateTime(2026, 11, 17);
    final lock = AppLockController(
      settings: settings,
      auth: auth,
      authenticator: verifier,
      now: () => clock,
    )..start();
    verifier.available = false;
    expect(await lock.enable('synthetic reason'), isFalse);
    expect(verifier.calls, 0);
    verifier.available = true;
    expect(await lock.enable('synthetic reason'), isFalse);
    expect(store.stored.appLock, isFalse);
    verifier.result = true;
    expect(await lock.enable('synthetic reason'), isTrue);
    expect(store.stored.appLock, isTrue);
    expect(lock.isLocked, isFalse);
    lock.didChangeAppLifecycleState(AppLifecycleState.inactive);
    clock = clock.add(const Duration(seconds: 60));
    lock.didChangeAppLifecycleState(AppLifecycleState.resumed);
    expect(lock.isLocked, isFalse);
    lock.didChangeAppLifecycleState(AppLifecycleState.inactive);
    lock.didChangeAppLifecycleState(AppLifecycleState.hidden);
    lock.didChangeAppLifecycleState(AppLifecycleState.paused);
    clock = clock.add(const Duration(seconds: 61));
    lock.didChangeAppLifecycleState(AppLifecycleState.hidden);
    lock.didChangeAppLifecycleState(AppLifecycleState.inactive);
    lock.didChangeAppLifecycleState(AppLifecycleState.resumed);
    expect(lock.isLocked, isTrue);
    verifier.result = false;
    await lock.unlock('synthetic reason');
    expect(lock.isLocked, isTrue);
    verifier.result = true;
    await lock.unlock('synthetic reason');
    expect(lock.isLocked, isFalse);
    await lock.disable();
    expect(store.stored.appLock, isFalse);
    lock.didChangeAppLifecycleState(AppLifecycleState.paused);
    clock = clock.add(const Duration(minutes: 5));
    lock.didChangeAppLifecycleState(AppLifecycleState.resumed);
    expect(lock.isLocked, isFalse);
    lock.dispose();
    auth.dispose();
    settings.dispose();
  });
  test(
    'abrir con sesión bloquea; cerrar y volver a ingresar no cambia la preferencia',
    () async {
      final settings = SettingsController(
        store: InMemorySettingsStore()
          ..stored = const AppSettings(appLock: true),
      );
      await settings.load();
      final auth = AuthController(
        api: FakeAuthApi(),
        sessions: InMemorySessionStore()
          ..stored = const StoredSession(token: 'synthetic', user: testUser),
      );
      final lock = AppLockController(
        settings: settings,
        auth: auth,
        authenticator: FakeDeviceAuthenticator(),
      )..start();
      await auth.initialize();
      expect(lock.isLocked, isTrue);
      await auth.signOut();
      expect(lock.isLocked, isFalse);
      expect(settings.settings.appLock, isTrue);
      await auth.signIn(email: 'test@example.invalid', password: 'synthetic');
      expect(lock.isLocked, isFalse);
      lock.dispose();
      auth.dispose();
      settings.dispose();
    },
  );
}
