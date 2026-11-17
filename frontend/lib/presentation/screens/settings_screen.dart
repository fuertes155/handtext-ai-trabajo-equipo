// Pantalla de Ajustes (tarea T404; spec 005, Historia 1).
//
// - Tema: automático, claro u oscuro [AV-H1-E2] [AV-H1-E3].
// - Letra del editor: normal, grande o muy grande, con una muestra [AV-H1-E4].
// Cada cambio se aplica al instante y se guarda en el teléfono [AV-H1-E5].
// Spec 006: acceso a los consejos para una buena foto [PA-H1-E5]. Con la letra grande,
// las opciones se muestran una debajo de otra para no partir palabras [PA-H3-E1].
// Spec 008 (tarea T706): el idioma de la app [IE-H1-E2].
// Spec 011 (tarea T1003): bloquear con huella o rostro [BL-H1-E1] a [BL-H1-E4].

import 'package:flutter/material.dart';

import '../../models/app_settings.dart';
import '../../models/app_failure.dart';
import '../../theme/aurora.dart';
import '../app_lock_scope.dart';
import '../settings_scope.dart';
import '../strings.dart';
import '../widgets/action_tile.dart';
import '../widgets/aurora_header.dart';
import '../widgets/aurora_scaffold.dart';
import '../widgets/language_sheet.dart';
import '../widgets/surface_card.dart';
import 'tips_screen.dart';

/// Pantalla de Ajustes: tema, tamaño de letra, idioma, consejos y bloqueo con
/// huella. Cada cambio se aplica al instante y queda guardado en el teléfono.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = SettingsScope.of(context);
    final settings = controller.settings;
    final strings = context.strings;
    Widget heading(String title) => Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Semantics(
        header: true,
        child: Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: Aurora.textPrimary),
        ),
      ),
    );
    return AuroraScaffold(
      body: Column(
        children: [
          AuroraHeader(title: strings.settingsTitle),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
              children: [
                heading(strings.themeSection),
                _OptionGroup<ThemePreference>(
                  options: [
                    (ThemePreference.system, strings.themeSystem),
                    (ThemePreference.light, strings.themeLight),
                    (ThemePreference.dark, strings.themeDark),
                  ],
                  selected: settings.theme,
                  onSelected: controller.setTheme,
                ),
                const SizedBox(height: 8),
                Text(strings.themeHint),
                heading(strings.textSizeSection),
                _OptionGroup<EditorTextSize>(
                  options: [
                    (EditorTextSize.normal, strings.textSizeNormal),
                    (EditorTextSize.large, strings.textSizeLarge),
                    (EditorTextSize.extraLarge, strings.textSizeExtraLarge),
                  ],
                  selected: settings.textSize,
                  onSelected: controller.setTextSize,
                ),
                const SizedBox(height: 12),
                Builder(
                  builder: (context) => SurfaceCard(
                    child: Text(
                      strings.textSizePreview,
                      style: editorTextStyle(context, settings.textSize),
                    ),
                  ),
                ),
                heading(strings.languageSection),
                _OptionGroup<AppLanguage>(
                  options: languageOptions(strings),
                  selected: settings.language,
                  onSelected: controller.setLanguage,
                ),
                const SizedBox(height: 8),
                Text(strings.languageHint),
                const SizedBox(height: 24),
                const _AppLockCard(),
                const SizedBox(height: 24),
                ActionTile(
                  icon: Icons.lightbulb_outline,
                  title: strings.tipsLink,
                  subtitle: strings.tipsLinkHint,
                  onTap: () => TipsScreen.open(context),
                ),
                const SizedBox(height: 16),
                Text(
                  strings.settingsSavedHint,
                  style: const TextStyle(color: Aurora.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Opciones de un ajuste (spec 006; research.md de 006, R10).
///
/// Con la letra normal son botones segmentados. Si alguna opción no cabe en una línea
/// de su segmento (por ejemplo, con la letra del sistema al 200 %, «Autom-ático»), se
/// muestran una debajo de otra, con la elegida marcada [PA-H3-E1].
class _OptionGroup<T> extends StatelessWidget {
  const _OptionGroup({
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  /// Valor y texto de cada opción, en orden.
  final List<(T, String)> options;
  final T selected;
  final ValueChanged<T> onSelected;

  /// Margen horizontal de cada segmento (TextButton de Material 3: 12 dp por lado con
  /// la letra normal; con la letra grande es menor, así que la cuenta es prudente).
  static const _segmentInsets = 2 * 12.0;

  /// ¿Cada texto cabe en una línea dentro de su segmento, con la letra actual?
  bool _fitsInSegments(BuildContext context, double width) {
    final slot = width / options.length - _segmentInsets;
    for (final (_, text) in options) {
      final painter = TextPainter(
        text: TextSpan(
          text: text,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        textDirection: Directionality.of(context),
        textScaler: MediaQuery.textScalerOf(context),
      );
      try {
        painter.layout();
        if (painter.width > slot) return false;
      } finally {
        painter.dispose();
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (_fitsInSegments(context, constraints.maxWidth)) {
          return SegmentedButton<T>(
            showSelectedIcon: false,
            segments: [
              for (final (value, label) in options)
                ButtonSegment(value: value, label: Text(label)),
            ],
            selected: {selected},
            onSelectionChanged: (values) => onSelected(values.single),
          );
        }
        return SurfaceCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (final (value, label) in options)
                MergeSemantics(
                  child: Semantics(
                    checked: selected == value,
                    inMutuallyExclusiveGroup: true,
                    child: ListTile(
                      title: Text(label),
                      leading: Icon(
                        selected == value
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                      ),
                      onTap: () => onSelected(value),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

/// Spec 011: interruptor del bloqueo con huella o rostro.
/// - Apagado por omisión [BL-H1-E1]; activarlo pide la verificación [BL-H1-E2], y
///   cancelarla lo deja apagado [BL-H1-E3].
/// - Si el teléfono no tiene cómo verificar, lo explica y no se puede activar
///   [BL-H1-E4].
class _AppLockCard extends StatefulWidget {
  const _AppLockCard();

  @override
  State<_AppLockCard> createState() {
    return _AppLockCardState();
  }
}

class _AppLockCardState extends State<_AppLockCard> {
  /// Se pregunta una sola vez al abrir Ajustes.
  late final Future<bool> _available = AppLockScope.of(
    context,
  ).authenticator.isAvailable();

  @override
  Widget build(BuildContext context) {
    final lock = AppLockScope.of(context);
    final strings = context.strings;
    return FutureBuilder<bool>(
      future: _available,
      builder: (context, snapshot) {
        final available = snapshot.data == true;
        return SurfaceCard(
          padding: EdgeInsets.zero,
          child: SwitchListTile(
            title: Text(strings.appLockTitle),
            subtitle: Text(
              available ? strings.appLockHint : strings.appLockUnavailable,
            ),
            value: SettingsScope.of(context).settings.appLock,
            onChanged: available
                ? (enabled) async {
                    try {
                      if (enabled) {
                        await lock.enable(strings.enableLockReason);
                      } else {
                        await lock.disable();
                      }
                    } catch (_) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              strings.failureText(
                                const AppFailure(FailureKind.unexpected),
                              ),
                            ),
                          ),
                        );
                      }
                    }
                  }
                : null,
          ),
        );
      },
    );
  }
}

/// Estilo del texto del editor con el tamaño elegido (R3). Lo usan el editor y la
/// muestra de Ajustes, así siempre coinciden.
TextStyle? editorTextStyle(BuildContext context, EditorTextSize size) {
  final base = Theme.of(context).textTheme.bodyLarge;
  return base?.copyWith(
    fontSize: (base.fontSize ?? 16) * size.scale,
    height: 1.5,
  );
}
