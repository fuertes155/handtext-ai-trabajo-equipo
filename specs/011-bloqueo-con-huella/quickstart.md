# Bloqueo con verificación del dispositivo

Arranca la app y la API siguiendo la [guía local del MVP](../001-handtext-mvp/quickstart.md).
Las cuentas son locales al dispositivo. La API se usa para reconocer y exportar;
PostgreSQL solo interviene en las rutas de cuentas del servidor y sus pruebas de contrato.
Se mantienen los requisitos de [la fase actual](../../docs/REQUISITOS_ACTUALES.md).


Desde `frontend/`:

```powershell
flutter test test/state/settings_test.dart test/presentation/app_lock_test.dart test/presentation/accessibility_test.dart test/presentation/language_test.dart
```

Comprueba bloqueo apagado por omisión, activación solo tras verificar, cancelación y
un teléfono sin método disponible. Con sesión iniciada, prueba la vuelta desde segundo
plano y el desbloqueo sin perder documentos. Sin sesión no debe aparecer el bloqueo.
Revisa privacidad e idioma en la pantalla bloqueada. La app recibe el resultado de
Android; no almacena huellas ni datos biométricos. Una prueba con autenticador falso no
sustituye la comprobación del diálogo del sistema en un dispositivo.
