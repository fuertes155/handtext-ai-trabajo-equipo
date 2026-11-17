// T013/T110: revisión del aporte compartido T140 de Samuel, conservado.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:handtext_ai/theme/app_theme.dart';
import 'package:handtext_ai/theme/aurora.dart';

void main() {
  for (final brightness in Brightness.values) {
    test(
      'tema $brightness mantiene tipografía, paleta y controles de 52 dp',
      () {
        final theme = brightness == Brightness.light
            ? AppTheme.light()
            : AppTheme.dark();
        expect(theme.brightness, brightness);
        expect(theme.textTheme.bodyMedium!.fontFamily, 'Poppins');
        expect(theme.colorScheme.primary, Aurora.blue);
        expect(theme.colorScheme.onPrimary, Colors.white);
        expect(
          theme.filledButtonTheme.style!.minimumSize!.resolve({})!.height,
          greaterThanOrEqualTo(52),
        );
        expect(
          theme.colorScheme.surface,
          brightness == Brightness.light
              ? Aurora.lightBackground
              : Aurora.backgroundTop,
        );
      },
    );
  }
  test('Aurora conserva superficies marinas y foco visible', () {
    final theme = AppTheme.onAurora();
    expect(theme.brightness, Brightness.dark);
    expect(theme.scaffoldBackgroundColor, Colors.transparent);
    expect(theme.inputDecorationTheme.fillColor, Aurora.fieldFill);
    expect(
      (theme.inputDecorationTheme.focusedBorder as OutlineInputBorder)
          .borderSide
          .color,
      Aurora.blueLight,
    );
    expect(Aurora.background.colors, [
      Aurora.backgroundTop,
      Aurora.backgroundBottom,
    ]);
    expect(identical(AppTheme.onAurora(), theme), isTrue);
  });
}
