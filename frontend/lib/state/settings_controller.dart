// Controlador de los ajustes (tarea T402; spec 005, Historia 1).
//
// Guarda los ajustes elegidos y avisa a las pantallas para que cambien al instante
// (tema de la app y tamaño de letra del editor). Si no se pueden guardar (por ejemplo,
// sin espacio), los ajustes igual se aplican mientras la app esté abierta.

import 'package:flutter/foundation.dart';

import '../models/app_settings.dart';
import '../services/settings_store.dart';

class SettingsController extends ChangeNotifier {
  SettingsController({required SettingsStore store}) : _store = store;

  final SettingsStore _store;
  AppSettings _settings = const AppSettings();

  AppSettings get settings => _settings;

  /// [AV-H1-E5] [AV-H1-E6] Lee los ajustes guardados (o los valores por omisión).
  Future<void> load() async {
    try {
      _settings = await _store.load();
    } on Exception {
      _settings = const AppSettings();
    }
    notifyListeners();
  }

  /// [AV-H1-E2] [AV-H1-E3] Tema automático, claro u oscuro.
  Future<void> setTheme(ThemePreference theme) =>
      _update(_settings.copyWith(theme: theme));

  /// [AV-H1-E4] Tamaño de letra del editor.
  Future<void> setTextSize(EditorTextSize size) =>
      _update(_settings.copyWith(textSize: size));

  Future<void> _update(AppSettings settings) async {
    _settings = settings;
    notifyListeners(); // se ve al instante
    try {
      await _store.save(settings); // [SC-501]
    } on Exception catch (error) {
      debugPrint('No se guardaron los ajustes: ${error.runtimeType}');
    }
  }
}
