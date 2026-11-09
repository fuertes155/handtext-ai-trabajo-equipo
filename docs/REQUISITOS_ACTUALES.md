# Requisitos actuales

## Producto

App Flutter para Android que captura o selecciona manuscritos, permite reconocimiento, revisión del texto y exportación DOCX/PDF mediante FastAPI. Evolución por cuatro sprints con varias páginas, historial, idioma, ajustes, accesibilidad, escáner, organización y bloqueo biométrico.

## Restricciones que prevalecen sobre las especificaciones antiguas

- Registro e inicio de sesión de la app exclusivamente locales, sin solicitudes al backend para autenticarse.
- Cuentas y sesiones guardadas de forma segura en el dispositivo. Derivación de contraseñas con salt y Argon2id o equivalente adecuado mediante dependencia mantenida. No usar SHA-256 directo.
- Separar cuentas y almacenamiento de depuración y distribución cuando corresponda.
- API únicamente en el computador para la prueba, preparada para el puerto 8001. Inspeccionar puertos y procesos antes de iniciarla. No detener servicios desconocidos ni ocupar 8000 por suposición.
- `API_BASE_URL` configurable. El acceso de desarrollo exige `LOCAL_DEV_API_TOKEN` en la app y `HANDTEXT_LOCAL_DEV_TOKEN` en la API, configurados por canales locales seguros.
- Acceso de desarrollo desactivado por defecto y no habilitado en compilaciones para distribuir. Ese token solo puede autorizar reconocimiento/exportación. Nunca las rutas de cuentas.
- El OCR real requiere credenciales ya configuradas de Google Cloud Vision. Gemini Plus no aporta esa clave. No pedir secretos en el chat ni afirmar que OCR funciona sin validación.
- No desplegar la API. No subir claves, tokens, `.env`, archivos de credenciales o datos personales. Usar muestras sintéticas o autorizadas.
- No borrar datos ni desinstalar apps sin permiso. Si falta espacio, informar primero. Usar el emulador mientras no haya dispositivo disponible.
- Ejecutar pruebas pertinentes de Flutter/backend, análisis y formato. Compilar APK x86_64 cuando exista una implementación que pueda compilarse.

## Dependencias y coordinación

La estructura inicial no existe aún. Empezar por tareas de preparación de backend, dependencias, Flutter y exclusiones Git. Después, integrar configuración y contratos compartidos antes de construir consumidores. Cada integrante revisa las issues relacionadas y coordina contratos y archivos compartidos con los demás. Una tarea que necesita un módulo ausente está bloqueada hasta integrarlo o acordar explícitamente una dependencia.

Las pruebas de servidor de cuentas pueden mantenerse donde la especificación lo requiera, pero la app local no debe consumir esas rutas. Si una tarea antigua contradice estas restricciones, actualizar su alcance mediante un acuerdo en su issue antes de implementarla.

## Referencias por funcionalidad

- [001 · 001-handtext-mvp](https://github.com/Juan-Miguel-Her-Del/documento_word/tree/356ff82297820bccfac9f5049ea020c9f40f0001/specs/001-handtext-mvp/spec.md)
- [002 · 002-cuentas-de-usuario](https://github.com/Juan-Miguel-Her-Del/documento_word/tree/356ff82297820bccfac9f5049ea020c9f40f0001/specs/002-cuentas-de-usuario/spec.md)
- [003 · 003-revision-recorte-compartir](https://github.com/Juan-Miguel-Her-Del/documento_word/tree/356ff82297820bccfac9f5049ea020c9f40f0001/specs/003-revision-recorte-compartir/spec.md)
- [004 · 004-varias-paginas](https://github.com/Juan-Miguel-Her-Del/documento_word/tree/356ff82297820bccfac9f5049ea020c9f40f0001/specs/004-varias-paginas/spec.md)
- [005 · 005-ajustes-y-version-final](https://github.com/Juan-Miguel-Her-Del/documento_word/tree/356ff82297820bccfac9f5049ea020c9f40f0001/specs/005-ajustes-y-version-final/spec.md)
- [006 · 006-primer-uso-y-accesibilidad](https://github.com/Juan-Miguel-Her-Del/documento_word/tree/356ff82297820bccfac9f5049ea020c9f40f0001/specs/006-primer-uso-y-accesibilidad/spec.md)
- [007 · 007-historial-de-documentos](https://github.com/Juan-Miguel-Her-Del/documento_word/tree/356ff82297820bccfac9f5049ea020c9f40f0001/specs/007-historial-de-documentos/spec.md)
- [008 · 008-idioma-ingles](https://github.com/Juan-Miguel-Her-Del/documento_word/tree/356ff82297820bccfac9f5049ea020c9f40f0001/specs/008-idioma-ingles/spec.md)
- [009 · 009-escaner-de-documentos](https://github.com/Juan-Miguel-Her-Del/documento_word/tree/356ff82297820bccfac9f5049ea020c9f40f0001/specs/009-escaner-de-documentos/spec.md)
- [010 · 010-organizar-documentos](https://github.com/Juan-Miguel-Her-Del/documento_word/tree/356ff82297820bccfac9f5049ea020c9f40f0001/specs/010-organizar-documentos/spec.md)
- [011 · 011-bloqueo-con-huella](https://github.com/Juan-Miguel-Her-Del/documento_word/tree/356ff82297820bccfac9f5049ea020c9f40f0001/specs/011-bloqueo-con-huella/spec.md)
- [012 · 012-pruebas-de-punta-a-punta](https://github.com/Juan-Miguel-Her-Del/documento_word/tree/356ff82297820bccfac9f5049ea020c9f40f0001/specs/012-pruebas-de-punta-a-punta/spec.md)
