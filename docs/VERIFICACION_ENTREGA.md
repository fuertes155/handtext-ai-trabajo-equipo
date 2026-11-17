# Verificación de entrega · 2026-11-16

Resultados ejecutados después de integrar `origin/main` (`66b4d22`) en la rama `entrega/railway-documentacion-20261116`. El commit de integración es `aecb5d1`; los commits siguientes consolidan documentación y presentación. Los informes anteriores conservan su fecha y no sustituyen esta verificación.

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

## Artefactos

- [Guía de instalación y compilación](ENTREGA_FINAL.md): nombre, ubicación y SHA-256 del APK firmado del 2026-11-16.
- [Diapositivas editables](presentacion/HandText-AI-entrega-final.pptx): 16 diapositivas con notas, funciones, arquitectura y recorrido desde el formulario de ingreso hasta las migraciones PostgreSQL.
- [Especificación vigente del despliegue](../specs/013-entrega-railway/spec.md), con plan y pendientes verificables.

## Pendientes que requieren evidencia externa

1. Instalar y recorrer este APK firmado en el Samsung desde Internet. ADB no detectó dispositivos en esta sesión; no se instaló, desinstaló ni borró información del teléfono. Las confirmaciones anteriores del escáner en depuración son antecedentes, no validación de este binario.
2. Registrar guardado nativo, reapertura, biometría, TalkBack y tiempos de inicio en el dispositivo. La cobertura automatizada no sustituye estas comprobaciones.
3. Medir CER con diez hojas manuscritas autorizadas y sus transcripciones; conservar consentimiento y muestras fuera del repositorio si contienen información personal.
4. Obtener revisión real del PR por otro integrante, registrar sus aportes y resolver observaciones. Las asignaciones de issues no demuestran autoría; no se fabrican commits ni revisiones.
5. Confirmar acceso de la profesora al repositorio privado y que cada integrante cargue los materiales en Campus UCC.

## Relación con los criterios de evaluación

| Área | Evidencia disponible / acción pendiente |
| --- | --- |
| Desarrollo guiado por especificaciones | Constitución, `specs/001` a `specs/013`, planes y tareas; la spec 013 documenta el cambio autorizado a despliegue |
| Aplicación funcional | APK ARM64 firmado y recorrido HTTP real; falta demostración del APK final en el teléfono |
| Calidad del código | Analizadores, formateador y pruebas automatizadas; configuración HTTPS y desarrollo desactivado en release |
| Trabajo colaborativo en Git | Historial y procedencia preservados, rama y PR; revisión y aportes deben corresponder a personas reales |
| Pruebas y validación | Resultados arriba; medición manuscrita y recorridos físicos pendientes |
| Documentación y demostración | README, guía final, este registro y presentación con notas; carga en Campus a cargo de cada integrante |

No se cierran tareas manuales solo por compilar ni se declara cumplimiento total de la rúbrica con estas pruebas.
