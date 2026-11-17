// T503/T505: primer uso real de widgets con servicios sintéticos.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:handtext_ai/models/app_settings.dart';
import 'package:handtext_ai/models/user_account.dart';
import 'package:handtext_ai/presentation/screens/tips_screen.dart';
import '../support/app_tester.dart';
import '../support/fakes.dart';
import '../support/strings_es.dart';

void main() {
  testWidgets(
    'primera vez recorre cuatro consejos, Empezar persiste por teléfono',
    (tester) async {
      final h = TestHarness()..settingsStore.stored = const AppSettings();
      await pumpHandTextApp(tester, h);
      expect(find.byType(TipsScreen), findsOneWidget);
      for (var i = 0; i < 4; i++) {
        expect(find.text(es.tipOf(i + 1, 4)), findsOneWidget);
        expect(find.text(es.tips[i].$1), findsOneWidget);
        if (i < 3) await tapText(tester, es.tipsNext);
      }
      await tapText(tester, es.tipsStart);
      expect(h.settingsStore.stored.tipsSeen, isTrue);
      expect(find.byType(TipsScreen), findsNothing);
      expect(find.text(es.takePhoto), findsOneWidget);
      expect(h.imageSource.cameraCalls, 0);
      expect(h.api.recognizedImages, isEmpty);
      await h.auth.signOut(beforeSignOut: () => h.controller.clearLocalData());
      await tester.pumpAndSettle();
      h.authApi.user = const UserAccount(
        id: 'otra-cuenta',
        displayName: 'Otra',
        email: 'otra@example.test',
      );
      await h.auth.signIn(
        email: 'otra@example.test',
        password: 'synthetic-password',
      );
      await tester.pumpAndSettle();
      expect(find.byType(TipsScreen), findsNothing);
      expect(find.text(es.greeting('Otra')), findsOneWidget);
    },
  );
  for (final back in [false, true]) {
    testWidgets('saltar o atrás marca vistos ($back)', (tester) async {
      final h = TestHarness()..settingsStore.stored = const AppSettings();
      await pumpHandTextApp(tester, h);
      if (back) {
        await tester.binding.handlePopRoute();
        await tester.pumpAndSettle();
      } else {
        await tapText(tester, es.tipsSkip);
      }
      expect(find.byType(TipsScreen), findsNothing);
      expect(h.settingsStore.stored.tipsSeen, isTrue);
      await tester.pumpWidget(const SizedBox());
      await pumpHandTextApp(
        tester,
        TestHarness()..settingsStore.stored = h.settingsStore.stored,
      );
      expect(find.byType(TipsScreen), findsNothing);
    });
  }
  testWidgets(
    'se pueden volver a abrir desde inicio y Ajustes; atrás retorna',
    (tester) async {
      final h = TestHarness();
      await pumpHandTextApp(tester, h);
      await tapText(tester, es.tipsLink);
      expect(find.byType(TipsScreen), findsOneWidget);
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text(es.takePhoto), findsOneWidget);
      await tester.scrollUntilVisible(
        find.byTooltip(es.accountTooltip),
        -250,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.byTooltip(es.accountTooltip));
      await tester.pumpAndSettle();
      await tapText(tester, es.settingsTitle);
      await tapText(tester, es.tipsLink);
      expect(find.byType(TipsScreen), findsOneWidget);
      await tapText(tester, es.tipsSkip);
      expect(find.text(es.settingsTitle), findsOneWidget);
      expect(h.settingsStore.stored.tipsSeen, isTrue);
    },
  );
  testWidgets('consejo al 200 % se desplaza y tiene encabezado semántico', (
    tester,
  ) async {
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    final semantics = tester.ensureSemantics();

    await loadPoppins(tester);
    await pumpHandTextApp(
      tester,
      TestHarness()..settingsStore.stored = const AppSettings(),
    );
    expect(
      tester.getSemantics(find.text(es.tips.first.$1)),
      isSemantics(isHeader: true, label: es.tips.first.$1),
    );
    for (var i = 0; i < 3; i++) {
      await tapText(tester, es.tipsNext);
    }
    await tapText(tester, es.tipsStart);
    expect(tester.takeException(), isNull);
    semantics.dispose();
  });
}
