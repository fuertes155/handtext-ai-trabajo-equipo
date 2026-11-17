# Reconstrucción de Luis — resultados actuales

Fecha: 2026-11-17. Rama: `entrega/railway-documentacion-20261116`.
Base inspeccionada y remota: `18f5fde24a8014bece01cdc82d6b29cea56f2756`.
Repositorio local: `/home/luisdaca/Escritorio/handtext-ai-trabajo-equipo`.

## Inspección y alcance

La copia se descargó en el Escritorio por indicación de Luis. No existían cambios
locales ni archivos AGENTS.md aplicables. Las 72 issues obtenidas con
`gh issue list --assignee LUISDACA --state all --limit 150` coinciden exactamente
con `TAREAS/luis-miguel.md`: 20/21/17/14 por sprint, abiertas y asignadas a LUISDACA.
PR #221 en borrador. Sin cambios posteriores al reinicio en el remoto inspeccionado.

CLI: `gh auth status` y `gh api user --jq .login` confirman LUISDACA. El conector
GitHub usa otra cuenta y no se utiliza para publicar. Configuración exclusivamente
local: Luis Miguel David Campo, `134025037+LUISDACA@users.noreply.github.com`.
La dirección noreply se compone del ID 134025037 y login confirmados por la API de
GitHub; no se usa un correo personal inferido ni se modifica la configuración global.

Los índices originales de specs 001/002 conservan casillas históricas aprobadas,
pero para este reinicio prevalece el seguimiento 014. Todas las issues requieren
revisión de otro integrante del PR; la aprobación técnica no permite cerrarlas
antes de esa revisión. No se modifican asignaciones o estados ajenos.

## Lote 1: T002, T006, T010, T104, T108, T114

| Tarea | Implementación o revisión actual | Verificación |
| --- | --- | --- |
| T002 · #2 | Versiones fijadas conservadas, instaladas y compatibles con Python 3.12.16. Documentada incompatibilidad del wheel pgserver con 3.14. | Instalación completa y `pip check` sin conflictos. |
| T006 · #6 | Catálogo completo, handlers de dominio/esquema/HTTP/inesperados, request_id y desafío Bearer en 401. Registros sin mensaje de excepciones ni variables locales. | Catálogo completo, validación sin eco y suites de dominio. |
| T010 · #10 | OCR falso conserva texto y marcas, registra llamadas y simula fallos; imágenes sintéticas con EXIF, JPEG reproducible y PNG gigante sin asignación masiva. | Pruebas de utilidades, validación y preparación de imágenes. |
| T104 · #65 | Lee conexión opcional del entorno; secretos excluidos de repr, límites y duraciones compartidos conservados. Token local optativo con mínimo de 32 caracteres. | Configuración explícita, valores ausentes, rechazo de token corto y privacidad. |
| T108 · #69 | SQL ordenado, transacción con bloqueo de concurrencia, registro idempotente y CLI sin imprimir errores de conexión sensibles. | PostgreSQL temporal real, contrato del almacén, rollback de DDL y registro, reintento e idempotencia. |
| T114 · #75 | Argon2id con sal, verificación segura de hashes inválidos y hash ficticio; tokens aleatorios de 256 bits y SHA-256 solo para tokens. | Sal distinta, credenciales correctas/incorrectas, tokens distintos, servicio de cuentas y ausencia de contraseñas/tokens planos en PostgreSQL. |

Resultado: **87 passed in 1.40s**, sin skips. Ruff y formateador: correctos en los
siete archivos Python de este lote. No equivale a aprobación de toda la aplicación.
Los endpoints de documentos todavía conservan el bloqueo temporal T118.

Comandos desde `backend/`:

```bash
# Usar Python 3.12; el entorno de esta máquina se llama .venv312.
.venv312/bin/python -m pip install -r requirements-dev.txt
.venv312/bin/python -m pip check
.venv312/bin/ruff check app/config.py app/errors.py app/persistence/migrations.py app/services/accounts/passwords.py app/services/accounts/tokens.py tests/conftest.py tests/test_luis_foundations.py
.venv312/bin/ruff format --check app/config.py app/errors.py app/persistence/migrations.py app/services/accounts/passwords.py app/services/accounts/tokens.py tests/conftest.py tests/test_luis_foundations.py
.venv312/bin/pytest -q tests/test_luis_foundations.py tests/test_account_rules.py tests/test_account_service.py tests/test_user_store.py tests/test_image_validation.py tests/test_image_preparation.py
```

Las pruebas necesitan conexiones locales para TestClient y PostgreSQL; se ejecutaron
fuera del aislamiento de red. PostgreSQL lo crea y elimina pgserver en un directorio
temporal exclusivo. No se usa la conexión de producción ni se ejecuta su migración.

Procedencia: se implementaron los cuerpos pendientes contra los contratos y pruebas
conservados. Se consultó `098d4f6:backend/app/persistence/migrations.py` exclusivamente
para conservar el contrato existente `schema_migrations.version` y los identificadores
sin extensión. Esos nombres y el esquema son previos; no se atribuyen a Luis. No se
restauró masivamente código histórico. T002 revisa dependencias compartidas conservadas.

## Recursos y verificaciones todavía pendientes

Flutter 3.44.9 / Dart 3.12.2 y SDK Android disponibles; Java incluido en Android Studio.
`flutter pub get` correcto: cinco dependencias de SDK/pruebas se adaptaron al SDK
instalado en el lockfile. La comprobación offline previa falló por caché incompleta.
Backend: Python 3.12.16 descargado localmente, paquetes de desarrollo aislados.
El intento con Python 3.14 no admite pgserver 0.1.4; no se debilitaron las pruebas.

ADB no mostró dispositivos conectados. No se han realizado recorridos manuales,
configurado PIN/huella, instalado APK ni modificado datos de un teléfono. No se ha
generado APK actual ni verificado una firma de distribución. Producción intacta.

Tareas con alcance técnico verificado: 42/72; cierre formal: 0/72 por revisión pendiente.
Las otras 30 tareas requieren implementación/revisión y sus verificaciones actuales.

## Lote 2: T021, T032, T050, T051, T118, T205

- T032: reglas de texto vacío, límite de 200000 caracteres, normalización de saltos,
  párrafos y rechazo de caracteres no válidos en XML; lista acotada de códigos Unicode.
- T050: DejaVu Sans 2.37 copiada de `/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf`,
  conservando `LICENSE-DejaVu.txt`. SHA-256:
  `b4c632e3cdf9acc7f28758fb5a323c8524d7fc6660d46904d9b6cbe2809c419c`.
  Es un recurso de terceros, no una fuente creada por Luis.
- T051: PDF A4 en memoria, fuente incrustada, márgenes de 20 mm, letra de 12 pt,
  ajuste de líneas/páginas, tabulaciones y rechazo explícito de glifos ausentes.
- T021: suite nueva de Word que abre ZIP/XML y DOCX, comprueba texto, caracteres,
  párrafos vacíos, límite exacto, metadatos, controles inválidos, esquema y tamaño.
- T118: endpoints conectados a DocumentUser compartido; Bearer obligatorio salvo
  permiso local explícito. Se retiró pending_luis.py y las pruebas temporales ahora
  verifican 401 y ausencia de llamadas OCR. Permiso local rechazado tras proxy y
  en configuración Railway; nunca habilita operaciones de cuentas.
- T205: conversión de marcas a posiciones Unicode, descarte de intervalos inválidos,
  superpuestos o de puntuación sin cambiar el texto. Modelos compartidos conservados.

Resultado: **218 passed in 2.87s**, sin skips, en la suite completa backend. Incluye
PostgreSQL temporal, DOCX/PDF, privacidad de registros, autorización y proveedores
con transportes simulados. No se instala OCR local ni se llama a proveedores reales.
Ruff completo: correcto; formateador: 57 archivos correctos. Se corrigió el handler
de StoreUnavailableError para responder 503, descubierto por la suite compartida.

Comandos desde backend:

```bash
.venv312/bin/ruff check .
.venv312/bin/ruff format --check .
.venv312/bin/pytest -q
.venv312/bin/pytest --noconftest -q ../checks/test_reinicio_luis.py
```

Los checks finales verifican autenticación y mantienen el control de release
mientras falta T409. Se conserva el nombre del archivo para que siga siendo
localizable. La suite anterior de bloqueo temporal se sustituyó, no se debilitó.
No se consultó ni restauró implementación histórica en este lote; las funciones
se implementaron contra contratos actuales y pruebas compartidas.

## Lote 3: T012, T013, T022, T035, T110, T201

T012 implementa URL de API configurable, barra final y validación sin credenciales,
query ni fragmento. Las cuentas del servidor requieren HTTPS explícito. Límites
y tiempos siguen el contrato conservado. Tres ejecuciones de configuración verifican
HTTPS válido, URL ausente y HTTP rechazado, con cuentas del servidor; el token local
permanece vacío en ese modo aunque se suministre una definición sintética.

T035 valida tamaño, firma y dimensiones antes de procesar; traduce fallos a errores
seguros. La lectura de dimensiones usa ImageDescriptor sin decodificar píxeles y
libera descriptor/buffer en finally. T022 aporta pruebas nuevas de límites exactos,
cuatro límites inválidos, validaciones previas, imagen dañada y PNG sintético real.

T013/T110 revisan el aporte conservado T140 de Samuel: sin cambiar colores ni temas,
se comprueban claro/oscuro, Poppins, superficies, foco y botones de 52 dp. No se
atribuye ese diseño a Luis ni se acredita todavía un recorrido visual completo.

T201 fija image_cropper 12.2.1 y share_plus 12.0.2; restaura UCropActivity como
actividad privada, manteniendo copias de seguridad desactivadas. pub get correcto
y servicios de recorte/compartir pasan el analizador con el SDK instalado. El
lockfile registra los paquetes y la adaptación de cinco dependencias al SDK.
Las licencias de los paquetes se conservan en sus distribuciones; Poppins no cambia.

Verificación: **10 pruebas Flutter aprobadas** más **3 escenarios de configuración**
aprobados; analizador del alcance sin incidencias; formato correcto. Comprobación
XML de actividad única, privada y backup desactivado, correcta. No es la suite
Flutter completa ni una comprobación del selector nativo de Android.

Comandos desde frontend:

```bash
flutter pub get
flutter test --no-pub test/services/image_rules_test.dart test/services/app_config_test.dart test/theme/app_theme_test.dart
flutter test --no-pub --dart-define=HOSTED_ACCOUNTS=true --dart-define=API_BASE_URL=https://example.invalid/api --dart-define=LOCAL_DEV_API_TOKEN=synthetic-unused test/services/app_config_test.dart
flutter test --no-pub --dart-define=HOSTED_ACCOUNTS=true test/services/app_config_test.dart
flutter test --no-pub --dart-define=HOSTED_ACCOUNTS=true --dart-define=API_BASE_URL=http://example.invalid/ test/services/app_config_test.dart
flutter analyze --no-pub lib/config/app_config.dart lib/services/image_rules.dart lib/services/image_editor_service.dart lib/services/share_service.dart lib/theme test/services/image_rules_test.dart test/services/app_config_test.dart test/theme/app_theme_test.dart
dart format --output=none --set-exit-if-changed lib/config/app_config.dart lib/services/image_rules.dart lib/theme test/services/image_rules_test.dart test/services/app_config_test.dart test/theme/app_theme_test.dart
```

No se consultó implementación histórica en este lote. Los temas son los conservados
en 18f5fde; se revisan mediante pruebas nuevas. Firma, pantallas y suite general
continúan pendientes, igual que las verificaciones físicas.

## Lote 4: T038, T119, T124, T125, T206, T303

T038 envía imagen binaria y texto JSON, aplica límites de espera, traduce errores y
verifica la firma de archivos. Lee el Bearer actual en cada solicitud. El permiso
local solo sale en debug y hacia loopback/emulador, nunca a un servidor remoto.
Las marcas se convierten a UTF-16 y el texto válido se conserva. El cliente ofrece
close para liberar conexiones. Se conserva el traductor de errores compartido.

T124 valida nombre, correo, longitud, confirmación y consentimiento. T125 administra
lectura, inicio, cierre, eliminación y vencimiento de sesión; evita peticiones
duplicadas, conserva cache sin red y exige persistir antes de anunciar ingreso.
Un cambio de propietario al recuperar una sesión se rechaza. Fallos del almacén
no se registran ni se anuncian como persistencia correcta.

T119 sustituye suites retiradas de formularios/cliente, amplía la suite compartida
del controlador con duplicados, errores de almacenamiento y aislamiento de dueño.
T206 prueba conversión Unicode, validación, desplazamiento, borrado, pegado y
puntuación en las marcas. T303 solicita el límite nativo, usa selección individual
si queda una página y conserva resultados excedentes para que el controlador
compartido pueda informar y limpiar sus copias, en vez de ocultarlos. Su falso
registra llamadas y límites para las pruebas de varias páginas conservadas.

**60 pruebas aprobadas**, incluida la suite compartida de autenticación local
Argon2id. El único ajuste a LocalAuthApi cuenta puntos Unicode en los límites de
nombre/contraseña como el backend; la derivación, migración y almacenamiento
seguros de Samuel no se reescriben. No se consultó implementación histórica.
El análisis y formato del alcance son correctos. Datos sintéticos y HTTP simulado.

Comandos desde frontend:

```bash
flutter test --no-pub test/services/account_rules_test.dart test/services/uncertain_ranges_test.dart test/services/auth_api_client_test.dart test/services/handtext_api_client_test.dart test/services/image_source_service_test.dart test/services/local_auth_api_test.dart test/state/auth_controller_test.dart
flutter analyze --no-pub lib/services/handtext_api_client.dart lib/services/account_rules.dart lib/services/image_source_service.dart lib/services/local_auth_api.dart lib/state/auth_controller.dart test/services/account_rules_test.dart test/services/uncertain_ranges_test.dart test/services/auth_api_client_test.dart test/services/image_source_service_test.dart test/services/handtext_api_client_test.dart test/state/auth_controller_test.dart
dart format --output=none --set-exit-if-changed lib/services/handtext_api_client.dart lib/services/account_rules.dart lib/services/image_source_service.dart lib/services/local_auth_api.dart lib/state/auth_controller.dart test/services/account_rules_test.dart test/services/uncertain_ranges_test.dart test/services/auth_api_client_test.dart test/services/image_source_service_test.dart test/services/handtext_api_client_test.dart test/state/auth_controller_test.dart test/support/fakes.dart
```

Las pruebas Flutter también necesitan sockets locales; cuando el aislamiento los
rechaza se ejecutan fuera de él. No se prueba galería física ni persistencia real
del Android Keystore hasta contar con dispositivo. La revisión del equipo sigue
pendiente en todas las issues.

## Lote 5: T139, T401, T704, T1003, T1005, T1006

Persistencia de idioma/bloqueo con lectura compatible de archivos antiguos; MaterialApp
resuelve español, inglés y el idioma automático con español de respaldo. La elección
se verifica en el MaterialApp real mientras se comprueba una sesión simulada, sin
atribuir aprobación a las pantallas del flujo aún pendientes.

El bloqueo exige verificar y persistir antes de anunciar activación. Cancelar o
fallar mantiene el cierre. La vuelta tras más de 60 segundos bloquea; el caso exacto
de 60 segundos no. Se conserva el primer instante de salida entre inactive/hidden/
paused, y se evita lanzar verificaciones duplicadas. La desactivación persistida
impide volver a bloquear. El gate oculta documentos y foco/semántica, conservando
el árbol y el texto para el desbloqueo. El PIN y la huella los sigue verificando
Android mediante el adaptador compartido: en las pruebas se simula su resultado.

T401 aporta pruebas nuevas de JSON, todas las combinaciones de ajustes, archivo
privado temporal, escritura atómica, valores dañados y fallo de persistencia. T139
comprueba AA para texto (4.5:1), foco/iconos (3:1), estados y botones, conservando
la paleta de Samuel. El interruptor de bloqueo real se prueba al 100 % y 200 %.

**44 pruebas aprobadas**; análisis del alcance sin incidencias, formato correcto.
No se verifican PIN/huella reales, TalkBack físico ni pantallas completas. T404,
T126 y T142 incluyen solo dependencias necesarias para este lote (Ajustes, header,
splash, logo y tarjeta de acción); aún no se cuentan terminadas. No se restauró
código histórico. SurfaceCard compartida conserva su diseño y añade un Material
transparente: el SDK 3.44 detectó que ListTile no podía pintar sobre su DecoratedBox.
Se corrigió esa incompatibilidad sin quitar la comprobación ni cambiar la paleta.

Comandos desde frontend:

```bash
flutter test --no-pub test/state/settings_test.dart test/state/lock_controller_test.dart test/theme/aurora_contrast_test.dart test/presentation/settings_foundations_test.dart
flutter analyze --no-pub lib/app.dart lib/services/settings_store.dart lib/state/settings_controller.dart lib/state/app_lock_controller.dart lib/presentation/app_lock_scope.dart lib/presentation/screens/settings_screen.dart lib/presentation/screens/lock_screen.dart lib/presentation/screens/splash_screen.dart lib/presentation/widgets/aurora_header.dart lib/presentation/widgets/scanner_logo.dart lib/presentation/widgets/action_tile.dart lib/presentation/widgets/surface_card.dart test/state/settings_test.dart test/state/lock_controller_test.dart test/theme/aurora_contrast_test.dart test/presentation/settings_foundations_test.dart
dart format --output=none --set-exit-if-changed lib/app.dart lib/services/settings_store.dart lib/state/settings_controller.dart lib/state/app_lock_controller.dart lib/presentation/app_lock_scope.dart lib/presentation/screens/settings_screen.dart lib/presentation/screens/lock_screen.dart lib/presentation/screens/splash_screen.dart lib/presentation/widgets/aurora_header.dart lib/presentation/widgets/scanner_logo.dart lib/presentation/widgets/action_tile.dart lib/presentation/widgets/surface_card.dart test/state/settings_test.dart test/state/lock_controller_test.dart test/theme/aurora_contrast_test.dart test/presentation/settings_foundations_test.dart
```

Recursos inspeccionados: sin teléfono, sin AVD ni imagen de sistema instalada y sin
/dev/kvm; no se acredita recorrido en emulador. No existe directorio .handtext con
clave de firma en esta máquina. Java disponible en Android Studio es versión 25;
la compatibilidad de herramientas para APK se resolverá al llegar a la compilación.
GitHub confirma que el commit 6a0cb1b se asocia a la cuenta LUISDACA y su noreply.

## Lote 6: T042, T126, T130, T142, T507, T511

Pantallas de bienvenida, ingreso y registro con validación, consentimiento, datos
del modo local/servidor, errores seguros y prevención de duplicados. Los campos
de contraseña van ocultos, sin autocorrección/sugerencias y con guía de longitud.
Se conserva el almacenamiento y la API compartidos. Los errores no revelan si el
correo existe. No se acredita aún el flujo completo de documentos.

Los diálogos de autorización/confirmación solo devuelven aceptación al pulsar
expresamente su botón; cancelar o cerrar rechaza. El envío menciona el número de
imágenes. StatusBanner presenta texto, icono, estado, acción y región viva. La
ruta histórica de T042 menciona status_message.dart, pero el contrato actual usa
status_banner.dart/StatusBanner: se conserva ese nombre, sin crear un alias vacío.

Menú de cuenta con confirmación de texto pendiente al cerrar, y contraseña al
eliminar. La cancelación conserva sesión/documento. Eliminar correctamente limpia
sesión, borrador e historial propios. El avatar mide 48 dp y su inicial no entra en
la semántica ni absorbe el encabezado vecino; el diálogo se desplaza al 200 %.
Logo, escaneo y componentes usan la paleta conservada y detienen los bucles al
pedir menos animaciones. T134 se implementa como dependencia de T142 y se mantiene
pendiente de verificación integrada en la vista previa. No se consultó código histórico.

Integración T125: si ya se borró la cuenta en el servicio y falla la limpieza local,
se retorna fallo y se cierra la sesión ficticia, sin anunciar eliminación completa.
Una regresión verifica sesión vacía, aviso no exitoso y fallo seguro; la bienvenida
muestra el fallo. También se normaliza un detalle de formato del test de bloqueo.

Verificación: **25 pruebas** de widgets/controlador de sesión y **8 escenarios
compartidos** de bienvenida, privacidad local/servidor, consentimiento, confirmación
y error de ingreso. Análisis del alcance sin incidencias; formato correcto.
No se reemplazan ni debilitan las suites compartidas pendientes. Las nuevas pruebas
usan isSemantics, equivalente actual de containsSemantics, con las mismas condiciones.

Comandos desde frontend:

```bash
flutter test --no-pub test/presentation/account_widgets_test.dart test/state/auth_controller_test.dart
flutter test --no-pub test/presentation/auth_screens_test.dart --name 'sin sesión se muestra|datos incorrectos muestran|sin la autorización de datos|contraseñas deben coincidir|registro y privacidad coinciden'
flutter analyze --no-pub test/presentation/account_widgets_test.dart lib/presentation/widgets/account_menu.dart lib/presentation/widgets/scan_overlay.dart lib/presentation/widgets/confirm_dialog.dart lib/presentation/widgets/consent_dialog.dart lib/presentation/widgets/status_banner.dart lib/presentation/widgets/password_field.dart lib/presentation/screens/auth lib/state/auth_controller.dart test/state/auth_controller_test.dart
dart format --output=none --set-exit-if-changed lib/presentation/screens/auth lib/presentation/widgets/account_menu.dart lib/presentation/widgets/confirm_dialog.dart lib/presentation/widgets/consent_dialog.dart lib/presentation/widgets/password_field.dart lib/presentation/widgets/scan_overlay.dart lib/presentation/widgets/status_banner.dart lib/state/auth_controller.dart test/state/auth_controller_test.dart test/state/lock_controller_test.dart test/presentation/account_widgets_test.dart
```

## Lote 7: T043, T210, T213, T216, T512, T902

Inicio, vista previa y editor conectados al controlador compartido; botón atrás y
persistencia al pasar a segundo plano conservados. Se pide autorización en cada
envío, se desactivan acciones duplicadas, el editor conserva la última corrección
y la exportación usa Word/PDF. La preview muestra páginas, controles, recorte,
original y estados sin tocar la imagen original. Los fallos/cancelaciones conservan
el texto y la imagen anterior; las copias fallidas se limpian.

ReviewTextController pinta fondo y subrayado ondulado sin cambiar el texto y
respeta la composición IME. Siguiente selecciona y anuncia la palabra; aceptar
quita la marca. La exportación nunca contiene las marcas. Compartir usa exactamente
los bytes, nombre y formato guardados, y no aparece al cancelar el guardado.

Los avisos/revisión del editor se desplazan dentro del 45 % disponible; el texto
conserva más de 150 dp al 200 % y Exportar sigue visible. El encabezado limita su
escalado a 150 % y omite el subtítulo por encima de 130 %, según R5 de 006. La hoja
de formatos se desplaza y el teclado se retira al abrirla. PrimaryButton compartido
conserva colores y mínimo de 54 dp; puede crecer y envolver texto, sin elipsis que
cortara etiquetas al 200 %. Cuenta ahora tiene un límite semántico propio: la
suite compartida detectó que absorbía el saludo; se corrigió el código sin debilitar
la expectativa. Se amplió la regresión aislada con saludo y encabezado vecinos.

El nombre del archivo usa el título limpio y hasta 60 puntos Unicode, sin partir
emojis. Caracteres prohibidos, espacios/puntos finales y respaldo con fecha se
comprueban. Modelo/controlador T905 de Juan se conserva.

**38 pruebas aprobadas**: flujo, extras, nombres, componentes de cuenta y recorrido
automático de accesibilidad al 100/200 %. Análisis y formato del alcance correctos.
Se incluyen dependencias T505 (selector de consejos), T803/T806 (conexión/fallo del
escáner) y T903 (acción de copiar); se mantienen sin contar hasta revisar sus
criterios y ejecutar sus suites propias. No se acredita OCR, compartir, recorte o
TalkBack físicos. No se consultó implementación histórica.

Comandos desde frontend:

```bash
flutter test --no-pub test/presentation/accessibility_test.dart test/presentation/extras_screens_test.dart test/presentation/flow_screen_test.dart test/services/file_name_test.dart test/presentation/account_widgets_test.dart
flutter analyze --no-pub lib/presentation/screens/editor_screen.dart lib/presentation/screens/flow_screen.dart lib/presentation/screens/start_screen.dart lib/presentation/screens/preview_screen.dart lib/presentation/screens/app_root.dart lib/presentation/widgets/review_text_controller.dart lib/presentation/widgets/export_format_sheet.dart lib/presentation/widgets/primary_button.dart lib/state/document_flow_controller.dart test/presentation/extras_screens_test.dart test/services/file_name_test.dart
dart format --output=none --set-exit-if-changed lib/presentation/screens/app_root.dart lib/presentation/screens/editor_screen.dart lib/presentation/screens/flow_screen.dart lib/presentation/screens/preview_screen.dart lib/presentation/screens/start_screen.dart lib/presentation/widgets/export_format_sheet.dart lib/presentation/widgets/review_text_controller.dart lib/presentation/widgets/primary_button.dart lib/presentation/widgets/account_menu.dart lib/state/document_flow_controller.dart test/presentation/extras_screens_test.dart test/services/file_name_test.dart test/presentation/account_widgets_test.dart
```

## Lote 8: T025, T026, T045, T128, T134, T305

58 pruebas aprobadas: controlador, permisos/captura, pantallas de flujo y cuentas,
y varias páginas. Análisis y formato del alcance correctos.

Las nuevas suites comprueban consentimiento por envío, duplicados, borrador y su
orden de escritura/borrado, exportación vigente, fallos y cancelaciones. Captura
comprueba permiso denegado/permanente, repetición, cancelación y copia inválida;
no se modifica el original. Se conserva y revisa la suite compartida de varias
páginas: orden, máximo 10, limpieza, reintento sin reenviar páginas y marcas.
T134 se verifica en la vista previa: visible durante OCR y retirada al terminar;
las pruebas previas ya cubren menos animaciones. Las suites compartidas no se
reescriben. La de cuentas detectó dos avisos de sesión vencida: LoginScreen evita
repetir el mismo fallo, manteniendo el aviso de recuperación y los otros errores.
No se debilitaron expectativas ni se consultó implementación histórica.

Comandos desde frontend:

```bash
flutter test --no-pub --reporter expanded test/state/document_flow_controller_test.dart test/state/camera_flow_test.dart test/presentation/flow_screen_test.dart test/presentation/auth_screens_test.dart test/state/pages_flow_test.dart
flutter analyze --no-pub test/state/document_flow_controller_test.dart test/state/camera_flow_test.dart test/presentation/flow_screen_test.dart lib/presentation/screens/auth/login_screen.dart
dart format --output=none --set-exit-if-changed test/state/document_flow_controller_test.dart test/state/camera_flow_test.dart test/presentation/flow_screen_test.dart lib/presentation/screens/auth/login_screen.dart
```

Son pruebas con fakes/datos sintéticos; cámara y TalkBack físicos pendientes.
Las issues permanecen abiertas por la revisión del equipo exigida en sus criterios.

