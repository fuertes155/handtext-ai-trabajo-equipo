import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../models/app_failure.dart';

abstract interface class ImageSourceService {
  Future<XFile?> pickFromGallery();
}

class PickerImageSourceService implements ImageSourceService {
  PickerImageSourceService({ImagePicker? picker})
    : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  @override
  Future<XFile?> pickFromGallery() async {
    try {
      return await _picker.pickImage(source: ImageSource.gallery);
    } on PlatformException {
      throw const AppFailure(FailureKind.imageUnreadable);
    }
  }
}
