# Integración de Juan Miguel

## Procedencia y alcance

Se trasladan archivos seleccionados de `documento a word/document-management` a este
repositorio, en `main`, por indicación expresa de Juan Miguel. El origen es
[documento_word, commit a0b7dd3](https://github.com/Juan-Miguel-Her-Del/documento_word/tree/a0b7dd315ebad9cbf4decf0fddcc7968d49d655b). La base de destino es
[9644422](https://github.com/fuertes155/handtext-ai-trabajo-equipo/commit/96444229fde96ef7b50c51ccdbfc976d10ebe0cf),
que ya incorpora la implementación de Samuel. El historial de ambos repositorios se
conserva; reutilizar esos archivos no acredita autoría original sobre ellos.

La comparación de archivos versionados muestra que la mayor parte de los módulos
asignados a Juan ya está en la base. Se agregan las pruebas faltantes de imágenes,
Google simulado, posiciones dudosas, cuentas, borradores, cámara, recorte/compartir,
páginas, ajustes y nombres. También se integran la medición OCR, la preparación SQL,
el generador y los recursos del ícono adaptable/monocromático y las guías de uso.

Las suites reutilizadas de ajustes, páginas y recorte incluyen escenarios compartidos
con otras tareas; se conservan como suites completas y se declara su procedencia.
No se atribuye a Juan la implementación previa de Samuel ni las tareas de Luis.

Se amplían las exclusiones Python conservando las de secretos. La herramienta OCR se
adapta para que SC-010 quede pendiente con menos de diez hojas. `flutter pub get` ajusta
cinco dependencias transitivas fijadas por el SDK local Flutter 3.41.6; se registra el
lockfile resultante, sin actualizar los plugins ni los manifiestos de dependencias.

Se conservan cuentas locales con Argon2id, el token de documentos optativo solo en
depuración, la API local en 8001 y la carga asíncrona del historial de Samuel. No se
trasladan el despliegue Render, configuraciones privadas ni requisitos antiguos de
registro remoto. Tampoco se importan los registros históricos de pruebas como si se
hubieran ejecutado en este checkout.

## Relación con las 73 tareas

Las 73 issues de Juan se consultaron con su cuenta y estaban abiertas al preparar esta
integración. La tabla describe el código y la evidencia, no el cierre de las issues.
Se mantienen abiertas para la revisión de otro integrante y la validación real que
exigen sus criterios. La publicación directa en main fue solicitada por Juan.

| Tarea | Situación en esta integración | Evidencia o pendiente |
| --- | --- | --- |
| [T004](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/4) | Integración nueva (implementación o pruebas faltantes) | [.gitignore](../.gitignore) |
| [T008](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/8) | Presente en main de Samuel; conservado | [backend/app/schemas.py](../backend/app/schemas.py) |
| [T011](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/11) | Presente en main de Samuel; conservado | [backend/tests/test_errors_and_privacy.py](../backend/tests/test_errors_and_privacy.py) |
| [T017](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/17) | Integración nueva (implementación o pruebas faltantes) | [backend/tests/test_image_validation.py](../backend/tests/test_image_validation.py) |
| [T019](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/19) | Integración nueva (implementación o pruebas faltantes) | [backend/tests/test_google_vision_provider.py](../backend/tests/test_google_vision_provider.py) |
| [T024](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/24) | Integración nueva (implementación o pruebas faltantes) | [frontend/test/services/storage_test.dart](../frontend/test/services/storage_test.dart) |
| [T027](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/27) | Presente en main de Samuel; conservado | [backend/app/services/image_validation.py](../backend/app/services/image_validation.py) |
| [T029](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/29) | Presente en main de Samuel; conservado | [backend/app/services/ocr/base.py](../backend/app/services/ocr/base.py) |
| [T030](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/30) | Presente en main de Samuel; conservado | [backend/app/services/ocr/google_vision.py](../backend/app/services/ocr/google_vision.py) |
| [T033](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/33) | Presente en main de Samuel; conservado | [backend/app/services/documents/docx_builder.py](../backend/app/services/documents/docx_builder.py) |
| [T036](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/36) | Presente en main de Samuel; conservado | [frontend/lib/services/working_copy_service.dart](../frontend/lib/services/working_copy_service.dart) |
| [T039](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/39) | Presente en main de Samuel; conservado | [frontend/lib/services/file_save_service.dart](../frontend/lib/services/file_save_service.dart) |
| [T044](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/44) | Presente en main de Samuel; conservado | [frontend/lib/main.dart](../frontend/lib/main.dart) |
| [T047](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/47) | Integración nueva (implementación o pruebas faltantes) | [frontend/test/state/camera_flow_test.dart](../frontend/test/state/camera_flow_test.dart) |
| [T048](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/48) | Presente en main de Samuel; conservado | [frontend/android/app/src/main/AndroidManifest.xml](../frontend/android/app/src/main/AndroidManifest.xml) |
| [T053](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/53) | Guías y alcance actualizados | [Guías](../README.md#guías-por-funcionalidad) |
| [T056](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/56) | Pendiente o parcial | Verificación automatizada registrada; revisión del equipo pendiente. |
| [T058](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/58) | Integración nueva (implementación o pruebas faltantes) | [backend/tests/test_ocr_quality.py](../backend/tests/test_ocr_quality.py) |
| [T059](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/59) | Integración nueva (implementación o pruebas faltantes) | [backend/tools/measure_ocr_quality.py](../backend/tools/measure_ocr_quality.py) |
| [T061](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/61) | Pendiente o parcial | Pendiente: clave y corpus de diez hojas autorizadas; no se ejecutó OCR real. |
| [T102](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/63) | Presente en main de Samuel; conservado | [frontend/pubspec.yaml](../frontend/pubspec.yaml) |
| [T103](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/64) | Integración nueva (implementación o pruebas faltantes) | [db/setup_local_database.sql](../db/setup_local_database.sql) |
| [T107](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/68) | Presente en main de Samuel; conservado | [backend/app/persistence/postgres_store.py](../backend/app/persistence/postgres_store.py) |
| [T112](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/73) | Integración nueva (implementación o pruebas faltantes) | [backend/tests/test_account_service.py](../backend/tests/test_account_service.py) |
| [T113](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/74) | Presente en main de Samuel; conservado | [backend/tests/test_auth_api.py](../backend/tests/test_auth_api.py) |
| [T116](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/77) | Presente en main de Samuel; conservado | [backend/app/services/accounts/account_service.py](../backend/app/services/accounts/account_service.py) |
| [T120](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/81) | Presente en main de Samuel; conservado | [frontend/lib/models/user_account.dart](../frontend/lib/models/user_account.dart) |
| [T122](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/83) | Presente en main de Samuel; conservado | [frontend/lib/services/local_auth_api.dart](../frontend/lib/services/local_auth_api.dart); se mantiene el contrato remoto sin usarlo para el ingreso local. |
| [T127](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/88) | Presente en main de Samuel; conservado | [frontend/lib/presentation/screens/app_root.dart](../frontend/lib/presentation/screens/app_root.dart) |
| [T131](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/92) | Presente en main de Samuel; conservado | [frontend/lib/services/draft_storage.dart](../frontend/lib/services/draft_storage.dart) |
| [T136](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/97) | Guías y alcance actualizados | [Guías](../README.md#guías-por-funcionalidad) |
| [T138](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/99) | Pendiente o parcial | Pendiente: recorrido en Android con API y PostgreSQL; pruebas automatizadas documentadas. |
| [T141](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/102) | Presente en main de Samuel; conservado | [frontend/lib/presentation/widgets/surface_card.dart](../frontend/lib/presentation/widgets/surface_card.dart) |
| [T145](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/106) | Pendiente o parcial | Guías y verificación automatizada; recorrido Android y revisión del equipo pendientes. |
| [T146](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/107) | Integración nueva (implementación o pruebas faltantes) | [frontend/tool/generate_launcher_icon.py](../frontend/tool/generate_launcher_icon.py) |
| [T202](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/109) | Integración nueva (implementación o pruebas faltantes) | [backend/tests/test_uncertain_words.py](../backend/tests/test_uncertain_words.py) |
| [T204](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/111) | Presente en main de Samuel; conservado | [backend/app/services/ocr/uncertain_words.py](../backend/app/services/ocr/uncertain_words.py) |
| [T207](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/114) | Presente en main de Samuel; conservado | [frontend/lib/services/uncertain_ranges.dart](../frontend/lib/services/uncertain_ranges.dart) |
| [T208](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/115) | Integración nueva (implementación o pruebas faltantes) | [frontend/test/services/storage_test.dart](../frontend/test/services/storage_test.dart) |
| [T212](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/119) | Integración nueva (implementación o pruebas faltantes) | [frontend/test/state/extras_flow_test.dart](../frontend/test/state/extras_flow_test.dart) |
| [T215](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/122) | Integración nueva (implementación o pruebas faltantes) | [frontend/test/state/extras_flow_test.dart](../frontend/test/state/extras_flow_test.dart) |
| [T219](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/126) | Pendiente o parcial | Pruebas de recorte/compartir verificadas; recorrido Android y revisión pendientes. |
| [T302](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/128) | Presente en main de Samuel; conservado | [frontend/lib/services/page_join.dart](../frontend/lib/services/page_join.dart) |
| [T306](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/132) | Presente en main de Samuel; conservado | [frontend/lib/state/document_flow_controller.dart](../frontend/lib/state/document_flow_controller.dart) |
| [T308](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/134) | Integración nueva (implementación o pruebas faltantes) | [frontend/test/state/pages_flow_test.dart](../frontend/test/state/pages_flow_test.dart) |
| [T310](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/136) | Integración nueva (implementación o pruebas faltantes) | [frontend/test/state/pages_flow_test.dart](../frontend/test/state/pages_flow_test.dart) |
| [T311](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/137) | Guías y alcance actualizados | [Guías](../README.md#guías-por-funcionalidad) |
| [T403](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/141) | Presente en main de Samuel; conservado | [frontend/lib/app.dart](../frontend/lib/app.dart) |
| [T410](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/148) | Pendiente o parcial | Exclusiones comprobadas; no hay clave de distribución ni key.properties en este checkout. |
| [T413](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/151) | Pendiente o parcial | Pruebas y análisis registrados; recorrido Android pendiente. |
| [T501](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/152) | Integración nueva (implementación o pruebas faltantes) | [frontend/test/state/settings_test.dart](../frontend/test/state/settings_test.dart) |
| [T502](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/153) | Presente en main de Samuel; conservado | [frontend/lib/models/app_settings.dart](../frontend/lib/models/app_settings.dart) |
| [T509](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/160) | Presente en main de Samuel; conservado | [frontend/test/presentation/accessibility_test.dart](../frontend/test/presentation/accessibility_test.dart) |
| [T510](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/161) | Presente en main de Samuel; conservado | [frontend/test/presentation/accessibility_test.dart](../frontend/test/presentation/accessibility_test.dart) |
| [T514](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/165) | Pendiente o parcial | Pruebas a 100 %/200 % verificadas; TalkBack real pendiente. |
| [T602](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/167) | Presente en main de Samuel; conservado | [frontend/lib/models/history_entry.dart](../frontend/lib/models/history_entry.dart) |
| [T603](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/168) | Presente en main de Samuel; conservado | [frontend/lib/state/document_history.dart](../frontend/lib/state/document_history.dart) |
| [T608](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/173) | Presente en main de Samuel; conservado | [frontend/test/state/history_flow_test.dart](../frontend/test/state/history_flow_test.dart) |
| [T609](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/174) | Presente en main de Samuel; conservado | [frontend/lib/state/document_flow_controller.dart](../frontend/lib/state/document_flow_controller.dart) |
| [T701](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/179) | Presente en main de Samuel; conservado | [frontend/lib/presentation/strings.dart](../frontend/lib/presentation/strings.dart) |
| [T703](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/181) | Integración nueva (implementación o pruebas faltantes) | [frontend/test/state/settings_test.dart](../frontend/test/state/settings_test.dart) |
| [T706](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/184) | Presente en main de Samuel; conservado | [frontend/lib/presentation/widgets/language_sheet.dart](../frontend/lib/presentation/widgets/language_sheet.dart) |
| [T707](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/185) | Presente en main de Samuel; conservado | [frontend/lib/presentation/strings_en.dart](../frontend/lib/presentation/strings_en.dart) |
| [T710](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/188) | Guías y alcance actualizados | [Guías](../README.md#guías-por-funcionalidad) |
| [T801](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/190) | Presente en main de Samuel; conservado | [frontend/pubspec.yaml](../frontend/pubspec.yaml) |
| [T802](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/191) | Presente en main de Samuel; conservado | [frontend/test/state/scanner_flow_test.dart](../frontend/test/state/scanner_flow_test.dart) |
| [T805](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/194) | Presente en main de Samuel; conservado | [frontend/test/state/scanner_flow_test.dart](../frontend/test/state/scanner_flow_test.dart) |
| [T808](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/197) | Guías y alcance actualizados | [Guías](../README.md#guías-por-funcionalidad) |
| [T901](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/199) | Integración nueva (implementación o pruebas faltantes) | [frontend/test/services/file_name_test.dart](../frontend/test/services/file_name_test.dart) |
| [T905](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/203) | Presente en main de Samuel; conservado | [frontend/lib/models/history_entry.dart](../frontend/lib/models/history_entry.dart) |
| [T907](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/205) | Guías y alcance actualizados | [Guías](../README.md#guías-por-funcionalidad) |
| [T1002](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/208) | Integración nueva (implementación o pruebas faltantes) | [frontend/test/state/settings_test.dart](../frontend/test/state/settings_test.dart) |
| [T1007](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/213) | Guías y alcance actualizados | [Guías](../README.md#guías-por-funcionalidad) |

## Verificación de esta integración

Entorno observado: Windows, Python 3.12.6, Flutter 3.41.6 y Dart 3.11.4.
Backend instalado con las versiones exactas de `requirements-dev.txt` en `.venv`
aislado, sin modificar los paquetes globales.

| Verificación | Resultado observado |
| --- | --- |
| `python -m ruff check .` desde backend | Correcto |
| `python -m ruff format --check .` desde backend | 50 archivos ya formateados |
| `python -m pytest -q -ra --tb=short --basetemp <ruta-nueva-en-.venv>` | 160 pruebas aprobadas, incluido PostgreSQL temporal; 21,41 s |
| `python -m tools.measure_ocr_quality --help` | Correcto, sin envío a Google |
| Formato de las seis suites Dart incorporadas | Correcto, cero cambios |
| `flutter test --no-pub --reporter expanded` | 285 pruebas aprobadas; incluye accesibilidad al 100 % y 200 % |
| `flutter analyze --no-pub` | Seis avisos informativos preexistentes de deprecación; sin errores ni advertencias |
| `flutter build apk --debug --target-platform android-x64 --no-pub` | Correcto: `frontend/build/app/outputs/flutter-apk/app-debug.apk` (73 820 171 bytes) |

La primera ejecución del backend encontró permisos denegados en la carpeta temporal
predeterminada de Windows (148 aprobadas, diez errores de preparación). Se repitió con
una ruta nueva dentro de `.venv`: las 158 pruebas pasaron. Tras añadir dos casos para
impedir el falso cumplimiento de SC-010 con menos de diez hojas, pasaron las 160.
No se cambió el código de persistencia para eludir esas pruebas.

Los seis avisos del analizador corresponden a `SemanticsService.announce` y
`containsSemantics` en archivos de interfaz/pruebas ya existentes en la base. Se
conservan para evitar mezclar una migración de APIs Flutter con este traslado.
Los plugins Android también muestran avisos de compatibilidad Java 8 durante la
compilación, que finalizó correctamente.

El APK de depuración es un artefacto local ignorado por Git y no se añade al commit.
No había dispositivo Android conectado al revisar `adb devices`. Siguen pendientes el
recorrido manual en emulador/teléfono, TalkBack real, el diálogo nativo de guardar, el
escáner real y biometría. No se ejecutó OCR real ni la medición T061: no se proporcionó
un corpus autorizado de diez hojas. Tampoco se generó ni validó firma de distribución.

La preparación SQL se incorpora y se revisa; no se ejecuta sobre la instalación
personal. Las pruebas de migraciones y consultas se verificaron en PostgreSQL temporal.
El corpus OCR, las claves y los archivos temporales permanecen fuera de Git. Las
exclusiones de `.venv`, cachés Python, credenciales, keystores y `key.properties` se
comprueban antes del commit; las issues siguen abiertas para revisión del equipo.
