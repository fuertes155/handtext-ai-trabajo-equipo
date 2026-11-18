# Ajustes, versión y firma — reconstrucción actual

> **Cierre posterior:** 72/72 tareas de Luis verificadas y aceptadas. Release firmada
> con nueva clave autorizada, cinco arranques <5 s y pruebas Android nativas aprobadas.
> [Evidencia final y comandos](../../docs/CIERRE_LUIS.md). Los estados pendientes anteriores son históricos.

[Entorno y comandos completos](../../docs/QUICKSTART_RECONSTRUCCION_LUIS.md).
Desde frontend, ejecute las suites de ajustes y «Acerca de»:

```bash
flutter test --no-pub test/state/settings_test.dart test/presentation/settings_screens_test.dart
```

La versión/build de AppConfig coincide con pubspec.yaml (1.0.0+1). Los ajustes se
guardan en el teléfono y se conservan al cambiar de cuenta; el bloqueo solo se anuncia
activo después de verificar identidad y persistir. Licencias accesibles sin sesión.

Para distribución, configure **su clave autorizada existente** fuera del repositorio,
referida por frontend/android/key.properties (archivo ignorado). Campos: storeFile,
storePassword, keyAlias, keyPassword. No publique ni envíe esos valores al chat.
No se genera una clave nueva para reemplazar la del proyecto.

```bash
flutter build apk --release --split-per-abi --dart-define=HOSTED_ACCOUNTS=true --dart-define=API_BASE_URL=https://SU-API-AUTORIZADA/
```

Gradle rechaza HTTP, datos de acceso dentro de la URL, tokens locales, cuentas locales,
clave ausente/inválida o certificado debug. No hay fallback debug. La prueba actual
por arquitectura se detiene con SIGNING_REQUIRED; no se ha producido un APK release.
Las diez pruebas con certificados sintéticos comprueban la política, no una firma
real del proyecto ni instalación/arranque. La entrega histórica está en quickstart.origen.md.
