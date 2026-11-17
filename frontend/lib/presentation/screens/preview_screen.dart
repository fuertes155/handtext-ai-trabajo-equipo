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
    final strings = context.strings;
    final image = controller.pendingImage;
    if (image == null) {
      return AuroraScaffold(
        body: Center(child: Text(strings.imagePreviewUnavailable)),
      );
    }
    final busy = controller.isBusy;
    final status = controller.status;
    final recognizing = status?.event == StatusEvent.recognizing;
    return AuroraScaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Row(
              children: [
                IconButton(
                  tooltip: strings.cancelSelectionTooltip,
                  onPressed: busy ? null : controller.cancelPreview,
                  icon: const Icon(Icons.close),
                ),
                Expanded(
                  child: Semantics(
                    container: true,
                    header: true,
                    child: Text(
                      strings.previewTitle,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                if (controller.pages.length > 1) ...[
                  IconButton(
                    tooltip: strings.movePageBefore,
                    onPressed: busy || controller.selectedPageIndex == 0
                        ? null
                        : () => controller.moveSelectedPage(-1),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  IconButton(
                    tooltip: strings.movePageAfter,
                    onPressed:
                        busy ||
                            controller.selectedPageIndex ==
                                controller.pages.length - 1
                        ? null
                        : () => controller.moveSelectedPage(1),
                    icon: const Icon(Icons.arrow_forward),
                  ),
                  IconButton(
                    tooltip: strings.removePage,
                    onPressed: busy ? null : controller.removeSelectedPage,
                    icon: const Icon(Icons.delete_outline),
                  ),
                ],
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 24),
              children: [
                PageStrip(
                  pages: controller.pages,
                  selectedIndex: controller.selectedPageIndex,
                  onSelect: busy ? null : controller.selectPage,
                  onAdd: busy || !controller.canAddPages
                      ? null
                      : () => _addPage(context),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (controller.pages.length > 1) ...[
                        Text(
                          strings.pageOf(
                            controller.selectedPageIndex + 1,
                            controller.pages.length,
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                      SurfaceCard(
                        padding: const EdgeInsets.all(8),
                        child: SizedBox(
                          height: 280,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.memory(
                                image.bytes,
                                fit: BoxFit.contain,
                                cacheWidth: 1200,
                                errorBuilder: (context, _, _) => Center(
                                  child: Text(strings.imagePreviewUnavailable),
                                ),
                              ),
                              if (recognizing) ...[
                                const ScanOverlay(),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: _ReadingChip(
                                    text: strings.readingHandwriting,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        strings.imageDetails(image),
                        style: const TextStyle(color: Aurora.textSecondary),
                      ),
                      const SizedBox(height: 16),
                      if (status != null) ...[
                        StatusBanner(
                          status: status,
                          onAurora: true,
                          actionLabel:
                              status.action == StatusAction.retryRecognition
                              ? strings.retry
                              : null,
                          onAction:
                              !busy &&
                                  status.action == StatusAction.retryRecognition
                              ? () => _acceptAndRecognize(context)
                              : null,
                        ),
                        const SizedBox(height: 16),
                      ],
                      PrimaryButton(
                        label: controller.pages.length == 1
                            ? strings.acceptAndRecognize
                            : strings.recognizePages(controller.pages.length),
                        onPressed: busy
                            ? null
                            : () => _acceptAndRecognize(context),
                        isLoading: busy,
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: busy ? null : controller.replaceImage,
                        icon: const Icon(Icons.image_outlined),
                        label: Text(strings.replaceImageLabel(image.origin)),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: busy ? null : controller.editImage,
                        icon: const Icon(Icons.crop_rotate),
                        label: Text(strings.editImage),
                      ),
                      if (controller.canRestoreOriginalImage)
                        TextButton(
                          onPressed: busy
                              ? null
                              : controller.restoreOriginalImage,
                          child: Text(strings.restoreOriginalImage),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Píldora «Leyendo su escritura…» sobre la imagen durante el reconocimiento.
class _ReadingChip extends StatelessWidget {
  const _ReadingChip({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Aurora.backgroundTop,
          borderRadius: BorderRadius.circular(Aurora.radiusSmall),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Text(text, style: const TextStyle(color: Aurora.textPrimary)),
        ),
      ),
    );
  }
}
