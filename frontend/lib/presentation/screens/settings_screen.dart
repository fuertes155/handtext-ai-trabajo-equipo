// Reinicio 2026-11-17: las regiones marcadas están pendientes de LUISDACA.
// Los comentarios anteriores describen requisitos; no son verificación del código actual.
// Pantalla de Ajustes (tarea T404; spec 005, Historia 1).
//
// - Tema: automático, claro u oscuro [AV-H1-E2] [AV-H1-E3].
// - Letra del editor: normal, grande o muy grande, con una muestra [AV-H1-E4].
// Cada cambio se aplica al instante y se guarda en el teléfono [AV-H1-E5].
// Spec 006: acceso a los consejos para una buena foto [PA-H1-E5]. Con la letra grande,
// las opciones se muestran una debajo de otra para no partir palabras [PA-H3-E1].
// Spec 008 (tarea T706): el idioma de la app [IE-H1-E2].
// Spec 011 (tarea T1003): bloquear con huella o rostro [BL-H1-E1] a [BL-H1-E4].

import 'package:flutter/material.dart';

import '../../models/app_settings.dart';
import '../../theme/aurora.dart';
import '../app_lock_scope.dart';
import '../settings_scope.dart';
import '../strings.dart';
import '../widgets/action_tile.dart';
import '../widgets/aurora_header.dart';
import '../widgets/aurora_scaffold.dart';
import '../widgets/language_sheet.dart';
import '../widgets/surface_card.dart';
import 'tips_screen.dart';

/// Pantalla de Ajustes: tema, tamaño de letra, idioma, consejos y bloqueo con
/// huella. Cada cambio se aplica al instante y queda guardado en el teléfono.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError("T404,T1003 pendiente de LUISDACA");
  }
}

/// Opciones de un ajuste (spec 006; research.md de 006, R10).
///
/// Con la letra normal son botones segmentados. Si alguna opción no cabe en una línea
/// de su segmento (por ejemplo, con la letra del sistema al 200 %, «Autom-ático»), se
/// muestran una debajo de otra, con la elegida marcada [PA-H3-E1].
class _OptionGroup<T> extends StatelessWidget {
  const _OptionGroup({
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  /// Valor y texto de cada opción, en orden.
  final List<(T, String)> options;
  final T selected;
  final ValueChanged<T> onSelected;

  /// Margen horizontal de cada segmento (TextButton de Material 3: 12 dp por lado con
  /// la letra normal; con la letra grande es menor, así que la cuenta es prudente).
  static const _segmentInsets = 2 * 12.0;

  /// ¿Cada texto cabe en una línea dentro de su segmento, con la letra actual?
  bool _fitsInSegments(BuildContext context, double width) {
    throw UnimplementedError("T404,T1003 pendiente de LUISDACA");
  }

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError("T404,T1003 pendiente de LUISDACA");
  }
}

/// Spec 011: interruptor del bloqueo con huella o rostro.
/// - Apagado por omisión [BL-H1-E1]; activarlo pide la verificación [BL-H1-E2], y
///   cancelarla lo deja apagado [BL-H1-E3].
/// - Si el teléfono no tiene cómo verificar, lo explica y no se puede activar
///   [BL-H1-E4].
class _AppLockCard extends StatefulWidget {
  const _AppLockCard();

  @override
  State<_AppLockCard> createState() {
    throw UnimplementedError("T404,T1003 pendiente de LUISDACA");
  }
}

class _AppLockCardState extends State<_AppLockCard> {
  /// Se pregunta una sola vez al abrir Ajustes.
  late final Future<bool> _available = AppLockScope.of(
    context,
  ).authenticator.isAvailable();

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError("T404,T1003 pendiente de LUISDACA");
  }
}

/// Estilo del texto del editor con el tamaño elegido (R3). Lo usan el editor y la
/// muestra de Ajustes, así siempre coinciden.
TextStyle? editorTextStyle(BuildContext context, EditorTextSize size) {
  throw UnimplementedError("T404,T1003 pendiente de LUISDACA");
}
