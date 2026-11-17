// T210/T213/T216: widgets reales sobre servicios sintéticos, sin OCR ni teléfono.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:handtext_ai/models/app_failure.dart';
import 'package:handtext_ai/models/export_format.dart';
import 'package:handtext_ai/models/recognition_result.dart';
import 'package:handtext_ai/presentation/widgets/review_text_controller.dart';
import 'package:handtext_ai/services/image_rules.dart';
import 'package:handtext_ai/services/file_save_service.dart';
import 'package:handtext_ai/theme/aurora.dart';

import '../support/app_tester.dart';
import '../support/fakes.dart';
import '../support/strings_es.dart';

Future<TestHarness> preview(WidgetTester tester, [TestHarness? harness]) async {
  final h = harness ?? TestHarness();
  await pumpHandTextApp(tester, h);
  await tapText(tester, es.pickFromGallery);
  return h;
}

Future<void> recognize(WidgetTester tester) async {
  await tapText(tester, es.acceptAndRecognize);
  await tapText(tester, es.consentAccept);
}

void main() {
  testWidgets('cancelar el guardado no ofrece compartir ni registra éxito', (
    tester,
  ) async {
    final h = TestHarness()..fileSaver.outcome = const SaveCancelled();
    await preview(tester, h);
    await recognize(tester);
    final before = h.controller.documentText;
    await tapText(tester, es.export);
    await tapText(tester, es.wordOption);
    expect(find.text(es.share), findsNothing);
    expect(h.sharer.shared, isEmpty);
    expect(h.controller.documentText, before);
    expect(h.controller.history.entries, isEmpty);
  });

  testWidgets(
    'las marcas pintan fondo y subrayado, sin cambiar texto ni composición IME',
    (tester) async {
      final controller = ReviewTextController(
        text: 'x duda z',
        uncertainRanges: () => [const TextRange(start: 2, end: 6)],
      );
      late BuildContext context;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (value) {
              context = value;
              return const SizedBox();
            },
          ),
        ),
      );
      final span = controller.buildTextSpan(
        context: context,
        withComposing: true,
      );
      expect(span.toPlainText(), 'x duda z');
      final marked = span.children!.whereType<TextSpan>().singleWhere(
        (s) => s.text == 'duda',
      );
      expect(marked.style!.backgroundColor, Aurora.uncertainFillLight);
      expect(marked.style!.decoration, TextDecoration.underline);
      expect(marked.style!.decorationStyle, TextDecorationStyle.wavy);
      controller.value = const TextEditingValue(
        text: 'x duda z',
        composing: TextRange(start: 2, end: 6),
      );
      expect(
        controller
            .buildTextSpan(context: context, withComposing: true)
            .toPlainText(),
        'x duda z',
      );
      controller.dispose();
    },
  );

  testWidgets(
    'siguiente, aceptar y corregir cambian las marcas conservando la autoridad del texto',
    (tester) async {
      final h = TestHarness()
        ..api.recognitionResult = const RecognitionResult(
          hasText: true,
          text: 'Hola mundo final',
          uncertainRanges: [
            TextRange(start: 0, end: 4),
            TextRange(start: 5, end: 10),
          ],
        );
      await preview(tester, h);
      await recognize(tester);
      expect(find.text(es.uncertainWordsCount(2)), findsOneWidget);
      await tapText(tester, es.nextUncertainWord);
      final editor = tester.widget<TextField>(find.byType(TextField));
      expect(
        editor.controller!.selection,
        const TextSelection(baseOffset: 0, extentOffset: 4),
      );
      await tapText(tester, es.acceptUncertainWord);
      expect(h.controller.documentText, 'Hola mundo final');
      expect(h.controller.uncertainRanges, [
        const TextRange(start: 5, end: 10),
      ]);
      await tapText(tester, es.nextUncertainWord);
      expect(
        editor.controller!.selection,
        const TextSelection(baseOffset: 5, extentOffset: 10),
      );
      await tester.enterText(find.byType(TextField), 'Hola tierra final');
      await tester.pumpAndSettle();
      expect(h.controller.uncertainRanges, isEmpty);
      expect(h.controller.documentText, 'Hola tierra final');
      expect(find.text(es.nextUncertainWord), findsNothing);
    },
  );

  testWidgets(
    'cancelar recorte conserva la misma imagen y no altera el original',
    (tester) async {
      final h = await preview(tester);
      final original = h.controller.pendingImage!;
      await tapText(tester, es.editImage);
      expect(h.imageEditor.edited, [original.workingCopy]);
      expect(h.controller.pendingImage, same(original));
      expect(find.text(es.restoreOriginalImage), findsNothing);
    },
  );

  testWidgets(
    'recorte confirmado cambia la copia y restaurar recupera exactamente el original',
    (tester) async {
      final h = await preview(tester);
      final original = h.controller.pendingImage!;
      final cropped = fakePngBytes()..[20] = 7;
      h.imageEditor.result = pickedFile(cropped);
      await tapText(tester, es.editImage);
      final working = h.controller.pendingImage!;
      expect(working.bytes, cropped);
      expect(original.bytes[20], 0);
      expect(h.controller.canRestoreOriginalImage, isTrue);
      await tapText(tester, es.restoreOriginalImage);
      expect(h.controller.pendingImage!.bytes, original.bytes);
      expect(h.controller.canRestoreOriginalImage, isFalse);
      expect(h.workingCopies.deleted, contains(working.workingCopy));
    },
  );

  testWidgets(
    'un recorte inválido limpia la copia fallida y conserva la imagen anterior',
    (tester) async {
      final h = TestHarness(
        readDimensions: (bytes) async =>
            ImageDimensions(bytes[20] == 7 ? 500 : 1200, 1600),
      );
      await preview(tester, h);
      final original = h.controller.pendingImage!;
      h.imageEditor.result = pickedFile(fakePngBytes()..[20] = 7);
      await tapText(tester, es.editImage);
      expect(h.controller.pendingImage, same(original));
      expect(
        h.controller.status!.failure!.kind,
        FailureKind.imageDimensionsOutOfRange,
      );
      expect(h.workingCopies.deleted, contains(h.workingCopies.created.last));
    },
  );

  testWidgets(
    'compartir envía exactamente el archivo guardado y conserva el texto ante fallo',
    (tester) async {
      final h = TestHarness()
        ..api.recognitionResult = const RecognitionResult(
          hasText: true,
          text: 'Título sintético\nContenido',
        );
      await preview(tester, h);
      await recognize(tester);
      await tapText(tester, es.export);
      await tapText(tester, es.wordOption);
      expect(h.fileSaver.savedNames.single, 'Título sintético.docx');
      await tapText(tester, es.share);
      expect(h.sharer.shared.single, (
        h.api.exportBytes,
        h.fileSaver.savedNames.single,
        ExportFormat.docx,
      ));
      h.sharer.error = const AppFailure(FailureKind.shareFailed);
      await tapText(tester, es.share);
      expect(h.controller.documentText, 'Título sintético\nContenido');
      expect(h.controller.status!.failure!.kind, FailureKind.shareFailed);
    },
  );
}
