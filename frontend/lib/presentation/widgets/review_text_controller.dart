// Reinicio 2026-11-17: las regiones marcadas están pendientes de LUISDACA.
// Los comentarios anteriores describen requisitos; no son verificación del código actual.
// Controlador del texto del editor que pinta las palabras dudosas (tarea T210; spec
// 003, módulo 1; research.md de 003, R4).
//
// Es un TextEditingController normal (el texto sigue siendo editable) que, al dibujar,
// resalta las marcas con fondo ámbar y subrayado ondulado [EX-H1-E1] [SC-306]. Las
// marcas no forman parte del texto: solo cambian cómo se ve [EX-H1-E6].
// Las marcas las decide DocumentFlowController; este controlador solo las lee.

import 'package:flutter/material.dart';

import '../../services/uncertain_ranges.dart';
import '../../theme/aurora.dart';

/// Controlador del campo de texto del editor que pinta las palabras dudosas.
class ReviewTextController extends TextEditingController {
  ReviewTextController({super.text, required this.uncertainRanges});

  /// Devuelve las marcas actuales del documento.
  final List<TextRange> Function() uncertainRanges;

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    throw UnimplementedError("T210 pendiente de LUISDACA");
  }
}
