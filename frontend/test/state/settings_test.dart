import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:handtext_ai/config/app_config.dart';
import 'package:handtext_ai/models/app_settings.dart';
import 'package:handtext_ai/services/settings_store.dart';
import 'package:handtext_ai/state/settings_controller.dart';
import '../support/fakes.dart';

class FailingSettingsStore extends InMemorySettingsStore {
  @override
  Future<void> save(AppSettings settings) async =>
      throw const FileSystemException('synthetic');
}

void main() {
  test('T406: versión y build visibles coinciden con pubspec.yaml', () {
    final match = RegExp(
      r'^version:\s*(\d+\.\d+\.\d+)\+(\d+)\s*$',
      multiLine: true,
    ).firstMatch(File('pubspec.yaml').readAsStringSync());
    expect(match, isNotNull);
    expect(AppConfig.appVersion, match!.group(1));
    expect(AppConfig.appBuild, int.parse(match.group(2)!));
  });

  test(
    'ajustes antiguos, dañados o desconocidos mantienen valores seguros',
    () {
      for (final raw in [
        '',
        'null',
        '[]',
        '{',
        '{"language":"unknown","appLock":"yes"}',
        '{}',
      ]) {
        final settings = decodeSettings(raw);
        expect(settings.language, AppLanguage.spanish);
        expect(settings.appLock, isFalse);
      }
      expect(decodeSettings('{"theme":"dark"}').theme, ThemePreference.dark);
    },
  );
  test('todos los valores de tema, letra e idioma sobreviven JSON', () {
    for (final theme in ThemePreference.values) {
      for (final size in EditorTextSize.values) {
        for (final language in AppLanguage.values) {
          final decoded = decodeSettings(
            encodeSettings(
              AppSettings(
                theme: theme,
                textSize: size,
                language: language,
                tipsSeen: true,
                appLock: true,
              ),
            ),
          );
          expect(
            (
              decoded.theme,
              decoded.textSize,
              decoded.language,
              decoded.tipsSeen,
              decoded.appLock,
            ),
            (theme, size, language, true, true),
          );
        }
      }
    }
  });
  test(
    'archivo privado persiste y recupera ajustes, y tolera JSON dañado',
    () async {
      final directory = await Directory.systemTemp.createTemp(
        'handtext-settings-',
      );
      try {
        final store = FileSettingsStore(directory: () async => directory);
        expect((await store.load()).language, AppLanguage.spanish);
        await store.save(
          const AppSettings(
            theme: ThemePreference.dark,
            language: AppLanguage.english,
            appLock: true,
          ),
        );
        final restored = await FileSettingsStore(
          directory: () async => directory,
        ).load();
        expect(restored.theme, ThemePreference.dark);
        expect(restored.language, AppLanguage.english);
        expect(restored.appLock, isTrue);
        expect(
          await File(
            '${directory.path}/${FileSettingsStore.fileName}.tmp',
          ).exists(),
          isFalse,
        );
        await File(
          '${directory.path}/${FileSettingsStore.fileName}',
        ).writeAsString('{broken');
        expect((await store.load()).appLock, isFalse);
      } finally {
        await directory.delete(recursive: true);
      }
    },
  );
  test(
    'controlador aplica, notifica y persiste sin perder los demás campos',
    () async {
      final store = InMemorySettingsStore();
      final controller = SettingsController(store: store);
      await controller.load();
      var notifications = 0;
      controller.addListener(() => notifications++);
      await controller.setTheme(ThemePreference.dark);
      await controller.setTextSize(EditorTextSize.extraLarge);
      await controller.setLanguage(AppLanguage.english);
      await controller.markTipsSeen();
      await controller.setAppLock(true);
      expect(notifications, 5);
      expect(store.stored.theme, ThemePreference.dark);
      expect(store.stored.textSize, EditorTextSize.extraLarge);
      expect(store.stored.language, AppLanguage.english);
      expect(store.stored.tipsSeen, isTrue);
      expect(store.stored.appLock, isTrue);
      controller.dispose();
    },
  );
  test('un fallo de persistencia no anuncia activación del bloqueo', () async {
    final controller = SettingsController(store: FailingSettingsStore());
    await controller.load();
    await expectLater(
      controller.setAppLock(true),
      throwsA(isA<FileSystemException>()),
    );
    expect(controller.settings.appLock, isFalse);
    controller.dispose();
  });
}
