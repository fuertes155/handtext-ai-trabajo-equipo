# Nombres, búsqueda y organización

Arranca la app y la API siguiendo la [guía local del MVP](../001-handtext-mvp/quickstart.md).
Las cuentas son locales al dispositivo. La API se usa para reconocer y exportar;
PostgreSQL solo interviene en las rutas de cuentas del servidor y sus pruebas de contrato.
Se mantienen los requisitos de [la fase actual](../../docs/REQUISITOS_ACTUALES.md).


Desde `frontend/`:

```powershell
flutter test test/services/file_name_test.dart test/presentation/organize_test.dart test/services/history_store_test.dart
```

Verifica el nombre propuesto por título, caracteres no permitidos, el límite de
sesenta caracteres y el nombre alternativo si no hay título útil. Busca sin distinguir
mayúsculas ni tildes; renombra y vuelve a exportar. Confirma en Android que el diálogo
nativo para guardar recibe el nombre propuesto. Cancelar no registra una exportación.
