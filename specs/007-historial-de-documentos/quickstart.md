# Historial por cuenta

Arranca la app y la API siguiendo la [guía local del MVP](../001-handtext-mvp/quickstart.md).
Las cuentas son locales al dispositivo. La API se usa para reconocer y exportar;
PostgreSQL solo interviene en las rutas de cuentas del servidor y sus pruebas de contrato.
Se mantienen los requisitos de [la fase actual](../../docs/REQUISITOS_ACTUALES.md).


Desde `frontend/`:

```powershell
flutter test test/services/history_store_test.dart test/state/history_flow_test.dart test/presentation/history_screen_test.dart test/services/storage_test.dart
```

Exporta un documento, ábrelo desde «Mis documentos», corrígelo y vuelve a guardarlo:
debe actualizarse la misma entrada. Comprueba la confirmación si hay cambios sin
exportar, el borrador con `historyId`, eliminar y borrar todo. Se conserva la carga
asíncrona del historial incorporada por Samuel.

Buscar y renombrar forman parte de la evolución 010; véase el [alcance vigente](spec.md).
El historial guarda texto y metadatos en el teléfono, sin sincronización al servidor.
