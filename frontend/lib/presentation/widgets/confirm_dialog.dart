// Reinicio 2026-11-17: las regiones marcadas están pendientes de LUISDACA.
// Los comentarios anteriores describen requisitos; no son verificación del código actual.
// Diálogo genérico de confirmación (tarea T042; spec, módulo 3).
//
// «Solicitar confirmación antes de una acción que descarte o sustituya correcciones;
// cancelar esa acción debe conservarlas.» Se usa para «Procesar otra imagen»
// [H1-E13] y «Descartar texto» [H1-E17].

import 'package:flutter/material.dart';

import '../strings.dart';

/// Devuelve true solo si el usuario confirmó. Cancelar o cerrar devuelve false.
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  bool destructive = false,
}) async {
  throw UnimplementedError("T042 pendiente de LUISDACA");
}
