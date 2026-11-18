// T1008: LocalDeviceAuthenticator real. El controlador y el diálogo Android no
// se simulan. Sesión sintética en memoria; ajustes y borrador en archivos privados.
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:local_auth/local_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:handtext_ai/app.dart';
import 'package:handtext_ai/models/app_settings.dart';
import 'package:handtext_ai/models/document_draft.dart';
import 'package:handtext_ai/presentation/screens/lock_screen.dart';
import 'package:handtext_ai/services/device_authenticator.dart';
import 'package:handtext_ai/services/draft_storage.dart';
import 'package:handtext_ai/services/history_store.dart';
import 'package:handtext_ai/services/settings_store.dart';
import 'package:handtext_ai/state/app_lock_controller.dart';
import 'package:handtext_ai/state/document_flow_controller.dart';
import 'package:handtext_ai/state/document_history.dart';
import 'package:handtext_ai/state/settings_controller.dart';
import '../test/support/fakes.dart';
import '../test/support/app_tester.dart';
import '../test/support/strings_es.dart';

void event(String phase) =>
    debugPrint('NATIVE_EVENT ${jsonEncode({'phase': phase})}');

class ObservedAuthenticator implements DeviceAuthenticator {
  final _real = LocalDeviceAuthenticator();
  final results = <bool>[];
  @override
  Future<bool> isAvailable() => _real.isAvailable();
  @override
  Future<bool> authenticate(String reason) async {
    final result = await _real.authenticate(reason);
    results.add(result);
    return result;
  }
}

Future<void> waitFor(WidgetTester tester, bool Function() condition) async {
  final end = DateTime.now().add(const Duration(minutes: 3));
  while (!condition() && DateTime.now().isBefore(end)) {
    await tester.pump(const Duration(milliseconds: 150));
  }
  expect(
    condition(),
    isTrue,
    reason: 'No terminó la operación nativa esperada',
  );
  await tester.pump();
}

Future<void> tooltip(WidgetTester tester, String name) async {
  final finder = find.byTooltip(name);
  if (finder.evaluate().isEmpty) {
    await tester.scrollUntilVisible(
      finder,
      -200,
      scrollable: find.byType(Scrollable).first,
    );
  }
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets(
    'T1008: cancelación, PIN, más de un minuto y huella Android reales',
    (tester) async {
      expect(Platform.isAndroid, isTrue);
      tester.platformDispatcher.accessibilityFeaturesTestValue =
          const FakeAccessibilityFeatures(disableAnimations: true);
      addTearDown(
        tester.platformDispatcher.clearAccessibilityFeaturesTestValue,
      );
      final folder = await (await getApplicationSupportDirectory()).createTemp(
        'native-lock-',
      );
      addTearDown(() => folder.delete(recursive: true));
      final store = FileSettingsStore(directory: () async => folder);
      await store.save(const AppSettings(tipsSeen: true));
      final settings = SettingsController(store: store);
      await settings.load();
      final drafts = FileDraftStore(directory: () async => folder);
      const document =
          'Documento sintético privado: debe conservarse después del bloqueo.';
      await drafts.save(const DocumentDraft(document));
      final h = TestHarness();
      final native = ObservedAuthenticator();
      expect(await native.isAvailable(), isTrue);
      expect(
        await LocalAuthentication().getAvailableBiometrics(),
        isNotEmpty,
        reason:
            'La huella del AVD debe estar inscrita; no usar un autenticador falso',
      );
      final lock = AppLockController(
        settings: settings,
        auth: h.auth,
        authenticator: native,
      );
      late DocumentFlowController documents;
      await tester.pumpWidget(
        HandTextApp(
          auth: h.auth,
          settings: settings,
          lock: lock,
          createDocumentController: (user, expired) =>
              documents = DocumentFlowController(
                imageSource: h.imageSource,
                cameraPermission: h.cameraPermission,
                readImageDimensions: fixedDimensions(1200, 1600),
                workingCopies: h.workingCopies,
                api: h.api,
                fileSaver: h.fileSaver,
                drafts: drafts,
                imageEditor: h.imageEditor,
                sharer: h.sharer,
                scanner: h.scanner,
                history: DocumentHistory(
                  store: FileHistoryStore(
                    directory: () async => folder,
                    fileName: historyFileNameFor(user.id),
                  ),
                ),
                onSessionExpired: expired,
              ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text(document), findsOneWidget);
      await tooltip(tester, es.accountTooltip);
      await tapText(tester, es.settingsTitle);
      await tester.ensureVisible(find.byType(SwitchListTile));
      await tester.pumpAndSettle();
      event('enable_cancel');
      await tester.tap(find.byType(SwitchListTile));
      await waitFor(tester, () => native.results.length == 1);
      expect(native.results.last, isFalse);
      expect(settings.settings.appLock, isFalse);
      expect((await store.load()).appLock, isFalse);
      event('enable_pin');
      await tester.tap(find.byType(SwitchListTile));
      await waitFor(tester, () => settings.settings.appLock);
      expect(native.results.last, isTrue);
      expect((await store.load()).appLock, isTrue);
      await tooltip(tester, es.back);
      expect(find.text(document), findsOneWidget);
      event('background_long');
      await waitFor(tester, () => native.results.length == 3);
      expect(lock.isLocked, isTrue);
      expect(native.results.last, isFalse);
      expect(find.byType(LockScreen), findsOneWidget);
      expect(find.text(document), findsNothing);
      expect(documents.documentText, document);
      expect((await drafts.load())?.text, document);
      event('unlock_fingerprint');
      await tester.tap(find.text(es.unlock));
      await waitFor(tester, () => !lock.isLocked);
      expect(native.results.length, 4);
      expect(native.results.last, isTrue);
      expect(find.text(document), findsOneWidget);
      expect((await drafts.load())?.text, document);
      await tooltip(tester, es.accountTooltip);
      await tapText(tester, es.settingsTitle);
      await tester.ensureVisible(find.byType(SwitchListTile));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(SwitchListTile));
      await tester.pumpAndSettle();
      expect(settings.settings.appLock, isFalse);
      expect((await store.load()).appLock, isFalse);
      await tooltip(tester, es.back);
      event('background_disabled');
      // Esperar retorno real del host; el reloj no se adelanta artificialmente.
      await Future<void>.delayed(const Duration(seconds: 5));
      await tester.pumpAndSettle();
      expect(lock.isLocked, isFalse);
      expect(native.results.length, 4);
      expect(find.text(document), findsOneWidget);
      event('complete');
    },
  );
}
