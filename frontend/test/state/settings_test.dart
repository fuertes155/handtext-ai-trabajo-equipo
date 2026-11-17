// Pruebas conservadas de consejos (T501), idioma (T703) y licencias.
// T401 y la comprobación de versión T406 se entregan a Luis Miguel.

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:handtext_ai/models/app_settings.dart';
import 'package:handtext_ai/presentation/font_licenses.dart';
import 'package:handtext_ai/services/settings_store.dart';
import 'package:handtext_ai/state/settings_controller.dart';

import '../support/fakes.dart';

void main() {
  group('FileSettingsStore', () {
    late Directory folder;

    setUp(() async {
      folder = await Directory.systemTemp.createTemp('handtext_ajustes_');
    });

    tearDown(() async {
      if (await folder.exists()) await folder.delete(recursive: true);
    });

    test(
      '[PA-H1-E4] [SC-601] recuerda que los consejos ya se vieron',
      () async {
        final store = FileSettingsStore(directory: () async => folder);

        await store.save(const AppSettings(tipsSeen: true));
        final loaded = await FileSettingsStore(
          directory: () async => folder,
        ).load();

        expect(loaded.tipsSeen, isTrue);
      },
    );

    test('[IE-H1-E4] [SC-804] guarda y recupera el idioma', () async {
      final store = FileSettingsStore(directory: () async => folder);

      await store.save(const AppSettings(language: AppLanguage.english));
      final loaded = await FileSettingsStore(
        directory: () async => folder,
      ).load();

      expect(loaded.language, AppLanguage.english);
    });

    test('[IE-H1-E1] [IE-H1-E5] sin idioma o con uno desconocido, español', () {
      expect(const AppSettings().language, AppLanguage.spanish);
      expect(
        decodeSettings('{"theme": "dark", "tipsSeen": true}').language,
        AppLanguage.spanish,
      );
      expect(
        decodeSettings('{"language": "klingon"}').language,
        AppLanguage.spanish,
      );
    });

    test(
      '[PA-H1-E1] los ajustes de 005, sin tipsSeen, muestran los consejos',
      () {
        final previous = decodeSettings(
          '{"theme": "dark", "textSize": "large"}',
        );

        expect(previous.tipsSeen, isFalse);
        expect(previous.theme, ThemePreference.dark); // lo demás se conserva
        expect(decodeSettings('{"tipsSeen": "sí"}').tipsSeen, isFalse);
      },
    );
  });

  group('SettingsController', () {
    test(
      '[PA-H1-E4] marcar los consejos como vistos conserva lo demás',
      () async {
        final store = InMemorySettingsStore()
          ..stored = const AppSettings(theme: ThemePreference.dark);
        final controller = SettingsController(store: store);
        await controller.load();

        await controller.markTipsSeen();

        expect(controller.settings.tipsSeen, isTrue);
        expect(store.stored.tipsSeen, isTrue);
        expect(store.stored.theme, ThemePreference.dark);
      },
    );

    test(
      '[PA-H1-E4] si no se puede guardar, no se repiten en esta sesión',
      () async {
        final controller = SettingsController(store: _FailingSettingsStore());

        await controller.markTipsSeen();

        expect(controller.settings.tipsSeen, isTrue);
      },
    );
  });

  test('[SC-503] las licencias incluyen la de Poppins', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerFontLicenses();

    final packages = <String>{
      await for (final entry in LicenseRegistry.licenses) ...entry.packages,
    };

    expect(packages, contains('Poppins'));
  });
}

/// Almacén que no puede guardar (por ejemplo, teléfono sin espacio).
class _FailingSettingsStore implements SettingsStore {
  @override
  Future<AppSettings> load() async => const AppSettings();

  @override
  Future<void> save(AppSettings settings) async =>
      throw const FileSystemException('sin espacio');
}
