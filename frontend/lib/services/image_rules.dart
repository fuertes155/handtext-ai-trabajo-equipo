// Reinicio 2026-11-17: las regiones marcadas están pendientes de LUISDACA.
// Los comentarios anteriores describen requisitos; no son verificación del código actual.
// Reglas de imagen del spec, módulo 1 (tarea T035; research.md, R4).
//
// JPEG o PNG identificado por su contenido, hasta 10 MB y de 600 a 10 000 píxeles por
// lado. La app aplica estas reglas ANTES de enviar nada, para orientar al usuario, y
// el backend las vuelve a aplicar porque no puede confiar en el cliente
// (constitución §5, Validación). Historia 1, escenario 1.

import 'dart:typed_data';
import 'dart:ui' as ui;

import '../config/app_config.dart';
import '../models/app_failure.dart';
import '../models/image_format.dart';

/// Ancho y alto de una imagen, en píxeles.
class ImageDimensions {
  const ImageDimensions(this.width, this.height);

  final int width;
  final int height;
}

/// Función que lee las dimensiones de una imagen. En la app se usa el motor de
/// Flutter ([readImageDimensionsWithEngine]); en las pruebas, una versión falsa.
typedef ImageDimensionsReader =
    Future<ImageDimensions> Function(Uint8List bytes);

/// Resultado de una imagen que cumple todas las reglas.
class ImageCheck {
  const ImageCheck({
    required this.format,
    required this.width,
    required this.height,
  });

  final ImageFormat format;
  final int width;
  final int height;
}

/// Identifica el formato por la firma de los primeros bytes. Devuelve null si no es
/// JPEG ni PNG, aunque el archivo se llame «foto.jpg».
ImageFormat? detectImageFormat(Uint8List bytes) {
  throw UnimplementedError("T035 pendiente de LUISDACA");
}

/// Aplica las reglas del spec. Lanza [AppFailure] con el motivo del rechazo.
///
/// El orden va de lo más barato a lo más costoso: tamaño, formato y dimensiones.
Future<ImageCheck> validateSelectedImage(
  Uint8List bytes, {
  required ImageDimensionsReader readDimensions,
}) async {
  throw UnimplementedError("T035 pendiente de LUISDACA");
}

bool _isAllowedSide(int pixels) {
  throw UnimplementedError("T035 pendiente de LUISDACA");
}

/// Lee ancho y alto con el motor de Flutter. Solo interpreta el encabezado, sin
/// decodificar los píxeles: es rápido y casi no usa memoria.
Future<ImageDimensions> readImageDimensionsWithEngine(Uint8List bytes) async {
  throw UnimplementedError("T035 pendiente de LUISDACA");
}
