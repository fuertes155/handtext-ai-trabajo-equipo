// T022: límites y fallos actuales, sin cámara, red ni imágenes personales.
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:handtext_ai/config/app_config.dart';
import 'package:handtext_ai/models/app_failure.dart';
import 'package:handtext_ai/models/image_format.dart';
import 'package:handtext_ai/services/image_rules.dart';

Uint8List png([int length = 8]) =>
    Uint8List(length)
      ..setAll(0, [0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]);

Matcher fails(FailureKind kind) =>
    throwsA(isA<AppFailure>().having((e) => e.kind, 'kind', kind));

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('detecta firmas completas y rechaza prefijos truncados', () {
    expect(detectImageFormat(png()), ImageFormat.png);
    expect(
      detectImageFormat(Uint8List.fromList([0xff, 0xd8, 0xff])),
      ImageFormat.jpeg,
    );
    expect(detectImageFormat(Uint8List.fromList([0xff, 0xd8])), isNull);
    expect(detectImageFormat(Uint8List.fromList([0x89, 0x50, 0x4e])), isNull);
    expect(
      detectImageFormat(Uint8List.fromList(utf8.encode('foto.jpg'))),
      isNull,
    );
  });

  test('rechaza vacío, tamaño y formato antes de leer dimensiones', () async {
    var calls = 0;
    Future<ImageDimensions> read(Uint8List _) async {
      calls++;
      return const ImageDimensions(800, 600);
    }

    await expectLater(
      validateSelectedImage(Uint8List(0), readDimensions: read),
      fails(FailureKind.imageUnreadable),
    );
    await expectLater(
      validateSelectedImage(
        png(AppConfig.maxImageBytes + 1),
        readDimensions: read,
      ),
      fails(FailureKind.imageTooLarge),
    );
    await expectLater(
      validateSelectedImage(
        Uint8List.fromList([1, 2, 3]),
        readDimensions: read,
      ),
      fails(FailureKind.unsupportedImageType),
    );
    expect(calls, 0);
  });

  test('acepta límite exacto de tamaño y dimensiones inclusivas', () async {
    for (final side in [600, 10000]) {
      final result = await validateSelectedImage(
        png(AppConfig.maxImageBytes),
        readDimensions: (_) async => ImageDimensions(side, side),
      );
      expect(result.format, ImageFormat.png);
      expect(result.width, side);
      expect(result.height, side);
    }
  });

  test('rechaza cada lado fuera del intervalo', () async {
    for (final size in [
      const ImageDimensions(599, 800),
      const ImageDimensions(800, 599),
      const ImageDimensions(10001, 800),
      const ImageDimensions(800, 10001),
    ]) {
      await expectLater(
        validateSelectedImage(png(), readDimensions: (_) async => size),
        fails(FailureKind.imageDimensionsOutOfRange),
      );
    }
  });

  test('traduce una cabecera dañada sin exponer el fallo interno', () async {
    await expectLater(
      validateSelectedImage(
        png(),
        readDimensions: (_) async => throw StateError('synthetic-private-path'),
      ),
      fails(FailureKind.imageUnreadable),
    );
  });

  test(
    'el motor lee una imagen real sintética sin decodificar píxeles',
    () async {
      final image = base64Decode(
        'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+aXioAAAAASUVORK5CYII=',
      );
      final dimensions = await readImageDimensionsWithEngine(image);
      expect(dimensions.width, 1);
      expect(dimensions.height, 1);
      await expectLater(
        readImageDimensionsWithEngine(Uint8List.fromList([1, 2, 3])),
        throwsA(isA<Exception>()),
      );
    },
  );
}
