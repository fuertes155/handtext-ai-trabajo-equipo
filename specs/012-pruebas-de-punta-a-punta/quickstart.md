> **Reconstrucción actual · 2026-11-17:** use primero
> [la guía reproducible](../../docs/QUICKSTART_RECONSTRUCCION_LUIS.md).
> Los pasos y evidencias anteriores que siguen requieren su configuración indicada;
> no acreditan pruebas físicas ni una firma de la revisión actual. Release exige
> cuentas del servidor, HTTPS y clave propia; no admite firma debug ni HTTP local.

# Pruebas de punta a punta en Android

Se conserva `frontend/integration_test/flujo_completo_test.dart`, ampliado en handtext
para cuentas locales, limpieza aislada, inglés e historial con cincuenta documentos.
El OCR y los selectores nativos se simulan en esta prueba; la API genera el Word real.
No se confunde este recorrido con una medición real de la calidad del OCR.

1. Sigue la [guía local](../001-handtext-mvp/quickstart.md) y arranca la API en 8001.
2. Configura fuera de Git el token local de documentos en la API y en el archivo de
   parámetros Flutter. Usa `http://10.0.2.2:8001/` para el emulador; por USB en un
   teléfono, usa `adb reverse tcp:8001 tcp:8001` y `http://127.0.0.1:8001/`.
3. Desde `frontend/`, ejecuta:

```powershell
flutter test integration_test -d <dispositivo> --dart-define-from-file=<archivo-local>
```

`E2E_LOCAL_ACCOUNTS` es verdadero por omisión. `E2E_STRICT_HISTORY=true` exige además
abrir el historial en menos de un segundo. Usa un dispositivo de pruebas o una variante
separada para conservar la instalación de uso diario y su firma.

## Contrato HTTP entre clientes y servidor

`frontend/test/integration/api_contract_test.dart` comprueba el contrato remoto de
cuentas y documentos contra un backend con PostgreSQL de pruebas. Este contrato no
cambia las cuentas locales de la app normal. Activa su ejecución indicando la API:

```powershell
$env:HANDTEXT_API_URL = "http://127.0.0.1:<puerto-de-pruebas>/"
flutter test test/integration/api_contract_test.dart
```

Sin esa variable, los nueve casos se omiten. Usan una cuenta sintética temporal y la
eliminan al terminar. Para comprobar el caso de OCR no configurado sin llamadas a
Google, ejecuta un backend aislado sin clave. El flujo local principal sigue usando
la API en 8001. La [guía original](quickstart.origen.md) se conserva como referencia
histórica; prevalecen los [requisitos actuales](../../docs/REQUISITOS_ACTUALES.md).
