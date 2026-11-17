# Plan técnico

1. Preservar implementación pendiente e integrar los tres commits recientes de `main` en una rama de entrega.
2. Construir Docker desde la raíz, con Python 3.12, dependencias fijadas y modelos ONNX verificados por SHA-256. Ejecutar con usuario sin privilegios y migración transaccional antes de Uvicorn.
3. Referenciar el PostgreSQL privado mediante `HANDTEXT_DATABASE_URL`. Configurar dominio HTTPS y `/health`.
4. Seleccionar cuentas del servidor mediante `HOSTED_ACCOUNTS`. Aislar sesiones por URL y enviar Bearer en documentos.
5. Ejecutar pruebas después de la integración, revisar documentación y presentación y abrir PR.

El APK firmado del 2026-11-09 es un artefacto histórico. La [guía final](../../docs/ENTREGA_FINAL.md) explica compilación y firma. Los informes registran versión y límites de la validación física.
