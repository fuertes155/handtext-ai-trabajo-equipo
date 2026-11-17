# Verificación de entrega · 2026-11-16

> **Referencia histórica:** las pruebas de esta entrega corresponden a la versión anterior al reinicio del 2026-11-17. No se transfieren al código incompleto actual. Ver [REINICIO_LUIS.md](REINICIO_LUIS.md).

Resultados ejecutados después de integrar `origin/main` (`66b4d22`) en la rama `entrega/railway-documentacion-20261116`. El commit de integración es `aecb5d1`; los commits siguientes consolidan documentación y presentación. Los informes anteriores conservan su fecha y no sustituyen esta verificación.

Cambios publicados en el [PR #221](https://github.com/fuertes155/handtext-ai-trabajo-equipo/pull/221), abierto hacia `main` para revisión del equipo. El [paquete de preentrega](https://github.com/fuertes155/handtext-ai-trabajo-equipo/releases/tag/entrega-20261116) contiene APK firmado, presentación y suma de comprobación.

## Pruebas automatizadas

| Comprobación | Resultado |
| --- | --- |
| Backend: `python -m pytest -q --tb=short` | 181 aprobadas, 15,29 s |
| Backend: `python -m ruff check app tools tests` | Sin errores |
| Backend: `python -m ruff format --check app tools tests` | 55 archivos ya formateados |
| Flutter: `flutter test --no-pub --reporter expanded` | 352 aprobadas, 9 omitidas, 43 s |
| Flutter: `dart analyze lib test` | Sin problemas |
| Flutter: `dart format --output=none --set-exit-if-changed lib test` | 119 archivos, 0 cambios |
| APK: `flutter build apk --release --target-platform android-arm64` con las definiciones de la guía final | Compilación correcta |
| APK: alineación `zipalign -c -P 16 4` y `apksigner verify --verbose` | Alineado; firmas v2 y v3 válidas |

Las nueve pruebas omitidas pertenecen a `frontend/test/integration/api_contract_test.dart`: necesitan `HANDTEXT_API_URL`. Se ejecutó por separado el recorrido HTTPS descrito abajo. Esta comprobación HTTP no equivale a ejecutar esas nueve pruebas Flutter ni a usar Android.

El backend se probó con las dependencias de `backend/requirements-dev.txt`. El APK usa `HOSTED_ACCOUNTS=true` y la URL HTTPS de la [guía final](ENTREGA_FINAL.md). La inspección con `aapt` confirmó `com.handtextai.team`, ARM64, permiso de Internet y ausencia de `application-debuggable`. Se firmó fuera de Git con la clave de distribución; no se entrega la firma de depuración del fallback Gradle.

`backend/tests/test_local_provider.py` añade seis escenarios del adaptador RapidOCR: configuración sin modelos, modelo ausente, transcripción, imagen sin texto, fallo de inferencia sin registrar datos privados y tiempo de espera. La dependencia de inferencia se sustituye en esas pruebas; el modelo real se comprobó en el servicio desplegado.

## Servicio desplegado

API: `https://handtext-api-production.up.railway.app/`. Prueba ejecutada desde el PC el 2026-11-16 con una cuenta temporal e imagen sintética sin datos personales.

| Paso | HTTP / comprobación |
| --- | --- |
| Salud | 200, `status=ok` |
| Exportación sin autorización | 401 |
| Reconocimiento con encabezado local de desarrollo sin sesión | 401 |
| Registro de cuenta temporal | 201 |
| Ingreso y consulta de sesión | 200 / 200 |
| OCR de «HANDTEXT OCR TEST / A SAMPLE DOCUMENT» | 200, 3,5 s; palabras esperadas presentes |
| Exportar Word | 200; ZIP DOCX válido y texto comprobado en `word/document.xml` |
| Exportar PDF | 200; texto comprobado con `pypdf` |
| Cerrar sesión y reutilizar el token revocado | 204 / 401 |
| Volver a ingresar | 200 |
| Retirar la cuenta temporal de esta prueba | 204 |

La resolución DNS del PC falló al consultar directamente el dominio. Para esta prueba se obtuvo su dirección A desde DNS público y se resolvió solo ese host dentro del proceso de verificación, conservando HTTPS y la validación del certificado. No se fijó una IP en la app ni en el repositorio. La prueba confirma el servicio y el contrato HTTP; la resolución normal desde la red del Samsung todavía debe verificarse.

RapidOCR del servidor ejecutó el reconocimiento sin llamar a Google Vision ni OpenAI. La imagen tipográfica sintética comprueba el funcionamiento del OCR, no su precisión manuscrita. Los 3,5 s corresponden a esa solicitud; no son una garantía de latencia para cualquier fotografía.

## Ronda posterior: APK firmado en Samsung

El 2026-11-16 se autorizó el Samsung SM-A055M por USB, con Android 15 y 36 524 280 KiB libres antes de instalar. El APK firmado de la guía final se instaló con `Success` y abrió correctamente. La variante debug anterior se conserva.

Se comprobaron desde la UI del APK: registro del servidor, validación de nombre y consentimiento, ingreso incorrecto y correcto, cierre de sesión, recuperación de sesión y de borrador, OCR de una y dos imágenes sintéticas, edición, guardado nativo Word/PDF, búsqueda, renombrado, copia y reapertura del historial. Se conservaron la sesión y las preferencias de idioma, tema y letra al reiniciar.

Errores comprobados: cancelar el consentimiento, cancelar el escáner, exportar texto vacío, cancelar el guardado y exportar sin Internet. El texto se conservó. Se restauró la conexión y la exportación volvió a responder. Word y PDF recuperados del teléfono incluyen la última corrección. No hay visor Word instalado; la validación del contenido DOCX se realizó en el PC. Samsung Notes mostró correctamente el PDF; su captura está incluida. La captura ADB del visor Drive apareció en blanco, pese a que el árbol accesible leía el texto. Se registra esa limitación del visor/captura por separado; PDFium y Poppler del PC también dibujan el archivo correctamente.

El OCR de una imagen tardó 9,92 s hasta observar el editor por ADB; ese dato incluye consultas a la UI. No equivale a latencia del servidor ni a precisión manuscrita. Se comprobó el editor en inglés al 200 %; no se declara completo el recorrido de todas las pantallas. TalkBack se desactivó a petición del usuario y el bloqueo se dejó pendiente por su indicación.

El [registro detallado](PRUEBAS_DISPOSITIVO_ENTREGA.md) y las [capturas y exportaciones sintéticas](evidencias/android-20261116/README.md) distinguen lo aprobado, parcial y pendiente. No se usaron documentos privados en el OCR ni se publican credenciales o listados personales.

## Artefactos

- [Guía de instalación y compilación](ENTREGA_FINAL.md): nombre, ubicación y SHA-256 del APK firmado del 2026-11-16.
- [Diapositivas editables](presentacion/HandText-AI-entrega-final.pptx): 16 diapositivas con notas, funciones, arquitectura y recorrido desde el formulario de ingreso hasta las migraciones PostgreSQL.
- [Especificación vigente del despliegue](../specs/013-entrega-railway/spec.md), con plan y pendientes verificables.

## Pendientes que requieren evidencia externa

El [protocolo Android y registro de acceso](PRUEBAS_DISPOSITIVO_ENTREGA.md) prepara los casos satisfactorios, errores y límites de esta ronda. Sus casos no se consideran ejecutados por estar documentados.

1. Completar el recorrido controlado de escaneo de papel: ML Kit abrió y devolvió JPEG, pero las capturas aportadas enfocaban el chat y se excluyeron del envío y las evidencias. Los casos OCR publicados usan imágenes sintéticas de galería. El cambio a otra red tampoco se probó en esta ronda.
2. Completar el recorrido completo en inglés. El selector del sistema conserva etiquetas en español con HandText en inglés; el alcance de los controles nativos requiere revisión. TalkBack y bloqueo quedan pendientes por indicación del usuario. Las aperturas de Activity de Samsung son medidas complementarias; no sustituyen SC-504 y SC-705 del emulador de referencia.
3. Medir CER con diez hojas manuscritas autorizadas y sus transcripciones; conservar consentimiento y muestras fuera del repositorio si contienen información personal.
4. Obtener revisión real del PR por otro integrante, registrar sus aportes y resolver observaciones. Las asignaciones de issues no demuestran autoría; no se fabrican commits ni revisiones.
5. Confirmar acceso de la profesora al repositorio privado y que cada integrante cargue los materiales en Campus UCC.

Las issues #138, #149, #186, #198, #206 y #214 siguen abiertas hasta conciliar la revisión del PR con sus criterios. Esta ronda aporta evidencia nueva de varias páginas y organización para #138 y #206. En #149 ya constan compilación, firma e instalación ARM64; siguen sin acreditarse otras arquitecturas ni los objetivos del emulador de referencia. No se atribuye el trabajo de esta ronda al responsable previsto de una issue: lo realizó Samuel con asistencia, conservando la procedencia de la implementación anterior.

## Relación con los criterios de evaluación

| Área | Evidencia disponible / acción pendiente |
| --- | --- |
| Desarrollo guiado por especificaciones | Constitución, `specs/001` a `specs/013`, planes y tareas; la spec 013 documenta el cambio autorizado a despliegue |
| Aplicación funcional | APK firmado instalado en Samsung: cuentas, OCR de galería y archivos guardados; escaneo de papel y limitaciones detalladas arriba |
| Calidad del código | Analizadores, formateador y pruebas automatizadas; configuración HTTPS y desarrollo desactivado en release |
| Trabajo colaborativo en Git | Historial y procedencia preservados, rama y PR; revisión y aportes deben corresponder a personas reales |
| Pruebas y validación | Resultados automatizados y registro Android; medición manuscrita, accesibilidad, bloqueo y recorridos indicados pendientes |
| Documentación y demostración | README, guía final, este registro y presentación con notas; carga en Campus a cargo de cada integrante |

No se cierran tareas manuales solo por compilar ni se declara cumplimiento total de la rúbrica con estas pruebas.
