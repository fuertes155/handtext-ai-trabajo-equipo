# Tareas de Samuel

Cuenta prevista: `fuertes155`. Total: 73. Estado inicial: todas pendientes. La issue es la fuente de estado actual.

## Sprint 1

- [ ] [T001](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/1) · Crear el proyecto del backend y la configuración de ruff y pytest en backend/pyproject.toml · Dificultad Baja.
- [ ] [T003](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/3) · Crear la app Flutter solo para Android y declarar sus dependencias en frontend/pubspec.yaml (analizador: frontend/analysis_options.yaml) · Dificultad Baja.
- [ ] [T005](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/5) · Configuración del backend (límites del spec, idiomas, tiempos y clave por variable de entorno) en backend/app/config.py · Dificultad Media.
- [ ] [T007](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/7) · Fábrica de la API, middleware de request_id y registros sin contenido en backend/app/main.py · Dificultad Alta.
- [ ] [T009](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/9) · Lectura del cuerpo con límite de tamaño en backend/app/api/request_body.py · Dificultad Media.
- [ ] [T014](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/14) · Textos de la interfaz en español en frontend/lib/presentation/strings.dart · Dificultad Baja.
- [ ] [T015](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/15) · Modelos de la app en frontend/lib/models/ (app_failure.dart, operation_status.dart, image_format.dart, export_format.dart, picked_image.dart, recognition_result.dart) · Dificultad Media.
- [ ] [T018](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/18) · Preparación de la copia para el OCR (original intacto, orientación, sin EXIF) en backend/tests/test_image_preparation.py · Dificultad Media.
- [ ] [T020](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/20) · API de reconocimiento (texto, sin texto, límites, fallos del proveedor) en backend/tests/test_recognitions_api.py · Dificultad Media.
- [ ] [T023](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/23) · Cliente HTTP y traducción de errores en frontend/test/services/handtext_api_client_test.dart · Dificultad Media.
- [ ] [T028](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/28) · Preparación en memoria de la copia para el OCR en backend/app/services/image_preparation.py · Dificultad Media.
- [ ] [T031](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/31) · Ruta POST /api/v1/recognitions en backend/app/api/recognitions.py · Dificultad Media.
- [ ] [T034](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/34) · Servicio de exportación y ruta POST /api/v1/exports en backend/app/services/documents/export_service.py y backend/app/api/exports.py · Dificultad Media.
- [ ] [T037](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/37) · Borrador local en frontend/lib/services/draft_storage.dart · Dificultad Media.
- [ ] [T040](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/40) · Selección de imágenes de la galería en frontend/lib/services/image_source_service.dart · Dificultad Media.
- [ ] [T041](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/41) · Controlador del flujo en frontend/lib/state/document_flow_controller.dart · Dificultad Alta.
- [ ] [T046](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/46) · Servicio del permiso de cámara en frontend/lib/services/camera_permission_service.dart · Dificultad Media.
- [ ] [T049](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/49) · Pruebas de PDF (caracteres, varias páginas, caracteres no representables) en backend/tests/test_exports_pdf.py · Dificultad Media.
- [ ] [T052](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/52) · Selector Word/PDF en frontend/lib/presentation/widgets/export_format_sheet.dart · Dificultad Baja.
- [ ] [T055](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/55) · Guía de ejecución y validación en specs/001-handtext-mvp/quickstart.md · Dificultad Baja.
- [ ] [T060](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/60) · Guía de la clave de Google y de la medición en specs/001-handtext-mvp/quickstart.md · Dificultad Baja.

## Sprint 2

- [ ] [T101](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/62) · Dependencias del backend (psycopg, psycopg-pool y argon2-cffi; pgserver solo en desarrollo) en backend/requirements.txt y backend/requirements-dev.txt · Dificultad Baja.
- [ ] [T105](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/66) · Códigos de error de cuentas en backend/app/errors.py · Dificultad Baja.
- [ ] [T106](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/67) · Contrato del almacén de usuarios en backend/app/persistence/user_store.py · Dificultad Media.
- [ ] [T109](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/70) · Pruebas de contrato del almacén (memoria y PostgreSQL) en backend/tests/test_user_store.py, con backend/tests/memory_store.py y backend/tests/conftest.py · Dificultad Alta.
- [ ] [T111](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/72) · Widgets base Aurora en frontend/lib/presentation/widgets/ (aurora_background.dart, glass_card.dart, scanner_logo.dart, gradient_button.dart y motion.dart) · Dificultad Media.
- [ ] [T115](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/76) · Reglas de nombre, correo y contraseña en backend/app/services/accounts/rules.py · Dificultad Media.
- [ ] [T117](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/78) · Rutas /auth y dependencia require_user en backend/app/api/auth.py, con esquemas en backend/app/schemas.py y conexión en backend/app/main.py · Dificultad Alta.
- [ ] [T121](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/82) · Errores de API compartidos en frontend/lib/services/api_errors.dart y token en frontend/lib/services/handtext_api_client.dart · Dificultad Media.
- [ ] [T123](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/84) · Sesión en el almacenamiento seguro en frontend/lib/services/session_store.dart · Dificultad Media.
- [ ] [T129](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/90) · Pruebas de cierre, eliminación y sesión vencida en backend/tests/test_auth_api.py, frontend/test/state/auth_controller_test.dart y frontend/test/presentation/auth_screens_test.dart · Dificultad Media.
- [ ] [T132](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/93) · Rediseño de inicio, vista previa, editor y transiciones en frontend/lib/presentation/screens/ · Dificultad Alta.
- [ ] [T133](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/94) · Rediseño de avisos, diálogos y selector de formato en frontend/lib/presentation/widgets/ · Dificultad Media.
- [ ] [T135](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/96) · Pruebas de pantallas con animaciones reducidas en frontend/test/presentation/flow_screen_test.dart · Dificultad Media.
- [ ] [T140](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/101) · Nueva paleta y medidas en frontend/lib/theme/aurora.dart y temas en frontend/lib/theme/app_theme.dart · Dificultad Media.
- [ ] [T143](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/104) · Pantallas con la nueva paleta en frontend/lib/presentation/screens/ · Dificultad Media.
- [ ] [T144](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/105) · Pantalla de arranque de Android en azul marino en frontend/android/app/src/main/res/ · Dificultad Baja.
- [ ] [T203](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/110) · UncertainSpan y OcrResult.uncertain_spans en backend/app/services/ocr/base.py; umbral en backend/app/config.py · Dificultad Media.
- [ ] [T209](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/116) · Marcas en frontend/lib/state/document_flow_controller.dart (reconocer, editar, «Está bien», borrador), con pruebas del controlador · Dificultad Alta.
- [ ] [T211](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/118) · Servicio de recorte en frontend/lib/services/image_editor_service.dart (image_cropper con los colores Aurora) · Dificultad Media.
- [ ] [T214](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/121) · Servicio de compartir en frontend/lib/services/share_service.dart (copia en handtext_share y share_plus) · Dificultad Media.
- [ ] [T217](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/124) · Conexión de los servicios reales en frontend/lib/main.dart y textos en frontend/lib/presentation/strings.dart · Dificultad Media.
- [ ] [T218](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/125) · Documentación: quickstart.md, README.md y MAPA_DEL_CODIGO.md · Dificultad Baja.

## Sprint 3

- [ ] [T301](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/127) · Pruebas de joinPages en frontend/test/services/page_join_test.dart · Dificultad Media.
- [ ] [T304](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/130) · Página, total y páginas sin texto en frontend/lib/models/operation_status.dart; mensajes y fallo «demasiadas páginas» en frontend/lib/presentation/strings.dart y frontend/lib/models/app_failure.dart · Dificultad Media.
- [ ] [T307](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/133) · Autorización con la cantidad de imágenes en frontend/lib/presentation/widgets/consent_dialog.dart · Dificultad Baja.
- [ ] [T309](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/135) · Tira de miniaturas y acciones en frontend/lib/presentation/widgets/page_strip.dart y frontend/lib/presentation/screens/preview_screen.dart, con pruebas de pantalla · Dificultad Media.
- [ ] [T402](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/140) · AppSettings en frontend/lib/models/app_settings.dart, almacén en frontend/lib/services/settings_store.dart y controlador en frontend/lib/state/settings_controller.dart · Dificultad Media.
- [ ] [T405](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/143) · «Ajustes» y «Acerca de» en el menú de cuenta (frontend/lib/presentation/widgets/account_menu.dart), con pruebas de pantalla · Dificultad Media.
- [ ] [T407](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/145) · appVersion y appBuild en frontend/lib/config/app_config.dart; pantallas «Acerca de» y Privacidad; licencia de Poppins registrada en frontend/lib/main.dart · Dificultad Media.
- [ ] [T408](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/146) · Enlace «Privacidad y acerca de» en la bienvenida · Dificultad Baja.
- [ ] [T412](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/150) · Documentación: quickstart.md, README.md y MAPA_DEL_CODIGO.md · Dificultad Baja.
- [ ] [T504](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/155) · Pantalla frontend/lib/presentation/screens/tips_screen.dart y textos en frontend/lib/presentation/strings.dart · Dificultad Media.
- [ ] [T506](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/157) · Pruebas de nombres (labeledTapTargetGuideline), del anuncio de la palabra dudosa y de los encabezados en frontend/test/presentation/accessibility_test.dart · Dificultad Media.
- [ ] [T508](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/159) · Anuncio de la palabra elegida con «Siguiente» (R7) en frontend/lib/presentation/screens/editor_screen.dart · Dificultad Baja.
- [ ] [T513](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/164) · Documentación: quickstart.md, README.md, MAPA_DEL_CODIGO.md y la sección «Ajustes» de la privacidad · Dificultad Baja.
- [ ] [T601](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/166) · Pruebas del almacén (guardar y leer, archivo dañado, otra cuenta, borrar, nombre seguro) y del título en frontend/test/services/history_store_test.dart · Dificultad Media.
- [ ] [T605](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/170) · Registrar en DocumentFlowController.export y olvidar historyId al empezar otro documento (frontend/lib/state/document_flow_controller.dart); conexión en frontend/lib/main.dart · Dificultad Media.
- [ ] [T607](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/172) · Pantalla frontend/lib/presentation/screens/history_screen.dart, «Mis documentos» en el inicio y textos (fechas en español) en frontend/lib/presentation/strings.dart · Dificultad Media.
- [ ] [T611](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/176) · Eliminar y borrar todo con confirmación en la pantalla; clearLocalData(deleteHistory: true) al eliminar la cuenta en frontend/lib/presentation/widgets/account_menu.dart · Dificultad Media.
- [ ] [T613](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/178) · Formateador, analizador, todas las pruebas y recorrido en el emulador con 50 documentos (SC-705); registro de verificación al final de este archivo · Dificultad Baja.

## Sprint 4

- [ ] [T702](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/180) · Las pantallas y widgets usan context.strings; main.dart y los servicios leen AppStrings.current (R3); las pruebas usan la instancia en español (frontend/test/support/strings_es.dart). Todas las pruebas anteriores siguen pasando · Dificultad Alta.
- [ ] [T705](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/183) · Pruebas de pantalla: Ajustes, bienvenida, «Automático» con teléfono en inglés y en otro idioma, conservar al cerrar, en frontend/test/presentation/language_test.dart · Dificultad Media.
- [ ] [T709](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/187) · Prueba: cambiar el idioma con texto y marcas en el editor no los cambia, y la exportación usa el mismo texto (SC-803) · Dificultad Media.
- [ ] [T711](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/189) · Formateador, analizador, todas las pruebas y recorrido en el emulador en inglés; registro de verificación al final de este archivo · Dificultad Baja.
- [ ] [T804](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/193) · «Escanear hoja» en el inicio, «Escanear» al agregar página y textos en español e inglés; pruebas de pantalla · Dificultad Media.
- [ ] [T807](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/196) · Pruebas: hoja no válida entre válidas y «Escanear de nuevo» para reemplazar · Dificultad Media.
- [ ] [T809](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/198) · Formateador, analizador, todas las pruebas, compilación de la versión final y recorrido en el emulador con el escáner real; registro de verificación al final de este archivo (parcial: falta escanear una hoja en un teléfono; ver el registro) · Dificultad Baja.
- [ ] [T904](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/202) · Pruebas de búsqueda (tildes y mayúsculas), renombrar y conservar el nombre al volver a guardar · Dificultad Media.
- [ ] [T1001](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/207) · Dependencia local_auth 3.0.1; MainActivity como FlutterFragmentActivity; DeviceAuthenticator en frontend/lib/services/device_authenticator.dart y uno falso en frontend/test/support/fakes.dart · Dificultad Media.
- [ ] [T1004](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/210) · Pruebas: bloqueada al abrir, desbloquear conserva el estado, cancelar sigue bloqueada, más y menos de 1 minuto en segundo plano, sin sesión no se bloquea, en frontend/test/presentation/app_lock_test.dart · Dificultad Media.
- [ ] [T1101](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/215) · integration_test en dev_dependencies; recorrido en frontend/integration_test/flujo_completo_test.dart con la app armada como en main.dart (R2), la hoja sintética (R3) y los tiempos (R4) · Dificultad Alta.
- [ ] [T1104](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/218) · Ejecución en el emulador con la API local; registro de verificación al final de este archivo · Dificultad Media.

## Registro de verificación · 9 de noviembre de 2026

- **Pruebas locales.** 209 pruebas de Flutter pasaron. En backend pasaron 79 pruebas de la API y los servicios, y 12 adicionales del almacén en memoria y PostgreSQL temporal. El analizador de Flutter y Ruff también pasaron.
- **T1101 y T1104.** En `emulator-5556`, el recorrido de integración pasó en 59,5 s con una cuenta temporal. Se creó la cuenta local, se seleccionó una hoja sintética, se corrigió el texto, se generó un DOCX con FastAPI local y se recuperó el documento después de cerrar e iniciar sesión. Se verificó el texto corregido dentro del archivo. El OCR y los selectores de Android se simularon. La exportación y el guardado privado sí se ejecutaron.
- **T613 y T711.** En el emulador Android 16, se cargaron 50 entradas de prueba y se abrió el documento guardado desde la interfaz en inglés. La apertura bajó de 1.119 ms a 1.102 ms, por encima del límite de 1.000 ms de SC-705. Pasaron 32 pruebas dirigidas de historial después de la optimización. El recorrido imprime la medición y permite exigir el límite con `E2E_STRICT_HISTORY=true` en la configuración de Flutter.
- **T809.** El APK de depuración x86_64 se compiló. Las pruebas del escáner simulan la fuente de imágenes. Queda por escanear una hoja física con ML Kit en un teléfono.
