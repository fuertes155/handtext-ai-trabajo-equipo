# Palabras dudosas, recorte y compartir

Arranca la app y la API siguiendo la [guía local del MVP](../001-handtext-mvp/quickstart.md).
Las cuentas son locales al dispositivo. La API se usa para reconocer y exportar;
PostgreSQL solo interviene en las rutas de cuentas del servidor y sus pruebas de contrato.
Se mantienen los requisitos de [la fase actual](../../docs/REQUISITOS_ACTUALES.md).


1. Elige una imagen sintética y revisa la vista previa antes de autorizar OCR.
2. Recorta o gira, cancela una edición y comprueba que puedes volver a la original.
3. Revisa las palabras dudosas, corrige el texto, exporta y comparte la última exportación.
4. Comprueba que cancelar o fallar no pierde el texto ni sustituye una imagen válida.

Desde `frontend/`:

```powershell
flutter test test/state/extras_flow_test.dart test/presentation/extras_screens_test.dart test/services/storage_test.dart
```

Desde `backend/`, con su entorno activado:

```powershell
python -m pytest tests/test_google_vision_provider.py tests/test_uncertain_words.py
```

El transporte de Google en estas pruebas es simulado; no prueba OCR real.
