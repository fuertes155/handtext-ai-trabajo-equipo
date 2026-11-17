> **Reconstrucción actual · 2026-11-17:** use primero
> [la guía reproducible](../../docs/QUICKSTART_RECONSTRUCCION_LUIS.md).
> Los pasos y evidencias anteriores que siguen requieren su configuración indicada;
> no acreditan pruebas físicas ni una firma de la revisión actual. Release exige
> cuentas del servidor, HTTPS y clave propia; no admite firma debug ni HTTP local.

# Español e inglés

Arranca la app y la API siguiendo la [guía local del MVP](../001-handtext-mvp/quickstart.md).
Las cuentas son locales al dispositivo. La API se usa para reconocer y exportar;
PostgreSQL solo interviene en las rutas de cuentas del servidor y sus pruebas de contrato.
Se mantienen los requisitos de [la fase actual](../../docs/REQUISITOS_ACTUALES.md).


Desde `frontend/`:

```powershell
flutter test test/state/settings_test.dart test/presentation/language_test.dart
```

Cambia el idioma desde la bienvenida y desde Ajustes. Reabre la app y comprueba la
persistencia. Revisa fechas, tamaños, cámara, escáner, guardar, compartir, historial,
bloqueo y privacidad en ambos idiomas. El idioma es un ajuste del teléfono; cambiarlo
no cambia el texto reconocido. Se conservan los mensajes locales de autenticación.
