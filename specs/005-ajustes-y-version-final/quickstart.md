> Entrega 2026-11-16. La [especificación 013](../013-entrega-railway/spec.md) amplía este alcance para Railway, HTTPS y cuentas del servidor. Consultar la [guía final](../../docs/ENTREGA_FINAL.md). El modo local conserva su configuración de desarrollo.

# Ajustes, licencias y compilación

Arranca la app y la API siguiendo la [guía local del MVP](../001-handtext-mvp/quickstart.md).
Las cuentas son locales al dispositivo. La API se usa para reconocer y exportar;
PostgreSQL solo interviene en las rutas de cuentas del servidor y sus pruebas de contrato.
Se mantienen los requisitos de [la fase actual](../../docs/REQUISITOS_ACTUALES.md).


Desde `frontend/`:

```powershell
flutter test test/state/settings_test.dart test/presentation/settings_screens_test.dart
flutter build apk --debug --target-platform android-x64
```

Revisa que tema, tamaño, idioma y consejos se conserven; abre «Acerca de» y «Licencias».
Regenera el ícono con `backend/.venv/Scripts/python.exe frontend/tool/generate_launcher_icon.py`
desde la raíz, con Pillow instalado. Las imágenes generadas están versionadas.

La clave de distribución y `frontend/android/key.properties` permanecen fuera de Git.
Esta integración no crea una clave ni configura la firma de distribución: el APK de
prueba no acredita una entrega firmada. El idioma español/inglés forma parte del
alcance vigente, descrito en [spec.md](spec.md).
