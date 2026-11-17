// Editor del texto reconocido (tareas T043 y T132; spec 001, módulos 3 y 4).
//
// - [H1-E6] Muestra el texto en un campo editable y la advertencia permanente de que
//   el reconocimiento puede contener errores.
// - Permite agregar, borrar y cambiar palabras, corregir títulos y separar párrafos.
//   Cada cambio llega al controlador (updateText), que guarda el borrador.
// - «Exportar» abre el selector Word/PDF [H3-E1] y exporta el texto actual [H1-E9].
// - El menú ofrece «Procesar otra imagen» [H1-E13] y «Descartar texto» [H1-E17],
//   ambos con confirmación (spec 001, módulo 3). El avatar abre el menú de cuenta.
// - Mientras se exporta, el texto queda en solo lectura y el botón inactivo [SC-008].
//
// Estilo Aurora (spec 002): encabezado azul marino sólido y el texto sobre una
// superficie clara u oscura según el sistema, para leer cómodamente textos largos
// [CU-H3-E4].
//
// Spec 003 (tareas T210 y T216):
// - Las palabras dudosas se ven resaltadas (ReviewTextController). Una barra indica
//   cuántas quedan y ofrece «Siguiente» y «Está bien» [EX-H1-E1] [EX-H1-E3]
//   [EX-H1-E5] [EX-H1-E9].
// - Después de guardar, el aviso de éxito ofrece «Compartir» [EX-H3-E1].
//
// Spec 005: el texto usa el tamaño de letra elegido en Ajustes [AV-H1-E4].
//
// Spec 010 (tarea T903): el menú ofrece «Copiar todo el texto» si hay texto
// [OR-H2-E1] [OR-H2-E2].
//
// Spec 006 (tareas T508 y T512):
// - Al ir a una palabra dudosa con «Siguiente», TalkBack la lee [PA-H2-E3].
// - Con la letra grande del sistema, los avisos de arriba se desplazan en un espacio
//   de hasta el 45 % del alto y el texto conserva lugar para editarse [PA-H3-E2]
//   (research.md de 006, R5).

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';

import '../../models/operation_status.dart';
import '../../models/app_failure.dart';
import '../../state/auth_controller.dart';
import '../../state/document_flow_controller.dart';
import '../../theme/aurora.dart';
import '../settings_scope.dart';
import '../strings.dart';
import '../widgets/account_menu.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/export_format_sheet.dart';
import '../widgets/primary_button.dart';
import '../widgets/review_text_controller.dart';
import '../widgets/status_banner.dart';
import 'settings_screen.dart';

/// Opciones del menú del editor.
enum _EditorAction { copyAll, processAnotherImage, discard }

/// Editor del texto reconocido: revisar las palabras dudosas, corregir y guardar
/// como Word o PDF.
class EditorScreen extends StatefulWidget {
  const EditorScreen({super.key, required this.controller, required this.auth});

  /// El documento en edición: el texto, sus marcas y las acciones (exportar,
  /// descartar, copiar…).
  final DocumentFlowController controller;

  /// Sesión, para el menú de la cuenta.
  final AuthController auth;

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  /// Controla el contenido del campo de texto; empieza con el texto del documento y
  /// pinta las palabras dudosas que indica el controlador del flujo.
  late final ReviewTextController _textController = ReviewTextController(
    text: widget.controller.documentText ?? '',
    uncertainRanges: () => widget.controller.uncertainRanges,
  );

  /// Foco del campo de texto: «Siguiente» lo activa para mostrar la selección.
  final FocusNode _textFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _textController.addListener(_selectionChanged);
  }

  void _selectionChanged() {
    if (mounted) setState(() {});
  }

  @override
  void didUpdateWidget(covariant EditorScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    final text = widget.controller.documentText ?? '';
    if (_textController.text != text) {
      _textController.value = TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
    }
  }

  @override
  void dispose() {
    _textController.removeListener(_selectionChanged);
    _textController.dispose();
    _textFocus.dispose();
    super.dispose();
  }

  /// La marca que contiene la selección actual, o null si no hay ninguna.
  TextRange? _selectedUncertainWord(TextSelection selection) {
    if (!selection.isValid) return null;
    for (final range in widget.controller.uncertainRanges) {
      if (selection.start >= range.start && selection.end <= range.end) {
        return range;
      }
    }
    return null;
  }

  /// [EX-H1-E3] Selecciona la siguiente palabra dudosa después del cursor; tras la
  /// última, vuelve a la primera.
  void _selectNextUncertainWord() {
    final ranges = widget.controller.uncertainRanges;
    if (ranges.isEmpty || widget.controller.isBusy) return;
    final end = _textController.selection.isValid
        ? _textController.selection.end
        : 0;
    final next =
        ranges.where((range) => range.start >= end).firstOrNull ?? ranges.first;
    _textController.selection = TextSelection(
      baseOffset: next.start,
      extentOffset: next.end,
    );
    _textFocus.requestFocus();
    unawaited(
      SemanticsService.sendAnnouncement(
        View.of(context),
        context.strings.uncertainWordAnnouncement(
          next.textInside(_textController.text),
        ),
        Directionality.of(context),
      ),
    );
  }

  /// [EX-H1-E5] «Está bien»: quita la marca de la palabra seleccionada.
  void _acceptSelectedWord() {
    final range = _selectedUncertainWord(_textController.selection);
    if (range != null) widget.controller.acceptUncertainWord(range);
  }

  Future<void> _export() async {
    FocusScope.of(context).unfocus();
    final format = await showExportFormatSheet(context);
    if (format == null) return; // cerró la hoja sin elegir
    await widget.controller.export(format);
  }

  Future<void> _processAnotherImage() async {
    final confirmed = await showConfirmDialog(
      context,
      title: context.strings.replaceTextTitle,
      message: context.strings.replaceTextMessage,
      confirmLabel: context.strings.replaceTextConfirm,
    );
    if (confirmed) widget.controller.startAnotherImage();
  }

  Future<void> _discard() async {
    final confirmed = await showConfirmDialog(
      context,
      title: context.strings.discardTitle,
      message: context.strings.discardMessage,
      confirmLabel: context.strings.discardConfirm,
      destructive: true,
    );
    if (confirmed) await widget.controller.discardDocument();
  }

  /// [OR-H2-E1] [SC-1002] Copia el texto tal cual está, sin las marcas de palabras
  /// dudosas (research.md de 010, R2).
  Future<void> _copyAll() async {
    final text = widget.controller.documentText ?? '';
    if (text.isEmpty) return;
    try {
      await Clipboard.setData(ClipboardData(text: text));
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(context.strings.textCopied)));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              context.strings.failureText(
                const AppFailure(FailureKind.unexpected),
              ),
            ),
          ),
        );
      }
    }
  }

  void _onMenuSelected(_EditorAction action) {
    switch (action) {
      case _EditorAction.copyAll:
        unawaited(_copyAll());
      case _EditorAction.processAnotherImage:
        unawaited(_processAnotherImage());
      case _EditorAction.discard:
        unawaited(_discard());
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final strings = context.strings;
    final text = controller.documentText ?? '';
    final busy = controller.isBusy;
    final status = controller.status;
    final large = MediaQuery.textScalerOf(context).scale(16) > 16 * 1.3;
    final selected = _selectedUncertainWord(_textController.selection);
    final words = text.trim().isEmpty
        ? 0
        : text.trim().split(RegExp(r'\s+')).length;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ColoredBox(
              color: Aurora.backgroundBottom,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MediaQuery.withClampedTextScaling(
                            maxScaleFactor: 1.5,
                            child: Semantics(
                              container: true,
                              header: true,
                              child: Text(
                                strings.editorTitle,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          if (!large)
                            Text(
                              strings.editorSubtitle,
                              style: const TextStyle(
                                color: Aurora.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                    ),
                    AccountButton(auth: widget.auth, documents: controller),
                    PopupMenuButton<_EditorAction>(
                      tooltip: strings.moreActionsTooltip,
                      enabled: !busy,
                      icon: const Icon(Icons.more_vert, color: Colors.white),
                      onSelected: _onMenuSelected,
                      itemBuilder: (_) => [
                        if (text.isNotEmpty)
                          PopupMenuItem(
                            value: _EditorAction.copyAll,
                            child: Text(strings.copyAllText),
                          ),
                        PopupMenuItem(
                          value: _EditorAction.processAnotherImage,
                          child: Text(strings.processAnotherImage),
                        ),
                        PopupMenuItem(
                          value: _EditorAction.discard,
                          child: Text(strings.discardText),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) => Column(
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: constraints.maxHeight * 0.45,
                      ),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const _RecognitionWarning(),
                            if (status != null) ...[
                              const SizedBox(height: 10),
                              StatusBanner(
                                status: status,
                                actionLabel:
                                    status.action == StatusAction.shareExport
                                    ? strings.share
                                    : null,
                                onAction:
                                    !busy &&
                                        status.action ==
                                            StatusAction.shareExport
                                    ? controller.shareLastExport
                                    : null,
                              ),
                            ],
                            if (controller.uncertainRanges.isNotEmpty) ...[
                              const SizedBox(height: 10),
                              _ReviewBar(
                                count: controller.uncertainRanges.length,
                                onNext: busy ? null : _selectNextUncertainWord,
                                onAccept: busy || selected == null
                                    ? null
                                    : _acceptSelectedWord,
                              ),
                            ],
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                strings.textStats(words, text.runes.length),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: TextField(
                          controller: _textController,
                          focusNode: _textFocus,
                          readOnly: busy,
                          maxLines: null,
                          expands: true,
                          textAlignVertical: TextAlignVertical.top,
                          style: editorTextStyle(
                            context,
                            SettingsScope.of(context).settings.textSize,
                          ),
                          decoration: InputDecoration(
                            labelText: strings.editorLabel,
                            hintText: strings.editorHint,
                            alignLabelWithHint: true,
                          ),
                          onChanged: controller.updateText,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: PrimaryButton(
                label: strings.export,
                onPressed: busy ? null : _export,
                isLoading: status?.event == StatusEvent.exporting,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Barra de revisión de palabras dudosas (spec 003): cuántas quedan, «Está bien» y
/// «Siguiente».
class _ReviewBar extends StatelessWidget {
  const _ReviewBar({
    required this.count,
    required this.onNext,
    required this.onAccept,
  });

  final int count;
  final VoidCallback? onNext;

  /// null si la selección no está sobre una palabra marcada.
  final VoidCallback? onAccept;

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          liveRegion: true,
          child: Text(
            strings.uncertainWordsCount(count),
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        Text(
          onAccept == null
              ? strings.uncertainWordsHint
              : strings.acceptUncertainWordHint,
        ),
        Wrap(
          spacing: 8,
          children: [
            TextButton.icon(
              onPressed: onNext,
              icon: const Icon(Icons.navigate_next),
              label: Text(strings.nextUncertainWord),
            ),
            TextButton.icon(
              onPressed: onAccept,
              icon: const Icon(Icons.check),
              label: Text(strings.acceptUncertainWord),
            ),
          ],
        ),
      ],
    );
  }
}

/// [H1-E6] Advertencia permanente: el texto reconocido puede tener errores.
class _RecognitionWarning extends StatelessWidget {
  const _RecognitionWarning();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExcludeSemantics(
          child: Icon(
            Icons.fact_check_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(child: Text(context.strings.recognitionWarning)),
      ],
    );
  }
}
