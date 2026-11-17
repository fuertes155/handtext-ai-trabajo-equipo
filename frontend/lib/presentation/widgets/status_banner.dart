// Reinicio 2026-11-17: las regiones marcadas están pendientes de LUISDACA.
// Los comentarios anteriores describen requisitos; no son verificación del código actual.
// Aviso de estado de una operación (tareas T042 y T133; spec 001, módulo 5).
//
// Muestra con color, ícono y texto si una operación está en curso, terminó bien, falló o
// es solo información. Si trae una acción («Reintentar», «Elegir otra imagen»…), muestra
// el botón. `liveRegion` hace que los lectores de pantalla lo anuncien al cambiar.
//
// Estilo Aurora (spec 002): sobre el fondo azul marino ([onAurora] = true) el aviso es
// translúcido con borde del color del estado; en el editor usa los colores del tema. El
// ícono de éxito aparece con un pequeño «rebote».

import 'package:flutter/material.dart';

import '../../models/operation_status.dart';
import '../../theme/aurora.dart';
import '../strings.dart';
import 'motion.dart';

/// Aviso de estado: color, ícono, texto y, si hay, un botón de acción.
class StatusBanner extends StatelessWidget {
  const StatusBanner({
    super.key,
    required this.status,
    this.actionLabel,
    this.onAction,
    this.onAurora = false,
  });

  /// Qué mostrar: el tipo de aviso, qué pasó y, si falló, el motivo.
  final OperationStatus status;

  /// Texto del botón de acción (si hay acción).
  final String? actionLabel;

  /// Qué hacer al tocar el botón de acción.
  final VoidCallback? onAction;

  /// true sobre el fondo Aurora; false en pantallas con el tema normal.
  final bool onAurora;

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError("T042 pendiente de LUISDACA");
  }
}

/// Hace aparecer el ícono con un rebote (solo en los avisos de éxito).
class _PopIn extends StatelessWidget {
  const _PopIn({required this.enabled, required this.child});

  final bool enabled;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError("T042 pendiente de LUISDACA");
  }
}
