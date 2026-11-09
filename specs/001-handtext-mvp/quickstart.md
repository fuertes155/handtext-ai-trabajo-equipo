# Guía de ejecución y validación del MVP

## Aplicación Android

Desde `frontend/`, ejecuta `flutter pub get`, `flutter analyze` y `flutter test`. Con el emulador iniciado, comprueba su identificador con `flutter devices` y ejecuta `flutter run -d <identificador>`. El proyecto inicial muestra la pantalla de ejemplo hasta integrar el flujo de documentos.

## API local

Esta sección se ejecuta cuando estén integradas las dependencias del backend y `app.main`. Desde `backend/` en PowerShell:

```powershell
py -3.12 -m venv .venv
.\.venv\Scripts\python.exe -m pip install -r requirements-dev.txt
.\.venv\Scripts\python.exe -m ruff check .
.\.venv\Scripts\python.exe -m pytest
Get-NetTCPConnection -State Listen -LocalPort 8001 -ErrorAction SilentlyContinue
.\.venv\Scripts\python.exe -m uvicorn app.main:app --host 127.0.0.1 --port 8001
```

Si el puerto está ocupado, identifica el servicio antes de iniciar otra instancia. El emulador Android alcanza el equipo por `http://10.0.2.2:8001`. Cuando se integre el cliente de documentos, configúralo con `API_BASE_URL`. Si se habilita el acceso local de desarrollo, suministra el mismo secreto mediante la configuración local de ambos procesos. Ese modo solo autoriza documentos y debe quedar desactivado en distribución.

Verifica registro, ingreso y cierre de sesión locales. Prueba que la API rechace reconocimiento y exportación sin autorización y que el texto exportado en Word y PDF coincida con la última revisión. Usa imágenes sintéticas o autorizadas y conserva el original. Anota qué pudo ejecutarse y qué quedó bloqueado.

## Google Cloud Vision y medición

En un proyecto de Google Cloud autorizado, habilita Cloud Vision y configura una clave restringida para esa API según la política del proyecto. Suminístrala al proceso de FastAPI mediante `HANDTEXT_GOOGLE_VISION_API_KEY`. Consulta la [documentación de Cloud Vision](https://cloud.google.com/vision/docs/setup). La clave se configura fuera de Git y permanece en el equipo que ejecuta el backend.

Usa al menos diez hojas autorizadas con sus transcripciones de referencia. Antes de medir, fija el mismo criterio de normalización para referencias y resultados. Compara el texto de OCR sin corregir y registra por hoja las sustituciones, omisiones e inserciones de caracteres. Calcula el CER global dividiendo la suma de errores entre la suma de caracteres de referencia. Contrasta el resultado con la meta del MVP de 10 %. Registra el corpus utilizado, la fecha, los fallos del proveedor y las condiciones de captura. Si falta la clave o el corpus, registra la medición como pendiente.
