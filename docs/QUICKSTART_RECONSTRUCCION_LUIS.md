# Reproducir la reconstrucción de Luis

Resultados actuales del 2026-11-17, separados de la entrega del 16. Repositorio:
`/home/luisdaca/Escritorio/handtext-ai-trabajo-equipo`, rama
`entrega/railway-documentacion-20261116`, PR #221 en borrador.
No desplegar ni operar la base de producción con estos comandos.

## Entorno de esta ejecución

Flutter 3.44.9, Dart 3.12.2, Python 3.12.16 y dependencias exactas de requirements-dev.
El Python 3.14 del sistema no dispone de wheel pgserver para este entorno; se creó
backend/.venv312 con Python 3.12 aislado mediante uv.
Gradle 8.12/AGP 8.9.1/Kotlin 2.1.0 compilan con Temurin 17.0.21, descargado de
Adoptium y comprobado por SHA-256. Java 25 de Android Studio no es compatible con
este Gradle. La configuración Flutter se aisló con XDG_CONFIG_HOME; no se alteró Java
global. Flutter avisa de futuras retiradas de soporte para esas versiones; no se
omitieron controles. Se conservan las versiones compatibles verificadas aquí.

Jetifier se desactiva porque todas las dependencias usan AndroidX: transformar los
JAR del motor agotó el heap de 2.5 GB. Dos trabajadores limitan memoria. La segunda
compilación y la repetición final resultaron correctas. Las opciones builtInKotlin/newDsl
false fueron añadidas por la migración de Flutter 3.44 y quedan documentadas en Gradle.

## Backend aislado

Desde backend, con Python 3.12 disponible:

```bash
python3.12 -m venv .venv312
.venv312/bin/pip install -r requirements-dev.txt
.venv312/bin/pip check
.venv312/bin/ruff check .
.venv312/bin/ruff format --check .
.venv312/bin/pytest -q
.venv312/bin/pytest --noconftest -q ../checks/test_reinicio_luis.py
```

218 pruebas backend y siete controles de autorización/política aprobados. La fixture
crea PostgreSQL temporal; no usa HANDTEXT_DATABASE_URL de producción. DOCX/PDF incluyen
contenido, Unicode, límites/errores y font embedding. Advertencia conocida de Starlette
por TestClient/httpx en los checks; no se oculta ni se cambia la dependencia sin validar.

## Flutter y contratos reales

Primera terminal, desde backend:

```bash
.venv312/bin/python -m tools.serve_contract_test --port 8765
```

Esto inicia exclusivamente 127.0.0.1:8765 y una base PostgreSQL temporal, sin leer
credenciales externas ni llamar OCR de pago. Ctrl+C cierra y limpia esa base.
Segunda terminal, desde frontend:

```bash
flutter pub get
dart format --output=none --set-exit-if-changed lib test integration_test
flutter analyze --no-pub
HANDTEXT_API_URL=http://127.0.0.1:8765/ flutter test --no-pub --reporter expanded
```

350 pruebas aprobadas sin omisiones. Sin HANDTEXT_API_URL, nueve contratos existentes
se omiten: esa ejecución parcial no sustituye el resultado completo anterior.
Se corrigió un 401 sin Bearer: informa falta de autenticación remota sin expulsar una
cuenta local. Con Bearer rechazado pide iniciar sesión; se comprueba incluso si el
token cambia mientras llega la respuesta. No se debilitó la prueba de contrato.
Las pruebas incluyen inglés y español al 100/200 %, sin reescribir la paleta T140 ni
los contratos T905. No acreditan TalkBack ni biometría físicos.

## APK debug actual

Comandos exactos usados (JDK temporal disponible en esta ejecución):

```bash
XDG_CONFIG_HOME=/tmp/handtext-flutter-config flutter config --jdk-dir=/tmp/handtext-tools/jdk17
XDG_CONFIG_HOME=/tmp/handtext-flutter-config flutter build apk --debug --no-pub
mkdir -p build/verification
cp build/app/outputs/flutter-apk/app-debug.apk build/verification/handtext-debug-20261117.apk
PATH=/tmp/handtext-tools/jdk17/bin:$PATH /home/luisdaca/Android/Sdk/build-tools/36.0.0/apksigner verify --verbose build/verification/handtext-debug-20261117.apk
```

APK absoluto:
`/home/luisdaca/Escritorio/handtext-ai-trabajo-equipo/frontend/build/verification/handtext-debug-20261117.apk`

SHA-256: `acf454c15ed67ddba9ef3e1c05dc61c89751a5fabae57ed2764a3946b9b352ea`.
Paquete com.handtextai.team.debug, versión 1.0.0 (1), minSdk 24, targetSdk 36.
Firma debug válida v2 comprobada; **no es un APK de distribución**. El manifiesto
fusionado mantiene allowBackup=false, reglas de exclusión de transferencia y uCrop
privado. No pide permisos generales de almacenamiento. La release mantiene HTTP
prohibido; debug permite desarrollo local explícito, sin token por defecto.

## Distribución y recursos pendientes

Desde la raíz, con JDK 17 y dependencias Android descargadas:

```bash
JAVA_HOME=/tmp/handtext-tools/jdk17 backend/.venv312/bin/pytest --noconftest -q checks/test_release_policy.py
```

Diez pruebas ejecutan la política Gradle con certificados sintéticos, incluyendo
rechazo de firma debug y configuración insegura. No firman APK de entrega.
Desde frontend se intentó:

```bash
XDG_CONFIG_HOME=/tmp/handtext-flutter-config flutter build apk --release --split-per-abi --no-pub --dart-define=HOSTED_ACCOUNTS=true --dart-define=API_BASE_URL=https://example.invalid/
```

Falló como corresponde con SIGNING_REQUIRED: falta clave autorizada del proyecto.
No se usó una clave sintética para fabricar una entrega, ni se imprimieron secretos.
No se produjo APK release. Véase la [guía de firma](../specs/005-ajustes-y-version-final/quickstart.md).
Las verificaciones físicas de cámara, escáner/Play Services, guardar/compartir,
TalkBack, PIN/huella y arranque release requieren los recursos correspondientes.
No se ha cambiado PIN, borrado datos ni desinstalado la app de ningún teléfono.
La revisión de otro integrante sigue pendiente en las 72 issues.

## Integración Android

Se prepara AVD nuevo HandText_Luis_20261117, Android 35 Google APIs x86_64,
puerto 5580, KVM, 2 GB y modo sin ventana. No contiene datos personales.
El estado y resultado de su ejecución se incorporarán al informe actual.
Comando previsto con la API temporal anterior, sin tokens de desarrollo dentro del APK:

```bash
XDG_CONFIG_HOME=/tmp/handtext-flutter-config flutter test integration_test/flujo_completo_test.dart -d emulator-5580 --dart-define=E2E_LOCAL_ACCOUNTS=false --dart-define=API_BASE_URL=http://10.0.2.2:8765/
```

Esa composición de prueba debug usa cuentas reales en la API temporal y Bearer;
no modifica la exigencia HTTPS de la distribución. OCR/selector/guardado son simulados
por el contrato de la prueba; Word, PostgreSQL, almacenamiento seguro e historial son
reales. No afirmar aprobado hasta registrar la ejecución.
