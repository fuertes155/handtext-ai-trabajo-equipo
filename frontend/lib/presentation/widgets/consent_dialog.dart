// Reinicio 2026-11-17: las regiones marcadas están pendientes de LUISDACA.
// Los comentarios anteriores describen requisitos; no son verificación del código actual.
// Diálogo de autorización de envío (tarea T042; spec 001, módulo 6; research.md, R13).
//
// [H1-E3] Antes de enviar la imagen, se informa al usuario que irá al servidor de
// HandText AI y cómo se procesa según el proveedor configurado. Se pregunta antes
// de CADA envío (supuesto 5). Si no autoriza, devuelve false y nada se envía [H1-E4].
// Spec 004 (tarea T307): con varias páginas, dice cuántas imágenes se enviarán
// [VP-H1-E3].

import 'package:flutter/material.dart';

import '../../theme/aurora.dart';
import '../strings.dart';

/// Devuelve true solo si el usuario tocó «Autorizar y enviar».
Future<bool> showConsentDialog(
  BuildContext context, {
  int imageCount = 1,
}) async {
  throw UnimplementedError("T042,T142 pendiente de LUISDACA");
}
