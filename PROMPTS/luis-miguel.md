# Prompt para Luis Miguel

Copia desde la siguiente línea hasta el final y úsalo en el checkout de este repositorio.

---

Soy Luis Miguel, mi usuario GitHub es `LUISDACA` y trabajo en `https://github.com/fuertes155/handtext-ai-trabajo-equipo`. Tengo 72 tareas repartidas en cuatro sprints. Necesito ayuda para realizar aportes reales, una tarea a la vez. No desarrolles toda la app de una vez.

## Primera respuesta obligatoria

1. Inspecciona `git status`, la rama actual, los archivos y las instrucciones del repositorio. No sobrescribas cambios ajenos.
2. Lee `README.md`, `docs/REQUISITOS_ACTUALES.md`, `docs/FLUJO_EQUIPO.md`, `docs/SPRINTS.md` y `TAREAS/luis-miguel.md`.
3. Consulta el estado actual de mis issues en GitHub. El listado de abajo es el reparto inicial, no una prueba de trabajo completado.
4. Resume lo que existe, qué tareas mías están desbloqueadas y cuál propones empezar. Pregunta qué tarea elijo y espera mi respuesta.
5. En esta primera fase no escribas código, no instales dependencias, no hagas commits, no subas ramas y no cierres issues.

## Después de que elija una tarea

- Limita el trabajo a la tarea elegida. Explica sus dependencias y criterios verificables. Si falta una dependencia de otro integrante, registra el bloqueo y coordina, no te apropies de su trabajo ni inventes un módulo incompatible.
- Pide autorización antes de empezar a implementar. Si mi elección ya incluye claramente esa autorización, continúa solo con esa tarea.
- Crea o usa una rama propia para esa tarea. Conserva los archivos ajenos y cualquier cambio local. No toques la configuración global de Git ni cambies a otra cuenta.
- Implementa y ejecuta las pruebas pertinentes. Si no se pueden ejecutar, di exactamente qué falta. Nunca afirmes que una prueba pasó sin observarla.
- Antes del commit, muéstrame el resumen del diff, los resultados y los archivos exactos que se incluirán. Espera mi revisión y autorización para confirmar y publicar.
- Usa mi identidad real configurada y el acceso propio. Nunca solicites contraseñas o tokens en el chat. No fabriques fechas, autorías, commits vacíos ni cierres de tareas.
- Si existe trabajo de varias personas, documenta la colaboración real. Cita material reutilizado del proyecto anterior. Reutilizar código no lo convierte en un aporte original mío.
- Abre el PR únicamente cuando yo lo autorice. Incluye la issue, pruebas, limitaciones y dependencias. Otro integrante debe revisarlo antes de integrarlo.
- Al terminar la tarea, para y espera a que elija la siguiente. No continúes automáticamente con las restantes.

## Producto y límites técnicos

Flutter Android con cuentas y sesiones locales seguras. Registro e ingreso no llaman al backend. Contraseñas con derivación adecuada y salt. FastAPI solo local en el computador, puerto previsto 8001. Token de desarrollo desactivado por defecto, limitado a reconocimiento/exportación y no admitido para cuentas ni compilaciones de distribución. OCR real solo se valida con Google Cloud Vision ya configurado. No desplegar, no subir secretos ni datos personales, no borrar datos ni desinstalar apps sin permiso. Conservar las correcciones del usuario. Consultar todos los detalles en `docs/REQUISITOS_ACTUALES.md`, que prevalece sobre requisitos antiguos.

El proyecto anterior es una referencia explícita: https://github.com/Juan-Miguel-Her-Del/documento_word/tree/356ff82297820bccfac9f5049ea020c9f40f0001. Este repositorio comienza con planificación y tareas pendientes. No copies toda su implementación ni reescribas su historial para simular aportes nuevos.

## Mis tareas iniciales


## Sprint 1

- [ ] [T002](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/2) · Fijar las dependencias exactas en backend/requirements.txt y backend/requirements-dev.txt · Dificultad Baja.
- [ ] [T006](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/6) · Catálogo de errores con código, mensaje y request_id, y sus manejadores, en backend/app/errors.py · Dificultad Media.
- [ ] [T010](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/10) · Utilidades de prueba (imágenes sintéticas y OCR falso) en backend/tests/conftest.py · Dificultad Media.
- [ ] [T012](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/12) · Configuración de la app (URL del backend, tiempos y límites) en frontend/lib/config/app_config.dart · Dificultad Baja.
- [ ] [T013](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/13) · Tema centralizado en frontend/lib/theme/app_theme.dart · Dificultad Media.
- [ ] [T016](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/16) · Manifiestos Android (Internet, sin copias de seguridad y HTTP solo en debug) en frontend/android/app/src/main/AndroidManifest.xml, frontend/android/app/src/main/res/xml/data_extraction_rules.xml y frontend/android/app/src/debug/AndroidManifest.xml · Dificultad Media.
- [ ] [T021](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/21) · Exportación Word (contenido, párrafos, caracteres, texto vacío) en backend/tests/test_exports_docx.py · Dificultad Media.
- [ ] [T022](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/22) · Reglas de imagen de la app en frontend/test/services/image_rules_test.dart · Dificultad Media.
- [ ] [T025](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/25) · Controlador del flujo (autorización, duplicados, fallos y borrador) en frontend/test/state/document_flow_controller_test.dart · Dificultad Alta.
- [ ] [T026](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/26) · Pantallas y diálogos del flujo en frontend/test/presentation/flow_screen_test.dart · Dificultad Media.
- [ ] [T032](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/32) · Reglas del texto exportable (vacío, tamaño y caracteres XML) en backend/app/services/documents/text_rules.py · Dificultad Media.
- [ ] [T035](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/35) · Reglas y lectura de dimensiones de imagen en frontend/lib/services/image_rules.dart · Dificultad Media.
- [ ] [T038](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/38) · Cliente de la API en frontend/lib/services/handtext_api_client.dart · Dificultad Media.
- [ ] [T042](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/42) · Widgets de estado, autorización y confirmación en frontend/lib/presentation/widgets/ (status_message.dart, consent_dialog.dart, confirm_dialog.dart) · Dificultad Media.
- [ ] [T043](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/43) · Pantallas en frontend/lib/presentation/screens/ (flow_screen.dart, start_screen.dart, preview_screen.dart, editor_screen.dart) · Dificultad Alta.
- [ ] [T045](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/45) · Pruebas de captura y permisos en frontend/test/state/camera_flow_test.dart · Dificultad Media.
- [ ] [T050](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/50) · Fuente DejaVu Sans y su licencia en backend/app/assets/fonts/ · Dificultad Baja.
- [ ] [T051](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/51) · Generador de PDF en backend/app/services/documents/pdf_builder.py · Dificultad Media.
- [ ] [T054](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/54) · Mapa de requisitos → código → pruebas en MAPA_DEL_CODIGO.md · Dificultad Baja.
- [ ] [T057](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/57) · Compilar el APK de depuración con flutter build apk --debug en frontend/ · Dificultad Baja.

## Sprint 2

- [ ] [T104](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/65) · Configuración de la base, la duración de la sesión, el bloqueo y los límites en backend/app/config.py · Dificultad Baja.
- [ ] [T108](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/69) · Ejecutor de migraciones en backend/app/persistence/migrations.py · Dificultad Media.
- [ ] [T110](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/71) · Colores, degradados y temas Aurora en frontend/lib/theme/aurora.dart y frontend/lib/theme/app_theme.dart · Dificultad Media.
- [ ] [T114](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/75) · Contraseñas Argon2id y tokens en backend/app/services/accounts/passwords.py y backend/app/services/accounts/tokens.py · Dificultad Alta.
- [ ] [T118](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/79) · Protección de reconocimiento y exportación en backend/app/api/recognitions.py y backend/app/api/exports.py · Dificultad Media.
- [ ] [T119](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/80) · Pruebas de la app en frontend/test/services/auth_api_client_test.dart, frontend/test/services/account_rules_test.dart y frontend/test/state/auth_controller_test.dart · Dificultad Media.
- [ ] [T124](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/85) · Reglas de formulario en frontend/lib/services/account_rules.dart · Dificultad Media.
- [ ] [T125](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/86) · Controlador de sesión en frontend/lib/state/auth_controller.dart · Dificultad Alta.
- [ ] [T126](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/87) · Pantallas de presentación, bienvenida, ingreso y registro en frontend/lib/presentation/screens/auth/ · Dificultad Alta.
- [ ] [T128](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/89) · Pruebas de pantallas de cuentas en frontend/test/presentation/auth_screens_test.dart · Dificultad Media.
- [ ] [T130](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/91) · Menú de cuenta y diálogo de eliminación en frontend/lib/presentation/widgets/account_menu.dart · Dificultad Media.
- [ ] [T134](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/95) · Animación de escaneo sobre la imagen en frontend/lib/presentation/widgets/scan_overlay.dart · Dificultad Media.
- [ ] [T137](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/98) · Formateadores, analizadores y todas las pruebas; registro de verificación al final de este archivo · Dificultad Baja.
- [ ] [T139](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/100) · Prueba de contraste de la paleta [SC-208] en frontend/test/theme/aurora_contrast_test.dart · Dificultad Media.
- [ ] [T142](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/103) · Logo-escáner, animación de escaneo, avisos, menú de cuenta, diálogo de autorización y campo de contraseña con la nueva paleta en frontend/lib/presentation/widgets/ · Dificultad Media.
- [ ] [T201](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/108) · Dependencias image_cropper 12.2.1 y share_plus 12.0.2 en frontend/pubspec.yaml; UCropActivity en frontend/android/app/src/main/AndroidManifest.xml · Dificultad Baja.
- [ ] [T205](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/112) · Campo uncertain_words en backend/app/schemas.py y backend/app/api/recognitions.py, con su prueba en backend/tests/test_recognitions_api.py · Dificultad Media.
- [ ] [T206](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/113) · Pruebas de conversión, validación y ajuste de marcas en frontend/test/services/uncertain_ranges_test.dart · Dificultad Media.
- [ ] [T210](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/117) · ReviewTextController en frontend/lib/presentation/widgets/review_text_controller.dart y barra de revisión en frontend/lib/presentation/screens/editor_screen.dart, con pruebas de pantalla · Dificultad Alta.
- [ ] [T213](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/120) · Acciones «Recortar o girar» y «Usar la imagen original» en frontend/lib/presentation/screens/preview_screen.dart, con pruebas de pantalla · Dificultad Media.
- [ ] [T216](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/123) · Botón «Compartir» en el aviso de éxito del editor, con prueba de pantalla · Dificultad Media.

## Sprint 3

- [ ] [T303](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/129) · pickMultipleFromGallery en frontend/lib/services/image_source_service.dart y en el servicio falso de las pruebas · Dificultad Media.
- [ ] [T305](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/131) · Pruebas del controlador con varias páginas en frontend/test/state/pages_flow_test.dart · Dificultad Media.
- [ ] [T312](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/138) · Formateadores, analizadores, todas las pruebas, APK y recorrido en el emulador; registro de verificación al final de este archivo · Dificultad Baja.
- [ ] [T401](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/139) · Pruebas del almacén y del controlador de ajustes en frontend/test/state/settings_test.dart · Dificultad Media.
- [ ] [T404](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/142) · Pantalla de Ajustes en frontend/lib/presentation/screens/settings_screen.dart y tamaño de letra en el editor · Dificultad Media.
- [ ] [T406](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/144) · Prueba de la versión contra pubspec.yaml y pruebas de pantalla de «Acerca de» · Dificultad Media.
- [ ] [T409](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/147) · Firma con key.properties y HTTP según el tipo de compilación en frontend/android/app/build.gradle.kts y en el manifiesto · Dificultad Alta.
- [ ] [T411](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/149) · Compilar la versión final por procesador, instalarla y medir el arranque (SC-504) · Dificultad Baja.
- [ ] [T503](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/154) · Pruebas de pantalla de los consejos (primera vez, Siguiente, Empezar, Saltar, atrás, cambio de cuenta, abrir desde el inicio y Ajustes) en frontend/test/presentation/tips_screen_test.dart · Dificultad Media.
- [ ] [T505](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/156) · Consejos la primera vez en frontend/lib/presentation/screens/app_root.dart; enlaces en start_screen.dart y settings_screen.dart; arnés de pruebas con tipsSeen · Dificultad Media.
- [ ] [T507](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/158) · Avatar sin la inicial en la lectura (R9) en frontend/lib/presentation/widgets/account_menu.dart · Dificultad Baja.
- [ ] [T511](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/162) · Avatar de 48 dp (R9) y diálogo de eliminar cuenta desplazable (R6) en frontend/lib/presentation/widgets/account_menu.dart · Dificultad Baja.
- [ ] [T512](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/163) · Avisos del editor en un área desplazable y encabezado más corto con letra grande (R5) en frontend/lib/presentation/screens/editor_screen.dart; hoja de exportar desplazable (R6) en frontend/lib/presentation/widgets/export_format_sheet.dart · Dificultad Media.
- [ ] [T604](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/169) · Pruebas del controlador: registrar al guardar, actualizar sin duplicar, no registrar cancelados ni fallidos, fallo del historial sin afectar el guardado, en frontend/test/state/history_flow_test.dart · Dificultad Media.
- [ ] [T606](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/171) · Pruebas de pantalla (lista, vacío, orden, otra cuenta) en frontend/test/presentation/history_screen_test.dart · Dificultad Media.
- [ ] [T610](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/175) · Pruebas de eliminar, borrar todo, cancelar y eliminar la cuenta · Dificultad Media.
- [ ] [T612](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/177) · Privacidad («Historial»), quickstart.md, README.md y MAPA_DEL_CODIGO.md; guías de accesibilidad de 006 (nombres y 48 dp, al 100 % y al 200 %) en history_screen_test.dart · Dificultad Baja.

## Sprint 4

- [ ] [T704](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/182) · AppLanguage en AppSettings, almacén y controlador; locale y resolución en frontend/lib/app.dart · Dificultad Media.
- [ ] [T708](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/186) · Recorrido de todas las pantallas en inglés al 100 % y al 200 % sin textos en español (SC-802, SC-805), fallos y títulos de servicios · Dificultad Media.
- [ ] [T803](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/192) · ImageOrigin.scanner, scanDocument y el origen en _addImages en frontend/lib/state/document_flow_controller.dart; conexión en frontend/lib/main.dart · Dificultad Media.
- [ ] [T806](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/195) · scannerUnavailable y scannerFailed, StatusAction.takePhoto y el aviso con acción en el inicio · Dificultad Media.
- [ ] [T902](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/200) · suggestedFileName con el título y su uso en DocumentFlowController.export (frontend/lib/state/document_flow_controller.dart) · Dificultad Media.
- [ ] [T903](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/201) · «Copiar todo el texto» en el menú del editor (frontend/lib/presentation/screens/editor_screen.dart), textos en español e inglés y privacidad; pruebas de pantalla en frontend/test/presentation/organize_test.dart · Dificultad Baja.
- [ ] [T906](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/204) · Búsqueda y «Renombrar» en frontend/lib/presentation/screens/history_screen.dart · Dificultad Media.
- [ ] [T908](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/206) · Formateador, analizador, todas las pruebas y recorrido en el emulador; registro de verificación al final de este archivo (parcial: falta el recorrido en un teléfono; ver el registro) · Dificultad Baja.
- [ ] [T1003](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/209) · appLock en AppSettings, almacén y controlador; interruptor en frontend/lib/presentation/screens/settings_screen.dart · Dificultad Media.
- [ ] [T1005](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/211) · AppLockController (R3) en frontend/lib/state/app_lock_controller.dart, pantalla frontend/lib/presentation/screens/lock_screen.dart y AppLockGate en frontend/lib/app.dart (R4); textos en español e inglés · Dificultad Alta.
- [ ] [T1006](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/212) · Prueba: al desactivarlo, la app deja de bloquearse · Dificultad Baja.
- [ ] [T1008](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/214) · Formateador, analizador, todas las pruebas y recorrido en el emulador con PIN y huella simulada; registro de verificación al final de este archivo (parcial: falta el recorrido en un teléfono; ver el registro) · Dificultad Baja.
- [ ] [T1102](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/216) · Cerrar sesión, volver a entrar y encontrar el documento, en el mismo recorrido · Dificultad Media.
- [ ] [T1103](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/217) · quickstart.md (el comando), README.md y MAPA_DEL_CODIGO.md · Dificultad Baja.
