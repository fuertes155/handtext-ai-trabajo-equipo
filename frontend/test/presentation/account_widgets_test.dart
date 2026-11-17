import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:handtext_ai/models/app_failure.dart';
import 'package:handtext_ai/models/operation_status.dart';
import 'package:handtext_ai/models/history_entry.dart';
import 'package:handtext_ai/models/export_format.dart';
import 'package:handtext_ai/presentation/screens/auth/auth_flow.dart';
import 'package:handtext_ai/presentation/settings_scope.dart';
import 'package:handtext_ai/presentation/strings.dart';
import 'package:handtext_ai/presentation/widgets/account_menu.dart';
import 'package:handtext_ai/presentation/widgets/confirm_dialog.dart';
import 'package:handtext_ai/presentation/widgets/consent_dialog.dart';
import 'package:handtext_ai/presentation/widgets/password_field.dart';
import 'package:handtext_ai/presentation/widgets/status_banner.dart';
import 'package:handtext_ai/presentation/widgets/scanner_logo.dart';
import 'package:handtext_ai/presentation/widgets/scan_overlay.dart';
import 'package:handtext_ai/state/auth_controller.dart';
import 'package:handtext_ai/theme/app_theme.dart';

import '../support/app_tester.dart';
import '../support/fakes.dart';
import '../support/strings_es.dart';

Widget shell(TestHarness h, Widget child) => SettingsScope(
  settings: h.settings,
  child: MaterialApp(
    locale: const Locale('es'),
    supportedLocales: AppStrings.supportedLocales,
    localizationsDelegates: [
      AppStrings.delegate(usesLocalAccounts: true),
      ...GlobalMaterialLocalizations.delegates,
    ],
    theme: AppTheme.dark(),
    home: Scaffold(body: child),
  ),
);

Future<void> prepare(WidgetTester tester) async {
  tester.platformDispatcher.accessibilityFeaturesTestValue =
      const FakeAccessibilityFeatures(disableAnimations: true);
  addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
  tester.view.physicalSize = const Size(411, 914);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

void main() {
  testWidgets(
    'eliminar con contraseña aceptada limpia sesión, borrador e historial propios',
    (tester) async {
      await prepare(tester);
      final h = TestHarness();
      h.drafts.stored = 'synthetic draft';
      h.historyStore.stored = [
        HistoryEntry(
          id: 'synthetic-id',
          title: 'synthetic title',
          text: 'synthetic document',
          formats: {ExportFormat.docx},
          savedAt: DateTime(2026, 11, 17),
        ),
      ];
      await h.auth.initialize();
      await h.controller.initialize();
      await tester.pumpWidget(
        shell(h, AccountButton(auth: h.auth, documents: h.controller)),
      );
      await tester.tap(find.byTooltip(es.accountTooltip));
      await tester.pumpAndSettle();
      await tapText(tester, es.deleteAccount);
      await enterField(tester, es.passwordLabel, 'synthetic-correct');
      await tapText(tester, es.deleteAccountConfirm);
      expect(h.auth.status, AuthStatus.signedOut);
      expect(h.sessions.stored, isNull);
      expect(h.drafts.stored, isNull);
      expect(h.historyStore.stored, isEmpty);
      expect(h.historyStore.deletes, 1);
      expect(h.controller.documentText, isNull);
      await tester.pumpWidget(const SizedBox());
      h.controller.dispose();
      h.auth.dispose();
      h.settings.dispose();
    },
  );

  testWidgets(
    'logo y escaneo respetan quitar animaciones sin perder su estado visible',
    (tester) async {
      await prepare(tester);
      final h = TestHarness();
      await tester.pumpWidget(
        shell(
          h,
          const SizedBox.square(
            dimension: 180,
            child: Stack(
              fit: StackFit.expand,
              children: [ScannerLogo(), ScanOverlay()],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(ScannerLogo), findsOneWidget);
      expect(find.byType(ScanOverlay), findsOneWidget);
      expect(tester.binding.hasScheduledFrame, isFalse);
      tester.platformDispatcher.accessibilityFeaturesTestValue =
          const FakeAccessibilityFeatures(disableAnimations: false);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.binding.hasScheduledFrame, isTrue);
      tester.platformDispatcher.accessibilityFeaturesTestValue =
          const FakeAccessibilityFeatures(disableAnimations: true);
      await tester.pumpAndSettle();
      expect(tester.binding.hasScheduledFrame, isFalse);
      await tester.pumpWidget(const SizedBox());
      h.auth.dispose();
      h.settings.dispose();
    },
  );

  testWidgets(
    'autorizar es explícito en cada envío y cerrar equivale a rechazar',
    (tester) async {
      await prepare(tester);
      final h = TestHarness();
      bool? decision;
      await tester.pumpWidget(
        shell(
          h,
          Builder(
            builder: (context) => TextButton(
              onPressed: () async {
                decision = await showConsentDialog(context, imageCount: 3);
              },
              child: const Text('open'),
            ),
          ),
        ),
      );
      await tapText(tester, 'open');
      expect(find.text(es.consentTitleFor(3)), findsOneWidget);
      await tapText(tester, es.consentDecline);
      expect(decision, isFalse);
      await tapText(tester, 'open');
      await tapText(tester, es.consentAccept);
      expect(decision, isTrue);
      decision = null;
      await tapText(tester, 'open');
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(decision, isFalse);
      h.auth.dispose();
      h.settings.dispose();
    },
  );

  testWidgets('confirmación destructiva conserva el rechazo al cancelar', (
    tester,
  ) async {
    await prepare(tester);
    final h = TestHarness();
    bool? decision;
    await tester.pumpWidget(
      shell(
        h,
        Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              decision = await showConfirmDialog(
                context,
                title: 'synthetic title',
                message: 'synthetic message',
                confirmLabel: 'confirm',
                destructive: true,
              );
            },
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tapText(tester, 'open');
    await tapText(tester, es.cancel);
    expect(decision, isFalse);
    await tapText(tester, 'open');
    await tapText(tester, 'confirm');
    expect(decision, isTrue);
    h.auth.dispose();
    h.settings.dispose();
  });

  testWidgets('contraseña oculta, sin sugerencias y con guía de longitud', (
    tester,
  ) async {
    await prepare(tester);
    final h = TestHarness();
    final text = TextEditingController();
    await tester.pumpWidget(
      shell(
        h,
        Padding(
          padding: const EdgeInsets.all(24),
          child: PasswordField(
            controller: text,
            label: es.passwordLabel,
            showStrength: true,
          ),
        ),
      ),
    );
    expect(
      tester.widget<TextField>(find.byType(TextField)).obscureText,
      isTrue,
    );
    expect(
      tester.widget<TextField>(find.byType(TextField)).enableSuggestions,
      isFalse,
    );
    await tester.enterText(find.byType(TextField), '123456789012');
    await tester.pump();
    expect(find.text(es.passwordStrength(2)), findsOneWidget);
    await tester.tap(find.byTooltip(es.showPassword));
    await tester.pump();
    expect(
      tester.widget<TextField>(find.byType(TextField)).obscureText,
      isFalse,
    );
    await tester.pumpWidget(const SizedBox());
    text.dispose();
    h.auth.dispose();
    h.settings.dispose();
  });

  testWidgets(
    'aviso es una región viva con acción y contenido legible al 200%',
    (tester) async {
      await prepare(tester);
      final h = TestHarness();
      final semantics = tester.ensureSemantics();
      var actions = 0;
      tester.platformDispatcher.textScaleFactorTestValue = 2;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      const status = OperationStatus.failure(
        AppFailure(FailureKind.noConnection),
      );
      await tester.pumpWidget(
        shell(
          h,
          SingleChildScrollView(
            child: StatusBanner(
              status: status,
              actionLabel: es.retry,
              onAction: () => actions++,
            ),
          ),
        ),
      );
      expect(
        tester.getSemantics(find.text(es.statusText(status))),
        isSemantics(isLiveRegion: true),
      );
      await tapText(tester, es.retry);
      expect(actions, 1);
      expect(tester.takeException(), isNull);
      semantics.dispose();
      h.auth.dispose();
      h.settings.dispose();
    },
  );

  testWidgets(
    'avatar de 48 dp no anuncia inicial ni absorbe otros encabezados',
    (tester) async {
      await prepare(tester);
      final h = TestHarness();
      await h.auth.initialize();
      await h.controller.initialize();
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(
        shell(
          h,
          Row(
            children: [
              Expanded(
                child: Semantics(
                  header: true,
                  child: const Text('separate title'),
                ),
              ),
              AccountButton(auth: h.auth, documents: h.controller),
            ],
          ),
        ),
      );
      final avatar = find.byTooltip(es.accountTooltip);
      expect(tester.getSize(avatar), const Size(48, 48));
      expect(find.bySemanticsLabel(testUser.initial), findsNothing);
      expect(
        tester.getSemantics(avatar),
        isSemantics(
          tooltip: es.accountTooltip,
          label: '',
          hasTapAction: true,
          isHeader: false,
        ),
      );
      semantics.dispose();
      await tester.pumpWidget(const SizedBox());
      h.controller.dispose();
      h.auth.dispose();
      h.settings.dispose();
    },
  );

  testWidgets(
    'menú confirma texto pendiente; cancelar lo conserva y cerrar limpia',
    (tester) async {
      await prepare(tester);
      final h = TestHarness();
      await h.auth.initialize();
      await h.reachEditor(text: 'synthetic document');
      await tester.pumpWidget(
        shell(h, AccountButton(auth: h.auth, documents: h.controller)),
      );
      await tester.tap(find.byTooltip(es.accountTooltip));
      await tester.pumpAndSettle();
      await tapText(tester, es.signOut);
      await tapText(tester, es.cancel);
      expect(h.auth.status, AuthStatus.signedIn);
      expect(h.controller.documentText, 'synthetic document');
      await tester.tap(find.byTooltip(es.accountTooltip));
      await tester.pumpAndSettle();
      await tapText(tester, es.signOut);
      await tapText(tester, es.signOut);
      expect(h.auth.status, AuthStatus.signedOut);
      expect(h.controller.documentText, isNull);
      await tester.pumpWidget(const SizedBox());
      h.controller.dispose();
      h.auth.dispose();
      h.settings.dispose();
    },
  );

  testWidgets('eliminación pide contraseña y el diálogo se desplaza al 200%', (
    tester,
  ) async {
    await prepare(tester);
    final h = TestHarness();
    await h.auth.initialize();
    await h.controller.initialize();
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    h.authApi.deleteError = const AppFailure(FailureKind.invalidCredentials);
    await tester.pumpWidget(
      shell(h, AccountButton(auth: h.auth, documents: h.controller)),
    );
    await tester.tap(find.byTooltip(es.accountTooltip));
    await tester.pumpAndSettle();
    await tapText(tester, es.deleteAccount);
    await enterField(tester, es.passwordLabel, 'synthetic-wrong');
    await tapText(tester, es.deleteAccountConfirm);
    expect(h.auth.status, AuthStatus.signedIn);
    expect(h.auth.failure?.kind, FailureKind.invalidCredentials);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    h.controller.dispose();
    h.auth.dispose();
    h.settings.dispose();
  });

  testWidgets(
    'registro real exige consentimiento y conserva sesión al aceptarlo',
    (tester) async {
      await prepare(tester);
      final h = TestHarness(signedIn: false);
      await h.auth.initialize();
      await tester.pumpWidget(shell(h, AuthFlow(auth: h.auth)));
      await tester.pumpAndSettle();
      await tapText(tester, es.createAccount);
      await enterField(tester, es.nameLabel, 'Persona sintética');
      await enterField(tester, es.emailLabel, 'test@example.invalid');
      await enterField(tester, es.passwordLabel, 'synthetic-password');
      await enterField(tester, es.confirmPasswordLabel, 'synthetic-password');
      await tapText(tester, es.createAccount);
      expect(h.authApi.calls, isEmpty);
      expect(
        find.text(
          es.failureText(const AppFailure(FailureKind.dataPolicyNotAccepted)),
        ),
        findsOneWidget,
      );
      await tester.ensureVisible(find.byType(CheckboxListTile));
      await tester.tap(find.byType(CheckboxListTile));
      await tester.pumpAndSettle();
      await tapText(tester, es.createAccount);
      expect(h.authApi.calls, ['register']);
      expect(h.auth.status, AuthStatus.signedIn);
      expect(h.sessions.stored?.token, 'token-nuevo');
      await tester.pumpWidget(const SizedBox());
      h.auth.dispose();
      h.settings.dispose();
    },
  );
}
