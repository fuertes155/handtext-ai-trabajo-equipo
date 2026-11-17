# Requisitos actuales

Actualizados el 2026-11-16. La solicitud de despliegue del 2026-11-09 autoriza la entrega descrita en la [especificación 013](../specs/013-entrega-railway/spec.md).

## Producto

Flutter Android permite escanear o elegir imágenes, reconocer hasta diez páginas, revisar texto y exportar Word/PDF. Incluye historial por cuenta, idiomas, accesibilidad y bloqueo del dispositivo.

## Entrega vigente

- Compilar con `HOSTED_ACCOUNTS=true` y una `API_BASE_URL` HTTPS explícita. Usar cuentas del servidor y PostgreSQL privado.
- Conservar la sesión segura por servidor y autenticar OCR/exportación mediante Bearer. Derivar contraseñas con Argon2id.
- Ejecutar RapidOCR con modelos ONNX fijados en Railway. Validar integridad y permisos de los modelos durante la construcción.
- Mantener borradores e historial por cuenta en el teléfono. Crear una cuenta del servidor al migrar desde la prueba local, conservando las cuentas locales anteriores.
- La calidad OCR depende de la imagen y la escritura. Medir CER con diez hojas autorizadas antes de acreditar la meta de precisión.

## Desarrollo local

- Mantener registro e ingreso sin red con LocalAuthApi y almacenamiento seguro del dispositivo.
- Inspeccionar procesos y puertos antes de arrancar la API en el PC. Conservar el flujo ADB y el lanzador de prueba.
- El token local de desarrollo exige configuración explícita, solo permite documentos desde bucle local y queda desactivado por defecto y en distribución.
- Configurar credenciales de proveedores externos exclusivamente en el backend por canales seguros.

## Datos y validación

- Conservar claves, tokens, keystores y datos personales fuera de Git. Usar hojas sintéticas o autorizadas.
- No borrar datos ni desinstalar aplicaciones sin permiso.
- Ejecutar pruebas, analizadores, compilación y comprobación de firma. Registrar fecha y alcance de cada resultado.
- Los recorridos de Samsung, TalkBack, biometría y guardado nativo requieren evidencia física.
- Mantener autoría real y revisión de aportes. Las issues y los informes distinguen resultados históricos de la entrega.

Consultar [ENTREGA_FINAL.md](ENTREGA_FINAL.md) y [VERIFICACION_ENTREGA.md](VERIFICACION_ENTREGA.md). Las especificaciones históricas se conservan y se amplían mediante 013.
