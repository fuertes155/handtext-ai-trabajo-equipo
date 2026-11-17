// T045: permisos y captura sin cámara ni datos personales.
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:handtext_ai/models/app_failure.dart';
import 'package:handtext_ai/models/picked_image.dart';
import 'package:handtext_ai/services/camera_permission_service.dart';
import 'package:handtext_ai/state/document_flow_controller.dart';
import '../support/fakes.dart';

void main() {
  for (final (permission, failure) in [
    (CameraPermission.denied, FailureKind.cameraPermissionDenied),
    (
      CameraPermission.permanentlyDenied,
      FailureKind.cameraPermissionPermanentlyDenied,
    ),
  ]) {
    test('permiso $permission impide abrir cámara y no crea copia', () async {
      final h = TestHarness();
      addTearDown(h.controller.dispose);
      h.cameraPermission.result = permission;
      await h.controller.initialize();
      await h.controller.takePhoto();
      expect(h.cameraPermission.requests, 1);
      expect(h.imageSource.cameraCalls, 0);
      expect(h.workingCopies.created, isEmpty);
      expect(h.controller.status?.failure?.kind, failure);
      expect(h.controller.isBusy, isFalse);
    });
  }
  test(
    'captura y repetición usan copia; cancelar repetición conserva anterior',
    () async {
      final h = TestHarness();
      addTearDown(h.controller.dispose);
      await h.controller.initialize();
      await h.controller.takePhoto();
      final first = h.controller.pendingImage!;
      expect(first.origin, ImageOrigin.camera);
      expect(h.controller.step, FlowStep.preview);
      h.imageSource.cameraResult = null;
      await h.controller.replaceImage();
      expect(h.controller.pendingImage, same(first));
      expect(h.workingCopies.deleted, isEmpty);
      h.imageSource.cameraResult = pickedFile(fakePngBytes());
      await h.controller.replaceImage();
      expect(h.imageSource.cameraCalls, 3);
      expect(h.controller.pendingImage, isNot(same(first)));
      expect(h.workingCopies.deleted.single, same(first.workingCopy));
      await h.controller.cancelPreview();
      expect(h.controller.pages, isEmpty);
      expect(h.workingCopies.deleted, hasLength(2));
      expect(h.api.recognizedImages, isEmpty);
    },
  );
  test(
    'cancelación inicial y cámara no disponible regresan sin documento',
    () async {
      final h = TestHarness();
      addTearDown(h.controller.dispose);
      await h.controller.initialize();
      h.imageSource.cameraResult = null;
      await h.controller.takePhoto();
      expect(h.controller.step, FlowStep.start);
      expect(h.controller.status, isNull);
      h.imageSource.cameraError = const AppFailure(
        FailureKind.cameraUnavailable,
      );
      await h.controller.takePhoto();
      expect(h.controller.status?.failure?.kind, FailureKind.cameraUnavailable);
      expect(h.controller.isBusy, isFalse);
      expect(h.controller.pages, isEmpty);
    },
  );
  test(
    'captura inválida no sustituye foto válida y limpia solo copia fallida',
    () async {
      final h = TestHarness();
      addTearDown(h.controller.dispose);
      await h.controller.initialize();
      await h.controller.takePhoto();
      final first = h.controller.pendingImage;
      h.imageSource.cameraResult = pickedFile(Uint8List.fromList([1, 2, 3]));
      await h.controller.replaceImage();
      expect(h.controller.pendingImage, same(first));
      expect(
        h.controller.status?.failure?.kind,
        FailureKind.unsupportedImageType,
      );
      expect(h.workingCopies.deleted, hasLength(1));
      expect(h.workingCopies.deleted, isNot(contains(first!.workingCopy)));
    },
  );
}
