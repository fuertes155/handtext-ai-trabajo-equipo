# Entrega de tareas a Luis Miguel

Fecha de la devolución: 17 de noviembre de 2026.

## Alcance acordado

Juan Miguel autoriza devolver las partes que integró y que corresponden a once tareas asignadas a Luis Miguel. El estado anterior es [66b4d22](https://github.com/fuertes155/handtext-ai-trabajo-equipo/commit/66b4d22ebeac725442f4c72c7be941717f14e489). La devolución se registra como un commit nuevo para conservar la trazabilidad del trabajo del equipo.

Se retiran ocho archivos de pruebas, cinco casos dentro de settings_test.dart y la configuración Android incorporada para T016 y T409. El archivo compartido conserva siete casos de consejos, idioma y licencias. Los tres archivos Android se restauran a c30a04b y se retira data_extraction_rules.xml.

Los manifiestos y Gradle quedan en una fase intermedia. La privacidad de extracción de datos, el permiso de Internet para la variante principal y la configuración de firma/HTTP de distribución deben reintegrarse y verificarse antes de entregar un nuevo APK. Los APK debug generados antes de esta devolución corresponden al estado anterior del código.

## Once tareas devueltas

| Issue | Tarea | Trabajo que Luis debe revisar e integrar |
| --- | --- | --- |
| [#16](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/16) | T016 | Reintegrar los manifiestos y las reglas de privacidad Android retirados en esta devolución. |
| [#22](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/22) | T022 | Revisar y reintegrar image_rules_test.dart. |
| [#45](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/45) | T045 | Revisar y reintegrar camera_flow_test.dart. |
| [#80](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/80) | T119 | Revisar y reintegrar account_rules_test.dart y auth_api_client_test.dart. El controlador de sesión y sus pruebas existentes forman parte de la base. |
| [#100](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/100) | T139 | Revisar y reintegrar aurora_contrast_test.dart. |
| [#113](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/113) | T206 | Revisar y reintegrar uncertain_ranges_test.dart. |
| [#131](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/131) | T305 | Revisar y reintegrar pages_flow_test.dart. |
| [#139](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/139) | T401 | Reintegrar cuatro casos de persistencia y controlador de ajustes en settings_test.dart. |
| [#144](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/144) | T406 | Reintegrar la comprobación de versión contra pubspec.yaml en settings_test.dart y revisar las pruebas de pantalla existentes. |
| [#147](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/147) | T409 | Reintegrar la configuración Gradle de firma y HTTP por tipo de compilación, junto con los manifiestos correspondientes. |
| [#154](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/154) | T503 | Revisar y reintegrar tips_screen_test.dart. |

## Cinco pendientes anteriores de Luis

| Issue | Tarea | Próximo paso |
| --- | --- | --- |
| [#138](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/138) | T312 | Registrar el recorrido Android de varias páginas. Existe un registro histórico parcial en specs/004-varias-paginas/tasks.md. |
| [#149](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/149) | T411 | Configurar la firma local y verificar APK release por procesador, instalación y arranque. El registro anterior de specs/005 no acredita esta versión. |
| [#186](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/186) | T708 | Revisar la evidencia y el cierre de inglés. language_test.dart ya contiene el recorrido automatizado al 100 % y al 200 % y las comprobaciones de fallos y títulos. El recorrido manual adicional que se exigió en la conciliación anterior fue una interpretación del asistente. |
| [#206](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/206) | T908 | Registrar el recorrido Android de copiar, buscar, renombrar y el nombre propuesto al guardar. |
| [#214](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues/214) | T1008 | Registrar el recorrido de bloqueo Android con PIN/huella y regreso después de un minuto. |

La issue #198 del escáner corresponde a Samuel y sigue abierta. El conjunto del repositorio queda con 17 issues abiertas.

## Estado de los cuatro sprints

Los porcentajes cuentan issues cerradas. Incluyen los dos cierres administrativos anteriores de Juan Miguel, cuyo motivo sigue siendo no planificado.

| Sprint | Cerradas | Abiertas | Porcentaje |
| --- | ---: | ---: | ---: |
| 1 | 58 | 3 | 95.08 % |
| 2 | 62 | 3 | 95.38 % |
| 3 | 45 | 7 | 86.54 % |
| 4 | 36 | 4 | 90.00 % |

## Material de reintegración

La carpeta del escritorio Entrega Luis Miguel HandText 2026-11-17 contiene un parche reversible, un inventario de los trece archivos afectados y las instrucciones. El parche se obtiene únicamente de archivos versionados del estado anterior de handtext. Las claves, tokens, datos del teléfono y la firma local quedan fuera del paquete.

Luis debe revisar lo reutilizado, ejecutar las pruebas pertinentes y registrar con su cuenta el trabajo que efectivamente realice. La reintegración cita documento_word y los commits 14fe835 y 5dd92ff como procedencia.

El parche restaura los trece archivos funcionales al estado anterior de esta devolución. Después de su revisión debe actualizar el registro de tareas y las issues que cumplan los criterios.

## Comprobaciones de la devolución

| Comprobación | Resultado observado |
| --- | --- |
| Pruebas Flutter restantes | 253 aprobadas en 10 s; nueve contratos externos omitidos al no configurar su API |
| Archivo compartido settings_test.dart | Siete casos conservados; formato correcto |
| Analizador Flutter | Seis avisos informativos de obsolescencia, sin errores ni advertencias; salida 1 por esos avisos |
| APK debug x86_64 | Compilación correcta en 41,1 s |
| Parche de Luis | git apply --check correcto y restauración exacta de los trece archivos comprobada en un índice temporal |

La primera pasada del analizador detectó una importación que quedó sin uso al retirar los cinco casos. Se retiró y el análisis posterior quedó sin advertencias. Las pruebas de contratos externos y el recorrido Android de integración no se ejecutaron en esta devolución.


Los informes anteriores describen las ejecuciones de sus commits originales. El [inventario original](INTEGRACION_COMPLETA_MANIFIESTO.json) identifica esta devolución mediante su campo de seguimiento.
