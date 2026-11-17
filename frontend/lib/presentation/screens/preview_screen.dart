// Reinicio 2026-11-17: las regiones marcadas están pendientes de LUISDACA.
// Los comentarios anteriores describen requisitos; no son verificación del código actual.
// Vista previa de la imagen (tareas T043 y T132; spec 001, módulos 1 y 2).
//
// - Muestra la imagen antes del reconocimiento y permite aceptarla, reemplazarla o
//   cancelar la selección (spec 001, módulo 1; H1-E2; H2-E3).
// - «Aceptar y reconocer texto» pide primero la autorización de envío [H1-E3].
// - Mientras se reconoce, una línea de escaneo recorre la imagen [CU-H3-E2], el botón
//   muestra el progreso y las acciones quedan inactivas [H1-E5].
// - Si no hubo texto o hubo un fallo, muestra el aviso con «Reintentar», «Elegir otra
//   imagen» o «Repetir captura» [H1-E7] [H1-E8] [H2-E5].
// - Spec 003 (tarea T213): «Recortar o girar» abre el editor de recorte y, si ya se
//   recortó, «Usar la imagen original» la recupera [EX-H2-E1] [EX-H2-E5].
// - Spec 004 (tarea T309):
//   - una tira de miniaturas muestra las páginas y permite agregar más [VP-H1-E1]
//     [VP-H1-E2];
//   - con dos páginas o más, la barra superior ofrece moverla antes o después y
//     quitarla [VP-H2-E2] [VP-H2-E3];
//   - recortar y reemplazar actúan sobre la página que se ve en grande [VP-H2-E4].

import 'package:flutter/material.dart';

import '../../models/operation_status.dart';
import '../../models/picked_image.dart';
import '../../state/document_flow_controller.dart';
import '../../theme/aurora.dart';
import '../strings.dart';
import '../widgets/aurora_scaffold.dart';
import '../widgets/consent_dialog.dart';
import '../widgets/page_strip.dart';
import '../widgets/primary_button.dart';
import '../widgets/scan_overlay.dart';
import '../widgets/status_banner.dart';
import '../widgets/surface_card.dart';

/// Vista previa antes de reconocer: aceptar, reemplazar, recortar, agregar, ordenar
/// o quitar páginas.
class PreviewScreen extends StatelessWidget {
  const PreviewScreen({super.key, required this.controller});

  /// El documento en curso: sus páginas y las acciones sobre ellas.
  final DocumentFlowController controller;

  /// Pide la autorización y, con la respuesta, inicia (o no) el reconocimiento.
  /// [VP-H1-E3] El diálogo dice cuántas imágenes se enviarán; si todas ya se
  /// reconocieron, no se envía nada y no hace falta preguntar.
  Future<void> _acceptAndRecognize(BuildContext context) async {
    final toSend = controller.pagesToSend;
    final granted =
        toSend == 0 || await showConsentDialog(context, imageCount: toSend);
    await controller.recognize(consentGranted: granted);
  }

  /// [VP-H1-E2] Elige de dónde agregar páginas: cámara o galería.
  Future<void> _addPage(BuildContext context) async {
    final origin = await showModalBottomSheet<ImageOrigin>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // [ED-H1-E4] Spec 009: escanear más hojas.
            ListTile(
              leading: const Icon(Icons.document_scanner_outlined),
              title: Text(context.strings.addPageFromScanner),
              onTap: () => Navigator.of(context).pop(ImageOrigin.scanner),
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: Text(context.strings.addPageFromCamera),
              onTap: () => Navigator.of(context).pop(ImageOrigin.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(context.strings.addPageFromGallery),
              onTap: () => Navigator.of(context).pop(ImageOrigin.gallery),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
    if (origin != null) await controller.addPages(origin);
  }

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError("T043,T213 pendiente de LUISDACA");
  }
}

/// Píldora «Leyendo su escritura…» sobre la imagen durante el reconocimiento.
class _ReadingChip extends StatelessWidget {
  const _ReadingChip({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError("T043,T213 pendiente de LUISDACA");
  }
}
