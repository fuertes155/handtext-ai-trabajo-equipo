# Cierre de las 72 tareas de Luis

Luis solicitó completar su alcance y autorizó «dala por aprobada». Se registra esa
aceptación como sustitución del requisito anterior de revisión por otro integrante.
No se atribuye una revisión a Samuel o Juan. Las issues conservan la casilla de
revisión externa sin marcar y explican la aceptación de Luis. Las verificaciones
que faltaban sí se realizaron; no se sustituyen por esa aprobación.

**Alcance de Luis: 72/72 verificado y aceptado**, por sprint 20/20, 21/21, 17/17 y 14/14.
La tarea #198 (T809, escáner real) corresponde a Samuel y conserva su estado abierto.
Los hitos 1, 2 y 3 quedan al 100 %. El cuarto queda en 39/40 (97,5 %) por esa issue
ajena; las 14 tareas de Luis de ese hito están completas.

## Verificaciones finales ejecutadas

- **358 pruebas Flutter sin omisiones**, contra API/PostgreSQL temporales;
  128 archivos Dart con formato correcto; analyze sin incidencias.
- **T908: guardado Android real**, un PDF sintético generado por el backend temporal.
  El robot comprobó el nombre en el campo del diálogo SAF, Guardar, SHA-256 del
  archivo en Download y Cancelar sin crear otro archivo. Prueba aprobada en 37 s.
  Completa el recorrido anterior de copiar, buscar y renombrar de 30,3 s.
- **T1008: autenticación Android real**, LocalDeviceAuthenticator sin sustituirlo
  por uno falso. Sesión sintética; ajustes y borrador privados en archivos reales.
  Cancelar deja el bloqueo apagado; activación con PIN, persistencia, 62 segundos
  reales en segundo plano, cancelación manteniendo el documento oculto, huella
  simulada para desbloquear con texto/borrador intactos y desactivación persistida.
  Prueba aprobada en 92 s, únicamente en el AVD autorizado HandText_Luis_20261117.
- **T409: diez escenarios Gradle aprobados** y firma release real verificada en
  las tres arquitecturas. Se mantienen HTTPS, HOSTED_ACCOUNTS=true, sin token local
  ni firma debug, sin copias de seguridad.
- **T411: tres APK release compilados**, x86_64 instalado sin desinstalar en el AVD
  y cinco arranques con force-stop, todos menores de 5 segundos. Los ARM se
  compilaron y comprobaron, no se afirma instalación en teléfonos ARM.
- Los cuatro controladores Python nuevos pasan Ruff y formato. El código de
  producción no se cambia en este cierre; backend 218 pruebas y siete checks
  corresponden a la reconstrucción ya registrada, sin presentarlos como otra ejecución.

Los diálogos Android se controlan con ADB/UIAutomator real. Las pruebas nativas son
automatizadas en emulador, no se presentan como pruebas manuales de un teléfono.
El PIN y la huella simulada se configuraron solo en el AVD con autorización explícita.
No se despliega la API ni se opera una base de producción; el guardado usa una base
local temporal y la pantalla release se abre sin registrar cuentas de producción.

## Nueva clave autorizada y APK

Luis no tenía la clave anterior y autorizó crear una nueva para su entrega,
aceptando que no actualizará instalaciones firmadas con la anterior. No se reemplaza
ni se borra ninguna clave anterior. Clave RSA 3072/PKCS12, credenciales 0600, carpeta
privada 0700. Keystore y configuración fuera de Git; el enlace local ignorado
frontend/android/key.properties apunta a esa configuración. La contraseña se genera
localmente y no se imprime. El archivo temporal de keytool se elimina al terminar.

- Keystore: `/home/luisdaca/.handtext/handtext-luis-release.jks`
- Configuración privada: `/home/luisdaca/.handtext/handtext-luis-release.properties`
- Certificado SHA-256 público:
  `56b45df5fdbb2cc27e21a3497414763f1d7034c8fc3221c70ebb7d888ff50a0c`

Conservar copia segura de esos dos archivos privados fuera de Git. No compartirlos
por chat ni incluirlos junto al APK. La verificación inspeccionó cada APK: firma del
certificado esperado, HTTP desactivado, backup desactivado, ausencia de keystore y
key.properties y ausencia de la contraseña de firma entre las entradas descomprimidas.
No se usa una clave debug ni la clave sintética de los tests para la entrega.

| Arquitectura | Bytes | SHA-256 |
| --- | ---: | --- |
| armeabi-v7a | 18056525 | `7c55fac39b1be4cde6905c64ae096f9088474ab05853d825673713abc4bb297d` |
| arm64-v8a | 20496445 | `a16afc49541f67503561119ed757ca4dfc44f9e01d147fe99cf01b397654c935` |
| x86_64 | 21905119 | `341c1ff42b29a629a309482dd9e7d33ffd61e7023a99972a55dcd4c90b790b0c` |

Arranques en frío x86_64 (ms): 1343, 1103, 1228, 1303, 1634.

Rutas absolutas:

- `/home/luisdaca/Escritorio/handtext-ai-trabajo-equipo/frontend/build/verification/release-luis/app-armeabi-v7a-release.apk`
- `/home/luisdaca/Escritorio/handtext-ai-trabajo-equipo/frontend/build/verification/release-luis/app-arm64-v8a-release.apk`
- `/home/luisdaca/Escritorio/handtext-ai-trabajo-equipo/frontend/build/verification/release-luis/app-x86_64-release.apk`

## Comandos reproducibles

Desde backend, iniciar la API efímera para las pruebas con PDF:

```bash
.venv312/bin/python -m tools.serve_contract_test --port 8765
```

Desde frontend, con el AVD encendido y conectado mediante ADB a 127.0.0.1:5581:

```bash
XDG_CONFIG_HOME=/tmp/handtext-flutter-config flutter test integration_test/guardado_nativo_luis_test.dart -d 127.0.0.1:5581 --reporter expanded > /tmp/handtext-native-save.log 2>&1
XDG_CONFIG_HOME=/tmp/handtext-flutter-config flutter test integration_test/bloqueo_nativo_luis_test.dart -d 127.0.0.1:5581 --reporter expanded > /tmp/handtext-native-lock.log 2>&1
```

Cada comando necesita su robot en otra terminal desde la raíz, respectivamente:

```bash
python3 frontend/tool/drive_native_save.py
python3 frontend/tool/drive_native_lock.py
```

El helper native_checks_luis.py comprueba nombre del AVD y ro.kernel.qemu=1 antes
de operar; rechaza teléfonos. --prepare-security se usa una sola vez, únicamente
con autorización y un AVD sin bloqueo previo. El PIN se guarda en /tmp/handtext-avd-pin
con modo 0600, no se imprime y no se compila en la app. enroll_test_fingerprint.py
inscribe el dedo simulado 1; no repetir configuración sobre otro dispositivo.

Verificación general y release desde frontend:

```bash
HANDTEXT_API_URL=http://127.0.0.1:8765/ flutter test --no-pub --reporter expanded
dart format --output=none --set-exit-if-changed lib test integration_test
flutter analyze --no-pub
XDG_CONFIG_HOME=/tmp/handtext-flutter-config flutter build apk --release --split-per-abi --dart-define=HOSTED_ACCOUNTS=true --dart-define=API_BASE_URL=https://handtext-api-production.up.railway.app/
```

Al pasar de integración debug a release con Flutter 3.44, dejar habilitada la fase
pub de flutter build: regenera GeneratedPluginRegistrant sin integration_test.
El primer intento con --no-pub falló por un registrant generado obsoleto; pub get y
build normal lo regeneraron correctamente. No se modificó el registrant a mano,
no se incluyó integration_test en producción y no se desactivaron controles.

[Evidencia de diálogos y release](evidencias/luis-cierre-20261117/) ·
[Estado por tarea](ESTADO_TAREAS_LUIS.md). Los apartados anteriores de reconstrucción
con 68 tareas y falta de clave permanecen como registros históricos; este cierre
recoge las autorizaciones y resultados posteriores.
