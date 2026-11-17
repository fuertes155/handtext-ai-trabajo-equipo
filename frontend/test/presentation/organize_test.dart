// T903/T906: interfaz sobre los contratos T905 conservados de Juan.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:handtext_ai/models/export_format.dart';
import 'package:handtext_ai/models/history_entry.dart';
import '../support/app_tester.dart';
import '../support/fakes.dart';
import '../support/strings_es.dart';

final entry = HistoryEntry(
  id: 'doc-1',
  title: 'Biología',
  text: 'La CÉLULA y el núcleo',
  formats: {ExportFormat.pdf},
  savedAt: DateTime(2026, 11, 17),
);
void main() {
  testWidgets(
    'copiar usa exactamente el texto actual y no exporta ni cambia el borrador',
    (tester) async {
      final calls = <String>[];
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (call) async {
          if (call.method == 'Clipboard.setData') {
            calls.add((call.arguments as Map)['text'] as String);
          }
          return null;
        },
      );
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          null,
        ),
      );
      final h = TestHarness();
      await pumpHandTextApp(tester, h);
      await tapText(tester, es.pickFromGallery);
      await tapText(tester, es.acceptAndRecognize);
      await tapText(tester, es.consentAccept);
      const text = 'Corrección ñ 😀\nDos líneas';
      await tester.enterText(find.byType(TextField), text);
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip(es.moreActionsTooltip));
      await tester.pumpAndSettle();
      await tapText(tester, es.copyAllText);
      expect(calls, [text]);
      expect(find.text(es.textCopied), findsOneWidget);
      expect(h.controller.documentText, text);
      expect(h.drafts.stored, text);
      expect(h.api.exports, isEmpty);
    },
  );
  testWidgets('buscar por texto o título sin tildes; vacío y sin resultados', (
    tester,
  ) async {
    final h = TestHarness()..historyStore.stored = [entry];
    await pumpHandTextApp(tester, h);
    await tapText(tester, es.historyTitle);
    for (final query in ['BIOLOGIA', 'celula', 'núcleo']) {
      await tester.enterText(find.byType(TextField), query);
      await tester.pumpAndSettle();
      expect(find.text(entry.title), findsOneWidget);
    }
    await tester.enterText(find.byType(TextField), 'ausente');
    await tester.pumpAndSettle();
    expect(find.text(entry.title), findsNothing);
    expect(find.text(es.historyNoResults('ausente')), findsOneWidget);
    await tester.enterText(find.byType(TextField), '');
    await tester.pumpAndSettle();
    expect(find.text(entry.title), findsOneWidget);
    expect(h.historyStore.saves, 0);
  });
  testWidgets(
    'renombrar valida 1..60 Unicode, cancelar conserva y exportar mantiene nombre',
    (tester) async {
      final h = TestHarness()..historyStore.stored = [entry];
      await pumpHandTextApp(tester, h);
      await tapText(tester, es.historyTitle);
      await tester.tap(find.byTooltip(es.historyRename(entry.title)));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.widgetWithText(TextField, es.historyRenameLabel),
        'Cancelado',
      );
      await tapText(tester, es.cancel);
      expect(h.historyStore.saves, 0);
      await tester.tap(find.byTooltip(es.historyRename(entry.title)));
      await tester.pumpAndSettle();
      for (final name in ['   ', 'a' * 61, '😀' * 61]) {
        await tester.enterText(
          find.widgetWithText(TextField, es.historyRenameLabel),
          name,
        );
        await tester.pumpAndSettle();
        expect(
          tester
              .widget<FilledButton>(
                find.widgetWithText(FilledButton, es.historyRenameConfirm),
              )
              .onPressed,
          isNull,
        );
      }
      await tester.enterText(
        find.widgetWithText(TextField, es.historyRenameLabel),
        '  Mi guía 😀  ',
      );
      await tester.pumpAndSettle();
      await tapText(tester, es.historyRenameConfirm);
      final renamed = h.historyStore.stored.single;
      expect(renamed.title, 'Mi guía 😀');
      expect(renamed.text, entry.text);
      expect(renamed.id, entry.id);
      expect(renamed.renamed, isTrue);
      expect(find.text('Mi guía 😀'), findsOneWidget);
      await tapText(tester, 'Mi guía 😀');
      await tester.enterText(find.byType(TextField), 'Texto corregido');
      await tester.pumpAndSettle();
      await tapText(tester, es.export);
      await tapText(tester, es.pdfOption);
      expect(h.fileSaver.savedNames.single, 'Mi guía 😀.pdf');
      expect(h.historyStore.stored.single.title, 'Mi guía 😀');
      expect(h.historyStore.stored.single.text, 'Texto corregido');
    },
  );
}
