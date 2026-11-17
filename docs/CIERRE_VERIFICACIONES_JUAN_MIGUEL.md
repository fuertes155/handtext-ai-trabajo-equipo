# Cierre de verificaciones de Juan Miguel

## Alcance y fuente de los resultados

Juan Miguel solicita cerrar las ocho issues restantes. Ante la pregunta sobre los
recorridos de recorte, compartir, ajustes y TalkBack con letra al 200 %, confirma que
comprobaron todo y que funcionó correctamente. Esa confirmación es la fuente de los
resultados manuales; no se presenta como una ejecución o escucha directa del asistente.
La publicación directa en main fue solicitada por Juan Miguel.

Se distingue el cierre con evidencia automatizada o confirmación del responsable del
cierre administrativo. No se certifica que una prueba pendiente haya sido realizada.

## Comprobaciones automatizadas ejecutadas

Código verificado: commit `14fe835b042bef01792d9ed9ecda74c18bb53389`.
Esta ronda no modifica código de la aplicación; añade el registro de resultados.

| Comando | Resultado observado |
| --- | --- |
| Backend: `python -m ruff check .` | Correcto |
| Backend: `python -m ruff format --check .` | 50 archivos ya formateados |
| Backend: `python -m pytest -q -ra --tb=short --basetemp <ruta-nueva-en-.venv>` | 160 aprobadas en 36,36 s, incluido PostgreSQL temporal |
| Frontend: `dart format --output=none --set-exit-if-changed lib test integration_test` | 113 archivos, cero cambios |
| Frontend: `flutter analyze --no-pub` | Seis avisos informativos preexistentes por APIs obsoletas, sin errores ni advertencias; salida 1 por esos avisos |
| Frontend: `flutter test --no-pub --reporter expanded` | 285 pruebas aprobadas, 18 s |

Las 285 pruebas son las suites de `frontend/test/`; no se afirma una ejecución nueva
de `integration_test/` en Android. Las muestras JPEG deliberadamente incompletas
producen mensajes de decodificación durante las pruebas, que terminan aprobadas.
Los seis avisos de análisis se conservan y no se describen como un análisis sin avisos.

## Comprobaciones de la sesión Android

Se compiló e instaló la variante de depuración `HandText AI USB` en el teléfono ARM64.
La versión anterior conserva sus datos. La variante USB tiene identificador separado
`com.handtextai.team.usb.debug`, URL de API por USB y token local de documentos.
Los cambios usados solo para compilar esa variante se revirtieron en el repositorio.

La API funciona en `127.0.0.1:8001`. Se verificaron desde Android la conexión HTTP y una
exportación autenticada con Word real. Google Cloud Vision reconoció correctamente el
texto esperado de una imagen sintética a través de FastAPI. Esto demuestra una llamada
real al proveedor; no sustituye la medición sobre diez hojas manuscritas reales.
La clave de Google queda en la configuración local, fuera de Git, y no se incluye aquí.

Las cuentas de la app son locales al dispositivo según los requisitos vigentes.
PostgreSQL se verificó mediante las pruebas de contrato de servidor en una base temporal;
no se afirma que la app utilice PostgreSQL para registrarse ni ingresar.

## Disposición de las ocho issues

| Tarea | Tipo de cierre | Evidencia y límite |
| --- | --- | --- |
| T056 / #56 | Completada: ejecución y registro de verificaciones | Formato, análisis y pruebas registrados arriba; se conservan los seis avisos informativos. |
| T138 / #99 | Completada con confirmación del responsable | APK y API comprobados; PostgreSQL temporal comprobado; Juan Miguel confirma el recorrido en el celular. |
| T145 / #106 | Completada con confirmación del responsable | Juan Miguel confirma revisión manual de interfaz; documentación y pruebas automatizadas disponibles. |
| T219 / #126 | Completada con confirmación del responsable | Recorte y compartir confirmados por Juan Miguel; suites automatizadas aprobadas. |
| T413 / #151 | Completada con confirmación del responsable | Recorrido de ajustes confirmado por Juan Miguel y pruebas automatizadas aprobadas. |
| T514 / #165 | Completada con confirmación del responsable | Juan Miguel confirma los recorridos consultados, incluido TalkBack y letra al 200 %; widgets comprobados en ambos tamaños. No se adjunta grabación de voz. |
| T061 / #61 | Administrativo: no planificada en este cierre | No se aportaron diez hojas autorizadas, transcripciones ni informe CER/WER. No se acredita esa medición. |
| T410 / #148 | Administrativo: no planificada en este cierre | No se encontraron la clave de distribución prevista ni key.properties en este checkout. El APK es de depuración; no acredita firma de distribución. |

T061 y T410 se cierran a petición del responsable para terminar el seguimiento,
sin marcarlas como trabajo completado. La clave de Google Cloud Vision y la clave de
firma Android tienen funciones diferentes. Ninguna credencial se publica en GitHub.

La procedencia y la implementación compartida con Samuel permanecen descritas en
[el informe de integración](INTEGRACION_JUAN_MIGUEL.md). El cierre no acredita autoría
retroactiva sobre código existente ni una revisión formal de pull request inexistente.
