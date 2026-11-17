// Reinicio 2026-11-17: las regiones marcadas están pendientes de LUISDACA.
// Los comentarios anteriores describen requisitos; no son verificación del código actual.
// Controlador de los ajustes (tarea T402; spec 005, Historia 1).
//
// Guarda los ajustes elegidos y avisa a las pantallas para que cambien al instante
// (tema de la app y tamaño de letra del editor). Si no se pueden guardar (por ejemplo,
// sin espacio), los ajustes igual se aplican mientras la app esté abierta.
// Spec 006: recuerda que los consejos para una buena foto ya se vieron.
// Spec 008: el idioma de la interfaz.

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

  /// Spec 011: guarda si el bloqueo con huella está activo. Lo llama
  /// AppLockController después de verificar a la persona.
  Future<void> setAppLock(bool enabled) {
    throw UnimplementedError("T704,T1003 pendiente de LUISDACA");
  }

  /// [IE-H1-E2] [IE-H1-E4] [SC-804] Idioma de la interfaz; se aplica al instante.
  Future<void> setLanguage(AppLanguage language) {
    throw UnimplementedError("T704,T1003 pendiente de LUISDACA");
  }

  /// [PA-H1-E3] [PA-H1-E4] Los consejos ya se vieron o se saltaron: no vuelven a
  /// aparecer solos [SC-601].
  Future<void> markTipsSeen() => _update(_settings.copyWith(tipsSeen: true));

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
