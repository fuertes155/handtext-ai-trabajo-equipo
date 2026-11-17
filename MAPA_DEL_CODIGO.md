# Mapa del código

> **Mapa actual · reconstrucción 2026-11-17.** Consulte [comandos y recursos](docs/QUICKSTART_RECONSTRUCCION_LUIS.md) e [informe por lote](docs/VERIFICACION_RECONSTRUCCION_LUIS.md). Las secciones de integración posteriores conservan la procedencia histórica; no acreditan autoría nueva ni pruebas del código actual.

| Componente | Responsabilidad |
| --- | --- |
| `frontend/lib/main.dart` | Conecta cuentas locales o servidor según HOSTED_ACCOUNTS, ajustes y documentos. |
| `frontend/lib/services/local_auth_api.dart` | Guarda cuentas de forma segura y deriva contraseñas con Argon2id. |
| `frontend/lib/state/document_flow_controller.dart` | Coordina imágenes, reconocimiento, edición y exportación. |
| `frontend/lib/presentation/screens/` | Presenta bienvenida, editor, ajustes, privacidad, consejos e historial. |
| `frontend/lib/presentation/strings_es.dart` y `strings_en.dart` | Textos localizados. |
| `frontend/lib/state/settings_controller.dart` | Aplica el tema, tamaño de letra e idioma y guarda las preferencias. |
| `backend/app/main.py` y `backend/app/api/` | Crean FastAPI, asignan identificadores y aplican la autorización de rutas. |
| `backend/app/services/ocr/` y `documents/` | Reconocimiento y generación DOCX/PDF. |
| `backend/tests/` y `frontend/test/` | Pruebas de contrato, servicios y pantalla. |

La distribución usa AuthApiClient/POSTgreSQL y sesión Bearer; el desarrollo local
conserva LocalAuthApi/Argon2id de Samuel. Borrador e historial se guardan por ID en el
teléfono en ambos modos. El token optativo de desarrollo se limita a documentos y
bucle local; queda vacío por defecto y se rechaza en distribución.

| Archivo actual | Decisión y verificación |
| --- | --- |
| `backend/app/errors.py` | Catálogo, request_id y manejadores sin revelar trazas. |
| `backend/app/persistence/migrations.py` | Migración transaccional e idempotente; conserva schema_migrations.version. |
| `backend/app/services/accounts/passwords.py` | Argon2id con salt y tokens aleatorios; contraseñas nunca se guardan en claro. |
| `backend/app/api/dependencies.py` | Sesión real para documentos; desarrollo no autoriza cuentas. |
| `backend/app/services/documents/` | Validación de texto y DOCX/PDF; DejaVu con licencia/procedencia. |
| `backend/tools/serve_contract_test.py` | API en bucle local con PostgreSQL temporal, sin credenciales ni OCR externo. |
| `frontend/lib/state/auth_controller.dart` | Persistencia/reanudación, cierre y eliminación; errores seguros. |
| `frontend/lib/presentation/screens/` | Flujo, revisión, consejos, ajustes, idioma, historial y bloqueo. |
| `frontend/lib/state/app_lock_controller.dart` | Bloqueo tras más de 60 s, cancelación cerrada y persistencia tras verificar. |
| `frontend/android/app/build.gradle.kts` | Política release definitiva: HTTPS, cuentas servidor, clave propia válida; rechaza debug y modo local. |
| `checks/test_release_policy.py` | Ejecuta Gradle con claves sintéticas; no fabrica una entrega. |

Los temas/paleta T140 de Samuel y modelo/controlador T905 de Juan se mantienen;
las nuevas pruebas amplían sus contratos. No se restauró masivamente 098d4f6.


## Archivos integrados por Juan Miguel

La procedencia, las tareas y los resultados están en el
[informe de integración](docs/INTEGRACION_JUAN_MIGUEL.md).

| Parte | Implementación | Pruebas |
| --- | --- | --- |
| Calidad OCR (CER, WER y marcas) | `backend/tools/measure_ocr_quality.py` | `backend/tests/test_ocr_quality.py` |
| Imágenes y proveedor Google | `backend/app/services/image_validation.py`, `backend/app/services/ocr/` | `test_image_validation.py`, `test_google_vision_provider.py`, `test_uncertain_words.py` en `backend/tests/` |
| Servicio de cuentas de servidor | `backend/app/services/accounts/account_service.py` | `backend/tests/test_account_service.py` |
| PostgreSQL opcional | `db/setup_local_database.sql`, `db/migrations/` | `backend/tests/test_user_store.py` |
| Borradores y copias | `frontend/lib/services/draft_storage.dart`, `working_copy_service.dart` | `frontend/test/services/storage_test.dart` |
| Cámara, recorte, compartir y páginas | `frontend/lib/state/document_flow_controller.dart` | `camera_flow_test.dart`, `extras_flow_test.dart`, `pages_flow_test.dart` en `frontend/test/state/` |
| Ajustes, idioma, consejos y bloqueo | `frontend/lib/state/settings_controller.dart` | `frontend/test/state/settings_test.dart` y pruebas de pantallas existentes |
| Nombre de la exportación | `suggestedFileName` en `document_flow_controller.dart` | `frontend/test/services/file_name_test.dart` |
| Ícono Android | `frontend/tool/generate_launcher_icon.py`, `frontend/android/app/src/main/res/mipmap-*/` | Generación con Pillow y compilación Android |


## Integración restante de documento_word

Véase el [inventario completo](docs/INTEGRACION_COMPLETA_MANIFIESTO.json) y el
[informe de integración](docs/INTEGRACION_COMPLETA_DOCUMENTO_WORD.md). Incluye las siete
suites Flutter restantes, el contrato HTTP con PostgreSQL real, las pruebas completas de
preparación de imágenes, privacidad Android y configuración local de firma y URL release.

## Historial actual revisado en la reconstrucción (2026-11-17)

- `frontend/lib/models/history_entry.dart`: modelo/búsqueda T905 de Juan, conservado.
- `frontend/lib/state/document_history.dart`: registro/renombrado T905 conservado;
  máximo 50 y persistencia sin duplicados. La interfaz T906 usa estos contratos.
- `frontend/lib/presentation/screens/history_screen.dart`: búsqueda, renombrar,
  abrir y confirmaciones para eliminar. `history_screen_test.dart` prueba cambio de
  cuenta, cancelaciones y guías de accesibilidad 100/200 %.
- `frontend/lib/services/history_store.dart`: archivo por ID, sin imágenes ni archivos
  exportados; probado con almacenamiento temporal aislado.
- `frontend/lib/presentation/screens/editor_screen.dart`: Copiar todo y exportar el
  texto vigente. `organize_test.dart` verifica portapapeles, búsqueda y renombrado.

La privacidad de Historial y portapapeles en `strings_es.dart`/`strings_en.dart`
se conserva y revisa; refleja los modos local y servidor según la compilación.
[Resultados actuales](docs/VERIFICACION_RECONSTRUCCION_LUIS.md); revisión formal y
pruebas nativas físicas pendientes.

## Requisitos asignados a Luis → código → evidencia actual

El requisito completo es el de su issue y especificación original; el título
se conserva en TAREAS/luis-miguel.md. La evidencia por lote incluye comandos y
archivos; revisión formal pendiente en todos los casos.

| Tarea / requisito | Archivo o alcance principal | Evidencia actual |
| --- | --- | --- |
| [T002](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/2) | `backend/requirements.txt`, `backend/requirements-dev.txt` | Lote 1 |
| [T006](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/6) | `backend/app/errors.py` | Lote 1 |
| [T010](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/10) | `backend/tests/conftest.py` | Lote 1 |
| [T012](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/12) | `frontend/lib/config/app_config.dart` | Lote 3 |
| [T013](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/13) | `frontend/lib/theme/app_theme.dart` | Lote 3 |
| [T016](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/16) | `frontend/android/app/src/main/AndroidManifest.xml`, `frontend/android/app/src/main/res/xml/data_extraction_rules.xml`, `frontend/android/app/src/debug/AndroidManifest.xml` | Lote 11 |
| [T021](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/21) | `backend/tests/test_exports_docx.py` | Lote 2 |
| [T022](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/22) | `frontend/test/services/image_rules_test.dart` | Lote 3 |
| [T025](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/25) | `frontend/test/state/document_flow_controller_test.dart` | Lote 8 |
| [T026](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/26) | `frontend/test/presentation/flow_screen_test.dart` | Lote 8 |
| [T032](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/32) | `backend/app/services/documents/text_rules.py` | Lote 2 |
| [T035](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/35) | `frontend/lib/services/image_rules.dart` | Lote 3 |
| [T038](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/38) | `frontend/lib/services/handtext_api_client.dart` | Lote 4 |
| [T042](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/42) | `frontend/lib/presentation/widgets/` | Lote 6 |
| [T043](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/43) | `frontend/lib/presentation/screens/` | Lote 7 |
| [T045](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/45) | `frontend/test/state/camera_flow_test.dart` | Lote 8 |
| [T050](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/50) | `backend/app/assets/fonts/` | Lote 2 |
| [T051](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/51) | `backend/app/services/documents/pdf_builder.py` | Lote 2 |
| [T054](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/54) | Mapa de requisitos → código → pruebas en MAPA_DEL_CODIGO.md | Lote 11 |
| [T057](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/57) | Compilar el APK de depuración con flutter build apk --debug en frontend/ | Lote 11 |
| [T104](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/65) | `backend/app/config.py` | Lote 1 |
| [T108](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/69) | `backend/app/persistence/migrations.py` | Lote 1 |
| [T110](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/71) | `frontend/lib/theme/aurora.dart`, `frontend/lib/theme/app_theme.dart` | Lote 3 |
| [T114](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/75) | `backend/app/services/accounts/passwords.py`, `backend/app/services/accounts/tokens.py` | Lote 1 |
| [T118](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/79) | `backend/app/api/recognitions.py`, `backend/app/api/exports.py` | Lote 2 |
| [T119](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/80) | `frontend/test/services/auth_api_client_test.dart`, `frontend/test/services/account_rules_test.dart`, `frontend/test/state/auth_controller_test.dart` | Lote 4 |
| [T124](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/85) | `frontend/lib/services/account_rules.dart` | Lote 4 |
| [T125](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/86) | `frontend/lib/state/auth_controller.dart` | Lote 4 |
| [T126](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/87) | `frontend/lib/presentation/screens/auth/` | Lote 6 |
| [T128](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/89) | `frontend/test/presentation/auth_screens_test.dart` | Lote 8 |
| [T130](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/91) | `frontend/lib/presentation/widgets/account_menu.dart` | Lote 6 |
| [T134](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/95) | `frontend/lib/presentation/widgets/scan_overlay.dart` | Lote 8 |
| [T137](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/98) | Formateadores, analizadores y todas las pruebas; registro de verificación al final de este archivo | Lote 11 |
| [T139](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/100) | `frontend/test/theme/aurora_contrast_test.dart` | Lote 5 |
| [T142](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/103) | `frontend/lib/presentation/widgets/` | Lote 6 |
| [T201](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/108) | `frontend/pubspec.yaml`, `frontend/android/app/src/main/AndroidManifest.xml` | Lote 3 |
| [T205](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/112) | `backend/app/schemas.py`, `backend/app/api/recognitions.py`, `backend/tests/test_recognitions_api.py` | Lote 2 |
| [T206](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/113) | `frontend/test/services/uncertain_ranges_test.dart` | Lote 4 |
| [T210](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/117) | `frontend/lib/presentation/widgets/review_text_controller.dart`, `frontend/lib/presentation/screens/editor_screen.dart` | Lote 7 |
| [T213](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/120) | `frontend/lib/presentation/screens/preview_screen.dart` | Lote 7 |
| [T216](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/123) | Botón «Compartir» en el aviso de éxito del editor, con prueba de pantalla | Lote 7 |
| [T303](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/129) | `frontend/lib/services/image_source_service.dart` | Lote 4 |
| [T305](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/131) | `frontend/test/state/pages_flow_test.dart` | Lote 8 |
| [T312](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/138) | Formateadores, analizadores, todas las pruebas, APK y recorrido en el emulador; registro de verificación al final de este archivo | Verificación completa pendiente; consultar informe actual |
| [T401](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/139) | `frontend/test/state/settings_test.dart` | Lote 5 |
| [T404](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/142) | `frontend/lib/presentation/screens/settings_screen.dart` | Lote 9 |
| [T406](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/144) | Prueba de la versión contra pubspec.yaml y pruebas de pantalla de «Acerca de» | Lote 9 |
| [T409](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/147) | `frontend/android/app/build.gradle.kts` | Verificación completa pendiente; consultar informe actual |
| [T411](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/149) | Compilar la versión final por procesador, instalarla y medir el arranque (SC-504) | Verificación completa pendiente; consultar informe actual |
| [T503](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/154) | `frontend/test/presentation/tips_screen_test.dart` | Lote 9 |
| [T505](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/156) | `frontend/lib/presentation/screens/app_root.dart` | Lote 9 |
| [T507](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/158) | `frontend/lib/presentation/widgets/account_menu.dart` | Lote 6 |
| [T511](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/162) | `frontend/lib/presentation/widgets/account_menu.dart` | Lote 6 |
| [T512](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/163) | `frontend/lib/presentation/screens/editor_screen.dart`, `frontend/lib/presentation/widgets/export_format_sheet.dart` | Lote 7 |
| [T604](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/169) | `frontend/test/state/history_flow_test.dart` | Lote 9 |
| [T606](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/171) | `frontend/test/presentation/history_screen_test.dart` | Lote 10 |
| [T610](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/175) | Pruebas de eliminar, borrar todo, cancelar y eliminar la cuenta | Lote 9 |
| [T612](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/177) | Privacidad («Historial»), quickstart.md, README.md y MAPA_DEL_CODIGO.md; guías de accesibilidad de 006 (nombres y 48 dp, al 100 % y al 200 %) en history_screen_test.dart | Lote 10 |
| [T704](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/182) | `frontend/lib/app.dart` | Lote 5 |
| [T708](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/186) | Recorrido de todas las pantallas en inglés al 100 % y al 200 % sin textos en español (SC-802, SC-805), fallos y títulos de servicios | Lote 11 |
| [T803](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/192) | `frontend/lib/state/document_flow_controller.dart`, `frontend/lib/main.dart` | Lote 10 |
| [T806](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/195) | scannerUnavailable y scannerFailed, StatusAction.takePhoto y el aviso con acción en el inicio | Lote 10 |
| [T902](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/200) | `frontend/lib/state/document_flow_controller.dart` | Lote 7 |
| [T903](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/201) | `frontend/lib/presentation/screens/editor_screen.dart`, `frontend/test/presentation/organize_test.dart` | Lote 10 |
| [T906](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/204) | `frontend/lib/presentation/screens/history_screen.dart` | Lote 10 |
| [T908](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/206) | Formateador, analizador, todas las pruebas y recorrido en el emulador; registro de verificación al final de este archivo (parcial: falta el recorrido en un teléfono; ver el registro) | Verificación completa pendiente; consultar informe actual |
| [T1003](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/209) | `frontend/lib/presentation/screens/settings_screen.dart` | Lote 5 |
| [T1005](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/211) | `frontend/lib/state/app_lock_controller.dart`, `frontend/lib/presentation/screens/lock_screen.dart`, `frontend/lib/app.dart` | Lote 5 |
| [T1006](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/212) | Prueba: al desactivarlo, la app deja de bloquearse | Lote 5 |
| [T1008](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/214) | Formateador, analizador, todas las pruebas y recorrido en el emulador con PIN y huella simulada; registro de verificación al final de este archivo (parcial: falta el recorrido en un teléfono; ver el registro) | Verificación completa pendiente; consultar informe actual |
| [T1102](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/216) | Cerrar sesión, volver a entrar y encontrar el documento, en el mismo recorrido | Verificación completa pendiente; consultar informe actual |
| [T1103](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/217) | quickstart.md (el comando), README.md y MAPA_DEL_CODIGO.md | Lote 11 |

T312/T1102: recorrido Android ampliado final aprobado (30,3 s), incluida recuperación,
organización y varias páginas. Estado completo: [68 verificadas / cuatro pendientes](docs/ESTADO_TAREAS_LUIS.md).
