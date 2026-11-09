// Ajustes de la app en este teléfono (tarea T402; spec 005, módulo 1; research.md de
// 005, R1 a R3).
/// Tema elegido: automático (según el teléfono), claro u oscuro.
enum ThemePreference { system, light, dark }

/// Tamaño de letra del editor. [scale] multiplica el tamaño normal y se suma al
/// tamaño de letra del sistema (supuesto 2 del spec).
enum EditorTextSize {
  /// Tamaño normal.
  normal(1.0),

  /// 20 % más grande.
  large(1.2),

  /// 40 % más grande.
  extraLarge(1.4);

  const EditorTextSize(this.scale);

  /// Factor que multiplica el tamaño normal de la letra del editor.
  final double scale;
}

/// Ajustes de la app en este teléfono: tema y tamaño de letra.
/// bloqueo.
///
/// Son del teléfono, no de la cuenta: valen para cualquier persona que ingrese en él.
/// Se guardan en un archivo JSON (FileSettingsStore). La clase es inmutable: para
/// cambiar un ajuste se crea una copia con [copyWith].
class AppSettings {
  const AppSettings({
    this.theme = ThemePreference.system,
    this.textSize = EditorTextSize.normal,
  });

  /// Tema: automático (como el teléfono), claro u oscuro.
  final ThemePreference theme;

  /// Tamaño de la letra en el editor.
  final EditorTextSize textSize;

  /// Copia de estos ajustes con los valores indicados; los demás no cambian.
  AppSettings copyWith({ThemePreference? theme, EditorTextSize? textSize}) =>
      AppSettings(
        theme: theme ?? this.theme,
        textSize: textSize ?? this.textSize,
      );
}
