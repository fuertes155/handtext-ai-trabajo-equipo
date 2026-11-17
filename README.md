# HandText AI · Trabajo en equipo

> **Reconstrucción actual · 2026-11-17.** Código de Luis repuesto y suites actuales registradas en [el informe](docs/VERIFICACION_RECONSTRUCCION_LUIS.md). [Comandos reproducibles](docs/QUICKSTART_RECONSTRUCCION_LUIS.md). Hay APK debug; release exige clave propia, cuentas del servidor y HTTPS. PR #221 en borrador; revisión del equipo y verificaciones nativas pendientes. Los APK y resultados del 16 de noviembre son históricos y no validan estos cambios.

HandText AI es una aplicación Flutter Android que escanea hojas, reconoce texto, permite corregirlo y exporta Word/PDF. La entrega conecta el APK por HTTPS con FastAPI y PostgreSQL en Railway. RapidOCR procesa las imágenes con modelos ONNX en el servidor.

## Entrega histórica del 16 de noviembre

- [Instalación, despliegue y compilación](docs/ENTREGA_FINAL.md).
- [Verificaciones y límites conocidos](docs/VERIFICACION_ENTREGA.md).
- [Pruebas del APK en Samsung y evidencias](docs/PRUEBAS_DISPOSITIVO_ENTREGA.md).
- [Especificación del despliegue](specs/013-entrega-railway/spec.md).
- [Presentación para la exposición](docs/presentacion/HandText-AI-entrega-final.pptx).
- [Descargar APK firmado y materiales de preentrega](https://github.com/fuertes155/handtext-ai-trabajo-equipo/releases/tag/entrega-20261116).
- [Salud de la API](https://handtext-api-production.up.railway.app/health).

La compilación de entrega usa `HOSTED_ACCOUNTS=true` y requiere crear una cuenta del servidor. Las cuentas de la prueba local permanecen en el teléfono. Historial y borradores se conservan por cuenta en el dispositivo. El APK entregado requiere Android ARM64 e Internet para cuentas, reconocimiento y exportación.

El proyecto organiza 218 tareas en cuatro sprints. Los informes históricos conservan los resultados y la procedencia de cada integración.

Consulta la [guía local](specs/001-handtext-mvp/quickstart.md), el [mapa del código](MAPA_DEL_CODIGO.md) y el [recorrido de ajustes y accesibilidad](docs/PRUEBA_DE_INTERFAZ.md).

La guía local incluye el [reconocimiento en el computador](specs/001-handtext-mvp/quickstart.md#reconocimiento-en-el-computador) y la [configuración de OpenAI](specs/001-handtext-mvp/quickstart.md#reconocimiento-con-openai).

## Antecedente

Se parte de los requisitos y del reparto de tareas del [proyecto anterior](https://github.com/Juan-Miguel-Her-Del/documento_word/tree/356ff82297820bccfac9f5049ea020c9f40f0001). Su historial permanece intacto. El código o documentación que se reutilice debe citar su procedencia en el pull request. Las nuevas tareas no acreditan autoría retroactiva sobre el trabajo anterior.

## Integrantes

| Integrante | GitHub | Tareas | Prompt | Lista |
| --- | --- | ---: | --- | --- |
| Samuel | fuertes155 | 73 | [Abrir](PROMPTS/samuel.md) | [Tareas](TAREAS/samuel.md) |
| Juan Miguel | Juan-Miguel-Her-Del | 73 | [Abrir](PROMPTS/juan-miguel.md) | [Tareas](TAREAS/juan-miguel.md) |
| Luis Miguel | LUISDACA | 72 | [Abrir](PROMPTS/luis-miguel.md) | [Tareas](TAREAS/luis-miguel.md) |

Los prompts indican al asistente que primero inspeccione y proponga una tarea. Debe esperar la elección del integrante antes de implementar. No ejecutan todas las tareas de una vez.

## Empezar

1. Aceptar la invitación a este repositorio e iniciar sesión con la cuenta propia mediante GitHub Desktop o `gh auth login`.
2. Clonar `https://github.com/fuertes155/handtext-ai-trabajo-equipo.git`.
3. Leer [requisitos actuales](docs/REQUISITOS_ACTUALES.md), [flujo de equipo](docs/FLUJO_EQUIPO.md) y [sprints](docs/SPRINTS.md).
4. Abrir el prompt propio, pegarlo en el asistente y elegir una tarea desbloqueada.
5. Crear una rama, realizar el aporte, probarlo y abrir un pull request hacia `main`.

El commit inicial solo contiene planificación preparada con asistencia de IA. Cada integrante debe revisar su trabajo antes de confirmarlo. Las issues son la fuente de estado actual; las listas Markdown son el índice inicial.

## Enlaces

- [Todas las issues](https://github.com/fuertes155/handtext-ai-trabajo-equipo/issues)
- [Cuatro sprints](https://github.com/fuertes155/handtext-ai-trabajo-equipo/milestones)
- [Cómo completar las asignaciones tras aceptar invitaciones](docs/FLUJO_EQUIPO.md#asignaciones-pendientes)


## Integración de Juan Miguel

Las pruebas, herramientas, recursos Android y guías trasladados del proyecto anterior
se describen con su procedencia, relación con las 73 tareas y resultados en el
[informe de integración](docs/INTEGRACION_JUAN_MIGUEL.md). Se conserva la implementación
actual de Samuel. Las tareas que requieren muestras reales, dispositivo o revisión
del equipo permanecen pendientes.

## Guías por funcionalidad

- [Cuentas locales e identidad visual](specs/002-cuentas-de-usuario/quickstart.md)
- [Palabras dudosas, recorte y compartir](specs/003-revision-recorte-compartir/quickstart.md)
- [Documentos de varias páginas](specs/004-varias-paginas/quickstart.md)
- [Ajustes, licencias y compilación](specs/005-ajustes-y-version-final/quickstart.md)
- [Consejos y accesibilidad](specs/006-primer-uso-y-accesibilidad/quickstart.md)
- [Historial por cuenta](specs/007-historial-de-documentos/quickstart.md)
- [Español e inglés](specs/008-idioma-ingles/quickstart.md)
- [Escáner de hojas](specs/009-escaner-de-documentos/quickstart.md)
- [Nombres, búsqueda y organización](specs/010-organizar-documentos/quickstart.md)
- [Bloqueo con verificación del dispositivo](specs/011-bloqueo-con-huella/quickstart.md)


El [registro final de verificaciones](docs/CIERRE_VERIFICACIONES_JUAN_MIGUEL.md)
distingue las pruebas ejecutadas, los recorridos confirmados por Juan Miguel y las
dos tareas cerradas administrativamente sin acreditar su validación.


## Integración completa del proyecto anterior

Se incorporaron los archivos y pruebas restantes conservando las mejoras actuales.
El [informe completo](docs/INTEGRACION_COMPLETA_DOCUMENTO_WORD.md) explica las fusiones,
la procedencia, el inventario y las verificaciones. Las guías originales y el despliegue
Render se conservan como referencia; para la entrega usa la guía final y para desarrollo las guías locales.

- [Conciliación de issues y pendientes tras la integración completa](docs/CONCILIACION_ISSUES_INTEGRACION.md).

## Historial y organización — reconstrucción 2026-11-17

«Mis documentos» conserva hasta 50 textos por cuenta en este teléfono. Buscar filtra
por título/contenido sin tildes ni mayúsculas; Renombrar conserva el texto y se respeta
al exportar de nuevo. Eliminar/Borrar todo piden confirmación y no borran archivos
exportados. Cerrar sesión conserva el historial; eliminar la cuenta lo borra.
Copiar todo usa el texto actual: otras apps pueden leerlo desde el portapapeles.
[Pruebas y recorrido pendiente](specs/007-historial-de-documentos/quickstart.md).
