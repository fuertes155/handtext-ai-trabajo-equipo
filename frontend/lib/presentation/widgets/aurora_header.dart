// Reinicio 2026-11-17: las regiones marcadas están pendientes de LUISDACA.
// Los comentarios anteriores describen requisitos; no son verificación del código actual.
// Encabezado de las pantallas secundarias Aurora (tarea T404; spec 005): botón «Volver»
// y título. Lo usan Ajustes, Acerca de, Privacidad y Mis documentos.
// Spec 006: el título es un encabezado para TalkBack [PA-H2-E5].
// Spec 007: puede llevar acciones a la derecha («Borrar todo» en Mis documentos).

import 'package:flutter/material.dart';

import '../strings.dart';

/// Encabezado de las pantallas secundarias: «Volver», el título y, si hay, acciones
/// a la derecha.
class AuroraHeader extends StatelessWidget {
  const AuroraHeader({super.key, required this.title, this.actions = const []});

  /// Título de la pantalla; TalkBack lo anuncia como encabezado.
  final String title;

  /// Botones a la derecha del título.
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError("T404 pendiente de LUISDACA");
  }
}
