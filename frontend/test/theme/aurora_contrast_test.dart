import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:handtext_ai/theme/aurora.dart';

double contrast(Color first, Color second) {
  final a = first.computeLuminance();
  final b = second.computeLuminance();
  return ((a > b ? a : b) + 0.05) / ((a > b ? b : a) + 0.05);
}

void main() {
  for (final background in [
    Aurora.backgroundTop,
    Aurora.backgroundBottom,
    Aurora.surface,
    Aurora.fieldFill,
  ]) {
    for (final foreground in [
      Aurora.textPrimary,
      Aurora.textSecondary,
      Aurora.textMuted,
      Aurora.blueLight,
      Aurora.success,
      Aurora.warning,
      Aurora.danger,
    ]) {
      test('SC-208 texto $foreground sobre $background ≥ 4.5', () {
        expect(contrast(foreground, background), greaterThanOrEqualTo(4.5));
      });
    }
    test('SC-208 foco e iconos sobre $background ≥ 3', () {
      expect(contrast(Aurora.blueLight, background), greaterThanOrEqualTo(3));
      expect(contrast(Aurora.sky, background), greaterThanOrEqualTo(3));
    });
  }
  test('texto de botones y modo claro cumplen AA', () {
    expect(contrast(Colors.white, Aurora.blue), greaterThanOrEqualTo(4.5));
    for (final background in [
      Aurora.lightBackground,
      Colors.white,
      Aurora.lightSurfaceAlt,
    ]) {
      for (final text in [
        Aurora.lightText,
        Aurora.lightTextSecondary,
        Aurora.blue,
      ]) {
        expect(contrast(text, background), greaterThanOrEqualTo(4.5));
      }
      expect(
        contrast(Aurora.lightOutline, background),
        greaterThanOrEqualTo(3),
      );
    }
  });
}
