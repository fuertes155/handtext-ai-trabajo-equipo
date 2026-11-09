# Guía de ejecución y validación del MVP

## Aplicación Android

Desde `frontend/`, ejecuta `flutter pub get`, `flutter analyze` y `flutter test`. Con el emulador iniciado, comprueba su identificador con `flutter devices` y ejecuta `flutter run -d <identificador>`. La bienvenida permite crear una cuenta y consultar los avisos de privacidad. Para comprobar ajustes y accesibilidad, sigue el [recorrido de interfaz](../../docs/PRUEBA_DE_INTERFAZ.md).

## API local

Desde `backend/` en PowerShell:

```powershell
py -3.12 -m venv .venv
.\.venv\Scripts\python.exe -m pip install -r requirements-dev.txt
.\.venv\Scripts\python.exe -m ruff check .
.\.venv\Scripts\python.exe -m pytest
Get-NetTCPConnection -State Listen -LocalPort 8001 -ErrorAction SilentlyContinue
.\.venv\Scripts\python.exe -m uvicorn app.main:app --host 127.0.0.1 --port 8001 --no-access-log
```

Si el puerto está ocupado, identifica el servicio antes de iniciar otra instancia. El emulador Android alcanza el equipo por `http://10.0.2.2:8001`. Puedes cambiar ese destino con `API_BASE_URL`. Si habilitas el acceso local de desarrollo, configura `HANDTEXT_LOCAL_DEV_TOKEN` en el entorno de FastAPI y `LOCAL_DEV_API_TOKEN` en el archivo local de parámetros de Flutter, con el mismo valor. Guarda el archivo fuera del repositorio y pásalo con `flutter run -d <identificador> --dart-define-from-file=<ruta-local>`. Ese modo solo autoriza documentos y queda desactivado en distribución.

Verifica registro, ingreso y cierre de sesión locales. Prueba que la API rechace reconocimiento y exportación sin autorización y que el texto exportado en Word y PDF coincida con la última revisión. Usa imágenes sintéticas o autorizadas y conserva el original. Anota qué pudo ejecutarse y qué quedó bloqueado.

## Google Cloud Vision y medición

En un proyecto de Google Cloud autorizado, habilita Cloud Vision y configura una clave restringida para esa API según la política del proyecto. Suminístrala al proceso de FastAPI mediante `HANDTEXT_GOOGLE_VISION_API_KEY`. Consulta la [documentación de Cloud Vision](https://cloud.google.com/vision/docs/setup). La clave se configura fuera de Git y permanece en el equipo que ejecuta el backend.

Usa al menos diez hojas autorizadas con sus transcripciones de referencia. Antes de medir, fija el mismo criterio de normalización para referencias y resultados. Compara el texto de OCR sin corregir y registra por hoja las sustituciones, omisiones e inserciones de caracteres. Calcula el CER global dividiendo la suma de errores entre la suma de caracteres de referencia. Contrasta el resultado con la meta del MVP de 10 %. Registra el corpus utilizado, la fecha, los fallos del proveedor y las condiciones de captura. Si falta la clave o el corpus, registra la medición como pendiente.


### Herramienta de medición (T058/T059)

Desde `backend/`, con la clave ya configurada por un canal local y una carpeta externa
con pares de archivos `hoja.png` y `hoja.txt` autorizados:

```powershell
.\.venv\Scripts\python.exe -m tools.measure_ocr_quality --help
.\.venv\Scripts\python.exe -m tools.measure_ocr_quality C:\ruta\hojas --acepto-enviar
```

La herramienta calcula CER, WER y la calidad de las marcas sin incluir el texto en el
informe. Solo envía imágenes tras `--acepto-enviar`. Con menos de diez hojas, SC-010
permanece pendiente aunque el CER sea cero. La integración usa muestras sintéticas;
la medición real T061 sigue pendiente. Conserva corpus, transcripciones y credenciales
fuera del repositorio.

Si Windows impide usar la carpeta temporal predeterminada de pytest, ejecuta las
pruebas con `--basetemp` apuntando a una ruta NUEVA dentro de `.venv`. No reutilices
una carpeta con datos: pytest administra el contenido de esa ruta.
