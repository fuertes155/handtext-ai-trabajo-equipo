import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:handtext_ai/app.dart';
import 'package:handtext_ai/models/app_settings.dart';
import 'package:handtext_ai/models/user_account.dart';
import 'package:handtext_ai/presentation/app_lock_scope.dart';
import 'package:handtext_ai/presentation/screens/lock_screen.dart';
import 'package:handtext_ai/presentation/screens/settings_screen.dart';
import 'package:handtext_ai/presentation/screens/splash_screen.dart';
import 'package:handtext_ai/presentation/settings_scope.dart';
import 'package:handtext_ai/presentation/strings.dart';
import 'package:handtext_ai/services/session_store.dart';
import 'package:handtext_ai/state/app_lock_controller.dart';
import 'package:handtext_ai/state/auth_controller.dart';
import 'package:handtext_ai/state/settings_controller.dart';
import 'package:handtext_ai/theme/app_theme.dart';

import '../support/fakes.dart';
import '../support/strings_es.dart';

// Simula una comprobación de sesión aún en curso; permite probar el MaterialApp
// real sin atribuir aprobación a las pantallas del flujo todavía pendientes.
class SlowAccountApi extends FakeAuthApi {
  final pending = Completer<UserAccount>();
  @override
  Future<UserAccount> me(String token) => pending.future;
}

Widget shell(
  SettingsController settings,
  AppLockController lock,
  Widget home,
) => SettingsScope(
  settings: settings,
  child: AppLockScope(
    lock: lock,
    child: MaterialApp(
      locale: const Locale('es'),
      supportedLocales: AppStrings.supportedLocales,
      localizationsDelegates: [
        AppStrings.delegate(usesLocalAccounts: true),
        ...GlobalMaterialLocalizations.delegates,
      ],
      theme: AppTheme.dark(),
      home: home,
    ),
  ),
);

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets(
    'MaterialApp real resuelve idioma, persiste la elección y sigue el sistema',
    (tester) async {
      tester.platformDispatcher.accessibilityFeaturesTestValue =
          const FakeAccessibilityFeatures(disableAnimations: true);
      addTearDown(
        tester.platformDispatcher.clearAccessibilityFeaturesTestValue,
      );
      addTearDown(tester.platformDispatcher.clearLocalesTestValue);
      final settings = SettingsController(store: InMemorySettingsStore());
      await settings.load();
      final api = SlowAccountApi();
      final auth = AuthController(
        api: api,
        sessions: InMemorySessionStore()
          ..stored = const StoredSession(token: 'synthetic', user: testUser),
      );
      final lock = AppLockController(
        settings: settings,
        auth: auth,
        authenticator: FakeDeviceAuthenticator(),
      );
      await tester.pumpWidget(
        HandTextApp(
          auth: auth,
          settings: settings,
          lock: lock,
          createDocumentController: TestHarness().buildController,
        ),
      );
      await tester.pump();
      Locale locale() =>
          Localizations.localeOf(tester.element(find.byType(SplashScreen)));
      expect(locale().languageCode, 'es');
      await settings.setLanguage(AppLanguage.english);
      await tester.pump();
      await tester.pump();
      expect(locale().languageCode, 'en');
      await settings.setLanguage(AppLanguage.system);
      tester.platformDispatcher.localesTestValue = const [Locale('en')];
      await tester.pump();
      await tester.pump();
      expect(locale().languageCode, 'en');
      tester.platformDispatcher.localesTestValue = const [Locale('fr')];
      await tester.pump();
      await tester.pump();
      expect(locale().languageCode, 'es');
      await tester.pumpWidget(const SizedBox());
      api.pending.complete(testUser);
      await tester.pump();
      settings.dispose();
    },
  );

  for (final scale in [1.0, 2.0]) {
    testWidgets(
      'Ajustes $scale: verificación y desactivación del interruptor real',
      (tester) async {
        tester.view.physicalSize = const Size(411, 914);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        tester.platformDispatcher.textScaleFactorTestValue = scale;
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        final store = InMemorySettingsStore();
        final settings = SettingsController(store: store);
        await settings.load();
        final auth = AuthController(
          api: FakeAuthApi(),
          sessions: InMemorySessionStore()
            ..stored = const StoredSession(token: 'synthetic', user: testUser),
        );
        await auth.initialize();
        final verifier = FakeDeviceAuthenticator();
        final lock = AppLockController(
          settings: settings,
          auth: auth,
          authenticator: verifier,
        )..start();
        await tester.pumpWidget(shell(settings, lock, const SettingsScreen()));
        await tester.pumpAndSettle();
        await tester.scrollUntilVisible(find.text(es.appLockTitle), 200);
        await tester.tap(find.text(es.appLockTitle));
        await tester.pumpAndSettle();
        expect(verifier.calls, 1);
        expect(store.stored.appLock, isTrue);
        await tester.tap(find.text(es.appLockTitle));
        await tester.pumpAndSettle();
        expect(store.stored.appLock, isFalse);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
        lock.dispose();
        auth.dispose();
        settings.dispose();
      },
    );
  }

  testWidgets(
    'gate oculta el documento, cancelar no lo revela y desbloquear conserva texto',
    (tester) async {
      tester.platformDispatcher.accessibilityFeaturesTestValue =
          const FakeAccessibilityFeatures(disableAnimations: true);
      addTearDown(
        tester.platformDispatcher.clearAccessibilityFeaturesTestValue,
      );
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
      await auth.initialize();
      final verifier = FakeDeviceAuthenticator()..result = false;
      final lock = AppLockController(
        settings: settings,
        auth: auth,
        authenticator: verifier,
      )..start();
      final text = TextEditingController(text: 'synthetic document');
      await tester.pumpWidget(
        shell(
          settings,
          lock,
          AppLockGate(
            lock: lock,
            child: Scaffold(body: TextField(controller: text)),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text(es.lockedTitle), findsOneWidget);
      expect(find.text('synthetic document'), findsNothing);
      expect(
        find.text('synthetic document', skipOffstage: false),
        findsOneWidget,
      );
      expect(lock.isLocked, isTrue);
      verifier.result = true;
      await tester.tap(find.text(es.unlock));
      await tester.pumpAndSettle();
      expect(find.text(es.lockedTitle), findsNothing);
      expect(find.text('synthetic document'), findsOneWidget);
      expect(text.text, 'synthetic document');
      await tester.pumpWidget(const SizedBox());
      text.dispose();
      lock.dispose();
      auth.dispose();
      settings.dispose();
    },
  );
}
