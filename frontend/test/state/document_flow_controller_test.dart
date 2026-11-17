// T025: regresiones del contrato público con documentos sintéticos.
import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:handtext_ai/models/app_failure.dart';
import 'package:handtext_ai/models/export_format.dart';
import 'package:handtext_ai/models/operation_status.dart';
import 'package:handtext_ai/models/recognition_result.dart';
import 'package:handtext_ai/services/file_save_service.dart';
import 'package:handtext_ai/state/document_flow_controller.dart';
import '../support/fakes.dart';

void main() {
  test(
    'inicia sin documento, purga temporales y valida antes de enviar',
    () async {
      final h = TestHarness(imageWidth: 599);
      addTearDown(h.controller.dispose);
      await h.controller.initialize();
      expect(h.controller.isReady, isTrue);
      expect(h.controller.step, FlowStep.start);
      expect(h.controller.documentText, isNull);
      expect(h.workingCopies.purges, 1);
      await h.controller.pickFromGallery();
      expect(h.controller.pages, isEmpty);
      expect(
        h.controller.status?.failure?.kind,
        FailureKind.imageDimensionsOutOfRange,
      );
      expect(h.workingCopies.deleted, hasLength(1));
      expect(h.api.recognizedImages, isEmpty);
    },
  );

  test(
    'sin consentimiento no envía; duplicados no multiplican solicitudes',
    () async {
      final h = TestHarness();
      addTearDown(h.controller.dispose);
      await h.controller.initialize();
      await h.controller.pickFromGallery();
      await h.controller.recognize(consentGranted: false);
      expect(h.api.recognizedImages, isEmpty);
      expect(h.controller.status?.event, StatusEvent.consentDeclined);
      final gate = h.api.recognitionGate = Completer<void>();
      final running = h.controller.recognize(consentGranted: true);
      expect(h.controller.isBusy, isTrue);
      await h.controller.recognize(consentGranted: true);
      await h.controller.pickFromGallery();
      await h.controller.cancelPreview();
      expect(h.api.recognizedImages, hasLength(1));
      expect(h.imageSource.galleryCalls, 1);
      expect(h.controller.step, FlowStep.preview);
      gate.complete();
      await running;
      expect(h.controller.isBusy, isFalse);
      expect(h.controller.documentText, 'Texto reconocido');
      expect(h.controller.pages, isEmpty);
      expect(h.workingCopies.deleted, hasLength(1));
      expect(h.drafts.stored, 'Texto reconocido');
    },
  );

  test(
    'un fallo conserva correcciones y ofrece reintento; solo éxito reemplaza',
    () async {
      final h = TestHarness();
      addTearDown(h.controller.dispose);
      await h.reachEditor();
      h.controller.updateText('Corrección propia ñ');
      await h.controller.flushDraft();
      h.controller.startAnotherImage();
      await h.controller.pickFromGallery();
      h.api.recognitionError = const AppFailure(FailureKind.noConnection);
      await h.controller.recognize(consentGranted: true);
      expect(h.controller.status?.action, StatusAction.retryRecognition);
      expect(h.controller.documentText, 'Corrección propia ñ');
      expect(h.drafts.stored, 'Corrección propia ñ');
      expect(h.controller.pages, hasLength(1));
      h.api.recognitionError = null;
      h.api.recognitionResult = const RecognitionResult(
        hasText: true,
        text: 'Nuevo texto',
      );
      await h.controller.recognize(consentGranted: false);
      expect(h.api.recognizedImages, hasLength(2));
      await h.controller.recognize(consentGranted: true);
      expect(h.controller.documentText, 'Nuevo texto');
      expect(h.drafts.stored, 'Nuevo texto');
    },
  );

  test('sin texto no destruye el documento anterior', () async {
    final h = TestHarness();
    addTearDown(h.controller.dispose);
    await h.reachEditor(text: 'Conservar');
    h.controller.startAnotherImage();
    await h.controller.pickFromGallery();
    h.api.recognitionResult = const RecognitionResult(hasText: false, text: '');
    await h.controller.recognize(consentGranted: true);
    expect(h.controller.documentText, 'Conservar');
    expect(h.controller.status?.event, StatusEvent.noTextFound);
    expect(h.controller.status?.action, StatusAction.replaceImage);
    h.controller.returnToDocument();
    expect(h.controller.step, FlowStep.editor);
  });

  test(
    'exporta texto vigente; vacío, fallo y cancelación no anuncian éxito',
    () async {
      final h = TestHarness();
      addTearDown(h.controller.dispose);
      await h.reachEditor();
      h.controller.updateText('   ');
      await h.controller.export(ExportFormat.pdf);
      expect(h.api.exports, isEmpty);
      expect(h.controller.status?.failure?.kind, FailureKind.emptyText);
      h.controller.updateText('Última edición €');
      h.api.exportError = const AppFailure(FailureKind.exportTimeout);
      await h.controller.export(ExportFormat.pdf);
      expect(h.controller.status?.kind, StatusKind.failure);
      expect(h.fileSaver.savedNames, isEmpty);
      expect(h.controller.documentText, 'Última edición €');
      h.api.exportError = null;
      h.fileSaver.outcome = const SaveCancelled();
      await h.controller.export(ExportFormat.pdf);
      expect(h.controller.status?.event, StatusEvent.saveCancelled);
      expect(h.controller.hasUnexportedChanges, isTrue);
      h.fileSaver.outcome = const SaveCompleted();
      await h.controller.export(ExportFormat.docx);
      expect(h.api.exports.last, ('Última edición €', ExportFormat.docx));
      expect(h.controller.status?.event, StatusEvent.saved);
      expect(h.controller.hasUnexportedChanges, isFalse);
      expect(h.drafts.stored, isNull);
    },
  );

  test(
    'recupera borrador y descartar ordena el borrado tras la última escritura',
    () async {
      final h = TestHarness()..drafts.stored = 'Recuperado';
      addTearDown(h.controller.dispose);
      await h.controller.initialize();
      expect(h.controller.documentText, 'Recuperado');
      expect(h.controller.hasUnexportedChanges, isTrue);
      expect(h.controller.status?.event, StatusEvent.draftRestored);
      h.controller.updateText('Cambio 1');
      h.controller.updateText('Cambio 2');
      await h.controller.flushDraft();
      expect(h.drafts.stored, 'Cambio 2');
      await h.controller.discardDocument();
      await h.controller.flushDraft();
      expect(h.drafts.stored, isNull);
      expect(h.controller.documentText, isNull);
      expect(h.controller.step, FlowStep.start);
    },
  );

  test(
    '401 avisa una vez y guarda correcciones sin fingir exportación',
    () async {
      final h = TestHarness();
      addTearDown(h.controller.dispose);
      await h.reachEditor();
      h.controller.updateText('Antes de vencer');
      h.api.exportError = const AppFailure(FailureKind.sessionExpired);
      await h.controller.export(ExportFormat.docx);
      expect(h.sessionExpiredCalls, 1);
      expect(h.drafts.stored, 'Antes de vencer');
      expect(h.controller.status?.failure?.kind, FailureKind.sessionExpired);
      expect(h.fileSaver.savedNames, isEmpty);
    },
  );
}
