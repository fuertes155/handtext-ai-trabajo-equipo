# Entrega final de HandText AI

## Archivos y acceso

- API: `https://handtext-api-production.up.railway.app/`.
- Salud: `GET /health`, respuesta esperada `200` con `status=ok`.
- APK ARM64 recompilado y firmado el 2026-11-16: `HandText-AI-entrega-20261116-arm64.apk`, 19 817 999 bytes.
- SHA-256: `62DFCC853BBC62BEE6971E08121E242A2F0256552CBF89D48B4A8E3E299655C1`.
- Carpeta local del APK: `D:/Flutter2/HandText-Entrega-Railway-20261109/output/`. La clave de firma permanece fuera de Git.
- La profesora necesita acceso al repositorio privado. Cada integrante debe cargar en Campus UCC el enlace, el APK, la presentación y el registro de verificaciones.
- [Presentación editable con notas para exponer](presentacion/HandText-AI-entrega-final.pptx): 16 diapositivas, desde las funciones hasta el ingreso, sesiones y PostgreSQL.
- [Descargar paquete de entrega en GitHub](https://github.com/fuertes155/handtext-ai-trabajo-equipo/releases/tag/entrega-20261116): APK, diapositivas y suma de comprobación. Está marcado como preentrega, pendiente del recorrido final en Samsung.

Consultar [resultados y límites](VERIFICACION_ENTREGA.md). `/health` comprueba la API. La aplicación se demuestra mediante el APK Android.

El APK ya se instaló y verificó en Samsung SM-A055M con Android 15. El [registro Android](PRUEBAS_DISPOSITIVO_ENTREGA.md) incluye OCR de galería, Word/PDF guardados, lectura del PDF en Samsung Notes, sesión, historial y errores controlados. La carpeta de evidencias contiene capturas originales y documentos sintéticos. TalkBack y bloqueo quedaron pendientes por indicación del usuario; no se acredita todavía el escaneo controlado de papel ni precisión manuscrita.

## Instalación y demo

1. Copiar el APK al teléfono y abrirlo para instalarlo. Si aparece conflicto de firma o falta de espacio, detenerse y registrar el mensaje antes de modificar datos.
2. Crear una cuenta del servidor. La cuenta de la prueba local se conserva en la versión de desarrollo.
3. Con Internet, tocar «Escanear hoja». Usar una hoja de ejemplo sin datos personales y buena iluminación.
4. Confirmar el escáner, revisar la foto, tocar «Aceptar y reconocer texto» y autorizar el envío al servidor.
5. Corregir una palabra en «Revisar texto». Exportar «Word (.docx)», elegir dónde guardarlo y abrir el archivo.
6. Mostrar «Mis documentos», reabrir el texto, cerrar sesión y volver a ingresar.

La entrega requiere Internet para cuentas, OCR y exportación. Historial y borradores permanecen en el teléfono. La disponibilidad depende del plan y los recursos de Railway.

## Desarrollo y compilación

Usar Flutter compatible con `frontend/pubspec.yaml` y su lockfile, Android SDK/JDK compatibles con el wrapper Gradle y Python 3.12. PostgreSQL respalda las cuentas del servidor. Desde la raíz, en PowerShell:

```powershell
py -3.12 -m venv backend/.venv
backend/.venv/Scripts/python.exe -m pip install -r backend/requirements-dev.txt
Push-Location backend
.venv/Scripts/python.exe -m pytest -q
.venv/Scripts/python.exe -m ruff check app tools tests
Pop-Location
Push-Location frontend
flutter pub get
flutter analyze --no-pub
dart format --output=none --set-exit-if-changed lib test
flutter test --no-pub
flutter build apk --release --target-platform android-arm64 --dart-define=HOSTED_ACCOUNTS=true --dart-define=API_BASE_URL=https://handtext-api-production.up.railway.app/
Pop-Location
```

Para reproducir la firma, configurar `frontend/android/key.properties` localmente con la clave autorizada de distribución. Ese archivo y el keystore están excluidos de Git. También puede firmarse con `apksigner sign`, suministrando la contraseña por entorno o entrada protegida. Comprobar con `apksigner verify --verbose`. El fallback debug de Gradle se conserva para desarrollo; la entrega requiere verificar la firma de distribución.

## Despliegue Railway

Construir desde la raíz con `Dockerfile`. Incluye `backend/app`, fuentes PDF y `db/migrations`, instala RapidOCR y descarga tres modelos con SHA-256 fijado. Aplica las migraciones al arrancar y ejecuta un trabajador Uvicorn como usuario sin privilegios.

| Variable | Configuración |
| --- | --- |
| `HANDTEXT_DATABASE_URL` | Referencia privada `${{Postgres.DATABASE_URL}}`, adaptada al nombre del servicio |
| `HANDTEXT_OCR_PROVIDER` | `local`, definida en Docker |
| `HANDTEXT_LOCAL_OCR_MODELS` | `/opt/handtext/ocr`, definida en Docker |
| `PORT` | `8000` en la entrega existente, mismo puerto del dominio |

Mantener desactivado `HANDTEXT_LOCAL_DEV_TOKEN` en el servicio público. RapidOCR procesa en el servidor sin requerir una clave de OCR externa. Los modelos se descargan durante la construcción. Un solo trabajador evita duplicar su consumo de memoria. Verificar consumo y plan antes de la exposición.

## Límites y recuperación

La [guía local](../specs/001-handtext-mvp/quickstart.md) conserva `LocalAuthApi` y ADB. Se selecciona por defecto sin `HOSTED_ACCOUNTS=true`. Las cuentas locales no se migran automáticamente al servidor.

La precisión manuscrita necesita diez hojas autorizadas con sus referencias y cálculo CER. El escáner puede descargar componentes de Google Play Services la primera vez. Registrar con fecha y versión los recorridos de biometría, TalkBack y guardado nativo. Si `/health` falla, comprobar DNS y estado del despliegue antes de usar cuentas o documentos reales.
