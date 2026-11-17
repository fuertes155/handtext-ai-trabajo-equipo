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
    final scheme = Theme.of(context).colorScheme;
    final color = switch (status.kind) {
      StatusKind.success => onAurora ? Aurora.success : const Color(0xFF166534),
      StatusKind.failure => onAurora ? Aurora.danger : scheme.error,
      _ => onAurora ? Aurora.blueLight : scheme.primary,
    };
    final icon = switch (status.kind) {
      StatusKind.success => Icons.check_circle_outline,
      StatusKind.failure => Icons.error_outline,
      _ => Icons.info_outline,
    };
    return Semantics(
      container: true,
      liveRegion: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.10),
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(Aurora.radiusSmall),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ExcludeSemantics(
                    child: _PopIn(
                      enabled: status.kind == StatusKind.success,
                      child: status.kind == StatusKind.inProgress
                          ? SizedBox.square(
                              dimension: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: color,
                              ),
                            )
                          : Icon(icon, color: color),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      context.strings.statusText(status),
                      style: TextStyle(
                        color: onAurora ? Aurora.textPrimary : scheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
              if (actionLabel != null && onAction != null) ...[
                const SizedBox(height: 8),
                TextButton(onPressed: onAction, child: Text(actionLabel!)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Hace aparecer el ícono con un rebote (solo en los avisos de éxito).
class _PopIn extends StatelessWidget {
  const _PopIn({required this.enabled, required this.child});

  final bool enabled;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!enabled || !decorativeMotionEnabled(context)) return child;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.8, end: 1),
      duration: motionDuration(context, const Duration(milliseconds: 220)),
      curve: Curves.easeOutBack,
      builder: (context, scale, child) =>
          Transform.scale(scale: scale, child: child),
      child: child,
    );
  }
}
