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
  return await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          scrollable: true,
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(context.strings.cancel),
            ),
            FilledButton(
              style: destructive
                  ? FilledButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.error,
                    )
                  : null,
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(confirmLabel),
            ),
          ],
        ),
      ) ??
      false;
}
