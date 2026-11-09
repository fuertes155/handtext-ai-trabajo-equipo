# HandText AI · Trabajo en equipo

El repositorio organiza una nueva fase de HandText AI en 218 tareas, cuatro sprints y un prompt por integrante. La rama `samuel/implementacion` incorpora la app Android y la API local con las dependencias compartidas citadas en su historial.

Consulta la [guía local](specs/001-handtext-mvp/quickstart.md), el [mapa del código](MAPA_DEL_CODIGO.md) y el [recorrido de ajustes y accesibilidad](docs/PRUEBA_DE_INTERFAZ.md).

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
