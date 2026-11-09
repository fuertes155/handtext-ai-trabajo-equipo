# Cuentas locales e identidad visual

Arranca la app y la API siguiendo la [guía local del MVP](../001-handtext-mvp/quickstart.md).
Las cuentas son locales al dispositivo. La API se usa para reconocer y exportar;
PostgreSQL solo interviene en las rutas de cuentas del servidor y sus pruebas de contrato.
Se mantienen los requisitos de [la fase actual](../../docs/REQUISITOS_ACTUALES.md).


1. Sin API, crea una cuenta con datos sintéticos, cierra sesión y vuelve a ingresar.
2. Comprueba que una cuenta no abre el borrador ni el historial de otra.
3. Cambia a inglés desde la bienvenida y comprueba registro e ingreso.

Desde `frontend/`:

```powershell
flutter test test/services/local_auth_api_test.dart test/state/auth_controller_test.dart test/presentation/auth_screens_test.dart
flutter test test/services/storage_test.dart
```

`auth_api_client.dart` conserva el contrato de cuentas del servidor para los consumidores
que lo requieran. `main.dart` compone la app con `LocalAuthApi`, sin llamadas de red
para registrarse o ingresar. Se conservan Argon2id y el almacenamiento seguro de Samuel.

Para preparar una base de servidor nueva, ejecuta `db/setup_local_database.sql` con `psql`
y la variable `clave`, fuera de Git. No lo ejecutes sobre una base existente: crea el rol
`handtext` y su base. Configura `HANDTEXT_DATABASE_URL` en el entorno del backend y aplica
las migraciones con `python -m app.persistence.migrations`. Las pruebas automatizadas
usan una base temporal y no necesitan modificar la base personal.
