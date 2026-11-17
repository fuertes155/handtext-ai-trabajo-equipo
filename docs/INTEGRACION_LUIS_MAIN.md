# Integración de Luis con main

Solicitud posterior de Luis: integrar el PR #221 en main y actualizar los cuatro
milestones. Esta instrucción sustituye la indicación anterior de conservar el PR
en borrador sin fusión. No autoriza cerrar issues con criterios pendientes.

## Resolución del cambio de devolución

Main contenía e8f1289, que retiraba once tareas para devolverlas a Luis. La rama
reconstruida contenía 3515c4d y sus implementaciones verificadas. Se integra main
mediante un commit de merge en la misma rama, sin rebase, squash ni reescritura.

Se conservan puntualmente las versiones reconstruidas de manifiesto principal,
Gradle, reglas de extracción y ocho suites retiradas. No se aplica el parche
histórico ni se restaura masivamente una versión anterior. La prueba compartida
de varias páginas y las reglas de extracción, que Git habría eliminado por no
tener cambios respecto al ancestro, también se conservan explícitamente.

Settings_test.dart combina los seis casos actuales de T401/T406 con los siete
casos de main sobre consejos, idioma y licencia Poppins. Se mantienen exactamente
sus expectativas. El manifiesto debug incorpora la configuración explícita de
HTTP de main; release conserva HTTPS obligatorio y firma propia. README y el
seguimiento mantienen el estado actual de las 72 tareas. Los informes y el
manifiesto histórico añadidos en e8f1289 se conservan como procedencia.

## Comprobación de la integración

- **358 pruebas Flutter aprobadas sin omisiones** contra la API y PostgreSQL
  temporales (351 anteriores más siete compartidas de main).
- `dart format --output=none --set-exit-if-changed lib test integration_test`:
  126 archivos correctos. `flutter analyze --no-pub`: sin incidencias.
- `XDG_CONFIG_HOME=/tmp/handtext-flutter-config flutter build apk --debug --no-pub`:
  compilación correcta en 10,1 s, con los manifiestos integrados.
- El backend, Gradle release y el código Dart de producción no cambian respecto
  a 3515c4d. Sus resultados anteriores (218 backend, siete checks, diez políticas
  Gradle y recorrido Android ampliado de 30,3 s) conservan ese alcance; no se
  presentan como ejecuciones nuevas de esta integración.

APK debug de integración:
`/home/luisdaca/Escritorio/handtext-ai-trabajo-equipo/frontend/build/verification/handtext-debug-integracion-main-20261117.apk`

SHA-256: `4e3ca369881c07cb662a5aa65d76159134459703448ba88b3a2878687a0e8710`.

Comandos desde frontend con la API temporal iniciada según la guía:

```bash
HANDTEXT_API_URL=http://127.0.0.1:8765/ flutter test --no-pub --reporter expanded
dart format --output=none --set-exit-if-changed lib test integration_test
flutter analyze --no-pub
XDG_CONFIG_HOME=/tmp/handtext-flutter-config flutter build apk --debug --no-pub
```

## Milestones

Se corrigen sus descripciones desactualizadas con el recuento real de GitHub y
el avance técnico de Luis, sin modificar asignaciones ni estados ajenos:

| Hito | Cerradas / total | Abiertas | Verificadas técnicamente de Luis |
| --- | ---: | ---: | ---: |
| Sprint 1 | 41/61 (67,21 %) | 20 | 20/20 |
| Sprint 2 | 44/65 (67,69 %) | 21 | 21/21 |
| Sprint 3 | 35/52 (67,31 %) | 17 | 15/17 |
| Sprint 4 | 25/40 (62,50 %) | 15 | 12/14 |

Estos porcentajes cuentan issues cerradas; no sustituyen el avance técnico.
Las 72 issues de Luis siguen abiertas por la revisión de otro integrante exigida
en sus criterios. T409/T411 conservan además firma/entrega pendientes; T908/T1008,
recorridos de dispositivo/PIN. La fusión solicitada no inventa esa aprobación.

La API temporal se apaga al finalizar y elimina solo su base sintética.
No se ejecutan comandos de despliegue ni migraciones en producción.
[Estado de las 72 tareas](ESTADO_TAREAS_LUIS.md) · [Guía reproducible](QUICKSTART_RECONSTRUCCION_LUIS.md).
