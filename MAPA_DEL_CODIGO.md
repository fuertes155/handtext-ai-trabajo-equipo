# Mapa del código

> **Reinicio 2026-11-17:** este mapa describe la integración histórica anterior. Las tareas de Luis están pendientes; consultar [el inventario actual](docs/REINICIO_LUIS.md). No acredita que el código actual esté completo.

| Componente | Responsabilidad |
| --- | --- |
| `frontend/lib/main.dart` | Conecta cuentas locales, ajustes, sesión y servicios de documentos. |
| `frontend/lib/services/local_auth_api.dart` | Guarda cuentas de forma segura y deriva contraseñas con Argon2id. |
| `frontend/lib/state/document_flow_controller.dart` | Coordina imágenes, reconocimiento, edición y exportación. |
| `frontend/lib/presentation/screens/` | Presenta bienvenida, editor, ajustes, privacidad, consejos e historial. |
| `frontend/lib/presentation/strings_es.dart` y `strings_en.dart` | Textos localizados. |
| `frontend/lib/state/settings_controller.dart` | Aplica el tema, tamaño de letra e idioma y guarda las preferencias. |
| `backend/app/main.py` y `backend/app/api/` | Crean FastAPI, asignan identificadores y aplican la autorización de rutas. |
| `backend/app/services/ocr/` y `documents/` | Reconocimiento y generación DOCX/PDF. |
| `backend/tests/` y `frontend/test/` | Pruebas de contrato, servicios y pantalla. |

Las cuentas de la app residen en el dispositivo. La API también contiene rutas de cuentas de servidor para las pruebas de su contrato. El cliente de documentos se conecta a la API local y el token optativo de desarrollo solo se admite para reconocimiento y exportación.


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
