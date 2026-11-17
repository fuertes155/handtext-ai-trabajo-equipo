> Entrega 2026-11-16. La [especificación 013](../013-entrega-railway/spec.md) amplía este alcance para Railway, HTTPS y cuentas del servidor. Consultar la [guía final](../../docs/ENTREGA_FINAL.md). El modo local conserva su configuración de desarrollo.

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

### Reconocimiento desde un teléfono físico

La dirección `10.0.2.2` corresponde al emulador. Para el teléfono, autoriza la depuración, comprueba que `adb devices` lo muestre como `device` y ejecuta `adb -s <identificador> reverse tcp:8001 tcp:8001`. Mantén FastAPI escuchando en `127.0.0.1:8001` en el computador. En el archivo local de parámetros de Flutter, configura `API_BASE_URL` como `http://127.0.0.1:8001/` y el token de desarrollo que coincida con el del proceso de FastAPI. Ejecuta `flutter run -d <identificador> --dart-define-from-file=<ruta-local>` para instalar esa configuración. La captura y la vista previa pueden probarse antes de conectar la API.

Si no se puede abrir la conexión, la app avisa sin esperar el plazo de OCR. Si la API responde que el reconocimiento no está configurado, revisa la configuración del proveedor seleccionado en el servidor. El límite total de reconocimiento sigue siendo de 60 segundos.

## Reconocimiento en el computador

HandText puede reconocer texto con RapidOCR y modelos PP-OCRv6 en el PC. Este modo no necesita una clave ni consume créditos de API. Instala una vez las dependencias en un entorno virtual de Python 3.12 y descarga los tres archivos ONNX en una carpeta fuera de Git. El manifiesto de RapidOCR publica las rutas y los SHA-256 correspondientes. [Manifiesto de modelos de RapidOCR 3.10.0](https://github.com/RapidAI/RapidOCR/blob/v3.10.0/python/rapidocr/default_models.yaml)

- `PP-OCRv6_det_small.onnx`
- `ch_PP-LCNet_x0_25_textline_ori_cls_mobile.onnx`
- `PP-OCRv6_rec_medium.onnx`

Con el Samsung autorizado en ADB y las dependencias de Flutter preparadas mediante `flutter pub get`, ejecuta desde `backend/`:

```powershell
.\.venv\Scripts\python.exe -m pip install -r requirements-ocr-local.txt
.\.venv\Scripts\python.exe -m tools.run_local_ocr_phone --models 'C:\ruta\a\modelos'
```

Si ADB y Flutter no están en PATH, indica sus rutas con `--adb` y `--flutter`. El lanzador abre FastAPI en la dirección de bucle local del PC, configura el túnel ADB y actualiza la app de depuración con `adb install -r`. Mantén ese proceso abierto durante la prueba.

Para arrancar la API por separado, define `HANDTEXT_OCR_PROVIDER=local` y `HANDTEXT_LOCAL_OCR_MODELS` con la ruta de los modelos. Usa el comando de Uvicorn y la configuración de ADB indicados arriba. Las fotos se procesan en el PC y la calidad de la transcripción depende de la escritura y de la captura.

## Reconocimiento con OpenAI

En PowerShell, desde `backend/`, configura el proveedor y suministra la clave del proyecto de OpenAI mediante un campo oculto. Conserva en esta misma ventana el token local de desarrollo si lo necesitas para el teléfono.

```powershell
$env:HANDTEXT_OCR_PROVIDER = 'openai'
$ocrKey = Read-Host 'Clave de la API de OpenAI' -AsSecureString
$env:OPENAI_API_KEY = [System.Net.NetworkCredential]::new('', $ocrKey).Password
Remove-Variable ocrKey
try {
    .\.venv\Scripts\python.exe -m uvicorn app.main:app --host 127.0.0.1 --port 8001 --no-access-log
} finally {
    Remove-Item Env:OPENAI_API_KEY
}
```

El proyecto de OpenAI necesita acceso a la API. Las suscripciones ChatGPT Pro elegibles pueden activar créditos para una organización propia. [Créditos de la API para ChatGPT](https://developers.openai.com/api/docs/guides/chatgpt-api-credits)

HandText envía a Responses una copia de la imagen sin EXIF para transcribirla con GPT‑5.4 mini. Usa hojas de prueba sin datos personales. La clave solo se utiliza en el backend. [Imágenes en la API de OpenAI](https://developers.openai.com/api/docs/guides/images-vision?api-mode=responses)

## Google Cloud Vision

En un proyecto de Google Cloud autorizado, habilita Cloud Vision y configura una clave restringida para esa API según la política del proyecto. Suminístrala al proceso de FastAPI mediante `HANDTEXT_GOOGLE_VISION_API_KEY`. Consulta la [documentación de Cloud Vision](https://cloud.google.com/vision/docs/setup). La clave se configura fuera de Git y permanece en el equipo que ejecuta el backend.

## Medición del reconocimiento

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
