# Mapa del código

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
