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
    if (withComposing &&
        value.composing.isValid &&
        !value.composing.isCollapsed) {
      return super.buildTextSpan(
        context: context,
        style: style,
        withComposing: withComposing,
      );
    }
    final ranges = validRanges(text, uncertainRanges());
    final dark = Theme.of(context).brightness == Brightness.dark;
    final spans = <InlineSpan>[];
    var cursor = 0;
    for (final range in ranges) {
      if (cursor < range.start) {
        spans.add(TextSpan(text: text.substring(cursor, range.start)));
      }
      spans.add(
        TextSpan(
          text: text.substring(range.start, range.end),
          style: TextStyle(
            backgroundColor: dark
                ? Aurora.uncertainFillDark
                : Aurora.uncertainFillLight,
            decoration: TextDecoration.underline,
            decorationStyle: TextDecorationStyle.wavy,
            decorationColor: dark
                ? Aurora.uncertainUnderlineDark
                : Aurora.uncertainUnderlineLight,
          ),
        ),
      );
      cursor = range.end;
    }
    if (cursor < text.length) spans.add(TextSpan(text: text.substring(cursor)));
    return TextSpan(style: style, children: spans);
  }
}
