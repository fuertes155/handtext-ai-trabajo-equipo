> **Reconstrucción actual · 2026-11-17:** use primero
> [la guía reproducible](../../docs/QUICKSTART_RECONSTRUCCION_LUIS.md).
> Los pasos y evidencias anteriores que siguen requieren su configuración indicada;
> no acreditan pruebas físicas ni una firma de la revisión actual. Release exige
> cuentas del servidor, HTTPS y clave propia; no admite firma debug ni HTTP local.

# Consejos y accesibilidad

Arranca la app y la API siguiendo la [guía local del MVP](../001-handtext-mvp/quickstart.md).
Las cuentas son locales al dispositivo. La API se usa para reconocer y exportar;
PostgreSQL solo interviene en las rutas de cuentas del servidor y sus pruebas de contrato.
Se mantienen los requisitos de [la fase actual](../../docs/REQUISITOS_ACTUALES.md).


Desde `frontend/`:

```powershell
flutter test test/state/settings_test.dart test/presentation/accessibility_test.dart
```

Las pruebas recorren las pantallas con letra al 100 % y 200 %, nombres accesibles y
objetivos táctiles Android de 48 dp. Comprueban también el estado `tipsSeen` con archivos
antiguos y dañados. Repítelo con TalkBack en un emulador o teléfono: una prueba de widgets
no acredita la revisión auditiva de TalkBack ni la cámara real.
