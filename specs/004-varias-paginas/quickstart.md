> **Reconstrucción actual · 2026-11-17:** use primero
> [la guía reproducible](../../docs/QUICKSTART_RECONSTRUCCION_LUIS.md).
> Los pasos y evidencias anteriores que siguen requieren su configuración indicada;
> no acreditan pruebas físicas ni una firma de la revisión actual. Release exige
> cuentas del servidor, HTTPS y clave propia; no admite firma debug ni HTTP local.

# Documentos de varias páginas

Arranca la app y la API siguiendo la [guía local del MVP](../001-handtext-mvp/quickstart.md).
Las cuentas son locales al dispositivo. La API se usa para reconocer y exportar;
PostgreSQL solo interviene en las rutas de cuentas del servidor y sus pruebas de contrato.
Se mantienen los requisitos de [la fase actual](../../docs/REQUISITOS_ACTUALES.md).


El límite actual es de diez páginas. Agrega, selecciona, mueve, reemplaza, recorta y
quita páginas desde la vista previa. Tras un fallo en una página, reintenta y comprueba
que las páginas ya reconocidas no se reenvían. El texto final respeta el orden elegido.

Desde `frontend/`:

```powershell
flutter test test/services/page_join_test.dart test/state/pages_flow_test.dart test/presentation/pages_screen_test.dart
```

Estas pruebas comprueban el límite, la limpieza de copias, las páginas sin texto y el
número de página en los errores. La captura de varias hojas reales requiere recorrido
en un emulador o dispositivo.
