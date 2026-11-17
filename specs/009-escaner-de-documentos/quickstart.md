> **Reconstrucción actual · 2026-11-17:** use primero
> [la guía reproducible](../../docs/QUICKSTART_RECONSTRUCCION_LUIS.md).
> Los pasos y evidencias anteriores que siguen requieren su configuración indicada;
> no acreditan pruebas físicas ni una firma de la revisión actual. Release exige
> cuentas del servidor, HTTPS y clave propia; no admite firma debug ni HTTP local.

# Escáner de hojas

Arranca la app y la API siguiendo la [guía local del MVP](../001-handtext-mvp/quickstart.md).
Las cuentas son locales al dispositivo. La API se usa para reconocer y exportar;
PostgreSQL solo interviene en las rutas de cuentas del servidor y sus pruebas de contrato.
Se mantienen los requisitos de [la fase actual](../../docs/REQUISITOS_ACTUALES.md).


Desde `frontend/`:

```powershell
flutter test test/state/scanner_flow_test.dart test/presentation/accessibility_test.dart test/presentation/language_test.dart
```

Comprueba una y varias hojas, agregar al final sin superar diez, cancelar sin perder
páginas y la alternativa «Tomar fotografía» cuando no hay escáner. Las pruebas usan un
escáner falso; la descarga de componentes de ML Kit y una hoja real deben comprobarse
en Android. No se afirma esa validación a partir de las pruebas simuladas.
