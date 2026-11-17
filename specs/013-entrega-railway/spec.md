# 013 · Entrega Android con API Railway

Consolidación del 2026-11-16. Despliegue autorizado el 2026-11-09. Amplía 001, 002 y 005 para permitir demostrar el flujo desde otras redes.

## Requisitos

1. `HOSTED_ACCOUNTS=true` exige HTTPS y selecciona `AuthApiClient`. La sesión se guarda de forma segura por URL del servidor.
2. Reconocimiento y exportación usan Bearer de la cuenta. La API pública rechaza solicitudes sin sesión y el permiso local de desarrollo.
3. RapidOCR devuelve el texto detectado. El usuario lo revisa antes de generar Word/PDF.
4. PostgreSQL privado conserva cuentas y sesiones. El contenedor aplica migraciones antes de Uvicorn, escucha en `PORT` y ofrece `/health`.
5. La compilación local conserva registro/ingreso sin red y cuentas existentes. La distribución exige firma válida.

## Non-Goals

- Versión web, iOS o publicación en Google Play.
- Migración automática de cuentas locales y sincronización del historial.
- Conservación de fotografías en el servidor.
- Acreditar precisión manuscrita sin corpus, autoría ajena o recorridos físicos no observados.

## Aceptación

Registro, login, sesión, logout y rechazo de sesión revocada deben producir las respuestas esperadas. Una imagen sintética debe reconocerse y exportarse verificando el contenido de DOCX/PDF. El APK debe usar HTTPS, tener permiso INTERNET y firma comprobable. Samsung, TalkBack, biometría y CER requieren evidencia propia antes de cerrar sus tareas.

El [registro de entrega](../../docs/VERIFICACION_ENTREGA.md) distingue las verificaciones actuales de las históricas.
