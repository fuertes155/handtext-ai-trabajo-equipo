import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:handtext_ai/models/app_failure.dart';
import 'package:handtext_ai/services/image_source_service.dart';
import 'package:image_picker/image_picker.dart';

class PickerStub extends ImagePicker {
  List<XFile> images = [];
  PlatformException? error;
  int calls = 0;
  int? lastLimit;

  @override
  Future<List<XFile>> pickMultiImage({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    int? limit,
    bool requestFullMetadata = true,
  }) async {
    calls++;
    lastLimit = limit;
    if (error != null) throw error!;
    return images;
  }

  @override
  Future<XFile?> pickImage({
    required ImageSource source,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    bool requestFullMetadata = true,
  }) async {
    calls++;
    if (error != null) throw error!;
    return images.firstOrNull;
  }
}

void main() {
  test(
    'sin huecos no abre galería; un hueco usa selector individual',
    () async {
      final picker = PickerStub();
      final source = PickerImageSourceService(picker: picker);
      expect(await source.pickMultipleFromGallery(limit: 0), isEmpty);
      expect(picker.calls, 0);
      expect(await source.pickMultipleFromGallery(limit: 1), isEmpty);
      picker.images = [XFile.fromData(Uint8List(1), name: 'synthetic.png')];
      expect(await source.pickMultipleFromGallery(limit: 1), picker.images);
      expect(picker.lastLimit, isNull);
    },
  );

  test(
    'transmite límite y permite al controlador detectar excedentes nativos',
    () async {
      final picker = PickerStub()
        ..images = List.generate(
          4,
          (i) => XFile.fromData(Uint8List(1), name: '$i.png'),
        );
      final selected = await PickerImageSourceService(
        picker: picker,
      ).pickMultipleFromGallery(limit: 3);
      expect(picker.lastLimit, 3);
      expect(selected, picker.images);
    },
  );

  test(
    'cancelar devuelve vacío y un fallo nativo tiene mensaje seguro',
    () async {
      final picker = PickerStub();
      final source = PickerImageSourceService(picker: picker);
      expect(await source.pickMultipleFromGallery(limit: 4), isEmpty);
      picker.error = PlatformException(
        code: 'synthetic-failure',
        message: 'private-path',
      );
      await expectLater(
        source.pickMultipleFromGallery(limit: 4),
        throwsA(
          isA<AppFailure>().having(
            (e) => e.kind,
            'kind',
            FailureKind.imageUnreadable,
          ),
        ),
      );
    },
  );
}
