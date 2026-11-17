// Reinicio 2026-11-17: las regiones marcadas están pendientes de LUISDACA.
// Los comentarios anteriores describen requisitos; no son verificación del código actual.
// Tarjeta de acción grande del inicio (tareas T132 y T142): ícono en una insignia azul,
// título, subtítulo y flecha. Se usa para las opciones del inicio y para los consejos
// en Ajustes.

import 'package:flutter/material.dart';

import '../../theme/aurora.dart';
import 'surface_card.dart';

/// Tarjeta grande y tocable con ícono, título, subtítulo y flecha. Es la forma de las
/// opciones principales: «Escanear hoja», «Tomar fotografía», «Elegir imagen
/// guardada» y «Mis documentos».
class ActionTile extends StatelessWidget {
  const ActionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  /// Ícono de la insignia azul.
  final IconData icon;

  /// Texto principal.
  final String title;

  /// Explicación corta, debajo del título.
  final String subtitle;

  /// null = desactivada (por ejemplo, mientras hay una operación en curso).
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError("T142 pendiente de LUISDACA");
  }
}
