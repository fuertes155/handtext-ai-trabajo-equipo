# Reinicio de las tareas de Luis Miguel David Campo

Solicitud del propietario: 2026-11-17. Cuenta prevista: `LUISDACA`.
Repositorio: `fuertes155/handtext-ai-trabajo-equipo`.
Rama existente: `entrega/railway-documentacion-20261116`. No se crea otra rama.

**Esta revisión está incompleta y no debe entregarse ni desplegarse.** Se retiran
implementaciones correspondientes al reparto de Luis para que pueda realizarlas
y verificarlas. Se conservan las firmas y las dependencias compartidas que necesita
el trabajo de Samuel y Juan. El reparto de tareas no demuestra quién escribió el
código anterior: no se reescribe el historial ni se atribuyen commits a Luis.

La referencia previa al retiro es `098d4f65abf359515b2663562953624bf6f9e8c8`.
Los APK, las pruebas del Samsung y la API de la entrega anterior son históricos.
Este cambio no modifica esa instalación, el servicio publicado, la base de datos,
las credenciales ni los archivos personales del teléfono.

## Qué se retira y dónde continuar

| Tareas | Implementación que Luis debe completar |
| --- | --- |
| T006 | `backend/app/errors.py`: catálogo y manejadores de errores. Los identificadores públicos se conservan como contrato. |
| T010 | `backend/tests/conftest.py`: OCR falso e imágenes sintéticas. Se conserva el arnés y la fixture PostgreSQL de tareas compartidas. |
| T012 | `frontend/lib/config/app_config.dart`: configuración de URL pendiente; límites y validación de seguridad compartidos conservados. |
| T032, T035, T038 | Reglas exportables en `backend/app/services/documents/text_rules.py`, reglas de imagen y cliente de documentos en `frontend/lib/services/`. |
| T042, T043, T126, T130, T134, T142 | Cuerpos de pantallas y widgets en `frontend/lib/presentation/`: bienvenida, cuentas, flujo, revisión, menú, avisos, consentimiento y animación. |
| T050, T051 | Fuente DejaVu retirada del directorio activo; licencia conservada. Generación PDF pendiente en `backend/app/services/documents/pdf_builder.py`. |
| T104, T108, T114 | Lectura de conexión en `backend/app/config.py`, migraciones y contraseñas/tokens del servidor. Las operaciones pendientes fallan explícitamente, sin autenticación ficticia. |
| T118, T205 | Guardas de documentos y conversión de palabras dudosas en `backend/app/api/recognitions.py` y `exports.py`. Acceso cerrado mediante `pending_luis.py`. |
| T124, T125 | Reglas de formularios y controlador de sesión en `frontend/lib/services/account_rules.dart` y `frontend/lib/state/auth_controller.dart`. |
| T201, T213, T216 | Dependencias `image_cropper`/`share_plus` y actividad uCrop retiradas; interfaz de recorte/restauración/compartir pendiente. El lockfile se actualiza. |
| T303, T803, T806 | Galería múltiple y su falso, conexión del escáner y acción ante fallo, en `image_source_service.dart`, `document_flow_controller.dart` y `test/support/fakes.dart`. |
| T404, T406, T505, T507, T511, T512 | Ajustes, enlaces iniciales, menú de cuenta, accesibilidad y desplazamiento del editor/selector. En archivos mixtos se conservan contratos y el resto del flujo. |
| T409 | Firma de entrega retirada de `frontend/android/app/build.gradle.kts`. No hay sustitución por firma debug. La release está bloqueada por `frontend/LUIS_PENDIENTE`. |
| T704, T1003, T1005 | Selección/persistencia de idioma y bloqueo, controlador, pantalla y alcance de bloqueo. Los modelos públicos conservan sus campos como contratos. |
| T902, T903, T906 | Nombre sugerido, copiar texto, buscar y renombrar historial. El listado, almacenamiento y medición del historial de otras tareas se conservan. |
| T1102 | Solo el paso de cerrar sesión, volver a entrar y recuperar el documento en `frontend/integration_test/flujo_completo_test.dart`. |

Los cuerpos pendientes usan `UnimplementedError` o `NotImplementedError` con su ID.
Las firmas, los constructores de datos y la limpieza de recursos no equivalen a una
funcionalidad terminada. Los comentarios anteriores describen requisitos históricos.

## Pruebas y configuración compartidas

Las suites exclusivas T021, T022, T025, T045, T119 (reglas/cliente), T139, T206,
T210/T213/T216, T401/T406, T503 y T903/T906 se sustituyen por una entrada que falla
explícitamente hasta que Luis escriba sus pruebas. No se usan `skip` ni pruebas
vacías para aparentar aprobación. Sus versiones previas siguen disponibles en Git.

Las pruebas mixtas T026, T128, T205, T305, T604, T606, T610, T612 y T1006 se conservan
como base de aceptación porque también verifican trabajo ajeno. **Siguen pendientes
de revisión y ejecución por Luis**, y no acreditan una implementación nueva suya.
El arnés compartido de pruebas también se conserva, salvo las regiones retiradas.

T013/T110 conservan los temas y la paleta actuales porque T140 de Samuel los actualizó; Luis debe revisarlos e integrarlos sin retirar ese aporte. T905 de Juan (modelo y controlador de búsqueda/renombrado) se conserva: T906 retira solo su interfaz.

T002 conserva las versiones fijadas como dependencia de los servicios compartidos;
Luis debe revisarlas y justificar/verificar su selección. T016 conserva las reglas
de privacidad, permisos e integración Android compartidos: no se habilitan copias
de seguridad ni se elimina la restricción HTTPS de release. T201 sí retira los
paquetes y la actividad específicos de recorte y compartir.

T054, T612 y T1103 requieren actualizar el mapa y las guías una vez reconstruido el
código. Los quickstarts anteriores son referencia y **no son comandos de arranque
válidos para esta revisión incompleta**. T057, T137, T312, T411, T708, T908 y T1008
requieren nuevas compilaciones y/o recorridos reales; las mediciones antiguas no
cierran estas tareas del reinicio.

## Orden recomendado para Luis

1. Aceptar la invitación de GitHub y actualizar esta misma rama sin sobrescribir trabajo local.
2. Leer [las 72 tareas](../TAREAS/luis-miguel.md) y la [especificación](../specs/014-reinicio-luis/spec.md). Consultar el inventario de archivos de este documento.
3. Completar configuración, errores, reglas, seguridad y migraciones; mantener las guardas cerradas mientras la autenticación no esté lista.
4. Implementar servicios, temas, pantallas y las integraciones por sprint. Revisar los contratos conservados y coordinar cambios en archivos mixtos con el equipo.
5. Escribir las suites exclusivas y revisar las compartidas. Ejecutar pruebas, analizadores, compilación y recorridos del dispositivo que correspondan.
6. Registrar resultados reales por issue y cerrar solo las verificadas. Firmar cada commit con su identidad real. El avance del hito se calcula con las issues cerradas.
7. Retirar los bloqueos temporales únicamente cuando las implementaciones y la seguridad estén verificadas. No fusionar el PR de este reinicio mientras siga incompleto.

Para consultar un archivo previo sin restaurarlo ni reemplazar trabajo actual:

```powershell
git show 098d4f6:frontend/lib/services/handtext_api_client.dart
git show 098d4f6:backend/app/services/accounts/passwords.py
```

## Verificación de este retiro

Resultados del 2026-11-17 sobre esta revisión, distintos de la entrega histórica:

| Comprobación | Resultado |
| --- | --- |
| AST de los archivos modificados | 51 Dart y 13 Python con sintaxis válida; manifiesto XML válido. |
| Formato Dart y Ruff de Python modificado | Comprobados. Las regiones pendientes conservan firmas, tipos y errores explícitos. |
| Prueba aislada de seguridad del retiro | 8 comprobaciones aprobadas: routers reales rechazan ambos endpoints, sin token y con dos tokens sintéticos; marcador y bloqueo de release presentes. No se inicia `app.main`, no se llama al OCR ni a la base. |
| Gradle `:app:checkLuisReleaseReady --offline` | Falla deliberadamente con «release bloqueada» por `frontend/LUIS_PENDIENTE`. No se produce un APK de entrega. |
| `flutter pub get --offline` | Correcto; retiradas las dependencias específicas de T201 y actualizado el lockfile. |
| `flutter analyze --no-pub` | No aprobado: 342 incidencias (9 errores, 194 avisos y 139 informativos). Los errores de compilación se deben a recorte/compartir sin las dependencias pendientes de T201; los cuerpos vacíos dejan avisos de código no usado. |
| Colección de la suite backend | No disponible: se detiene con `NotImplementedError` de T104 al cargar la configuración pendiente. No se presenta la suite como aprobada. |
| Entrada de prueba Dart T022 | Falla explícitamente con `UnimplementedError`; no queda una suite vacía que aparente aprobación. |
| Aislamiento del reparto | Comprobados sin cambios TAREAS de Samuel/Juan, modelo/controlador T905 de Juan y autenticación local Argon2id de Samuel. T140 se conserva con un aviso explicativo. |
| Credenciales | Revisión de patrones sobre archivos de esta revisión sin valores de claves detectados; no se añaden configuraciones privadas. |

La sintaxis y el formato no demuestran que la app funcione. No se genera otro APK
ni se ejecutan migraciones o despliegues con el código incompleto. El inventario de
las 72 tareas y los archivos afectados está en [REINICIO_LUIS_INVENTARIO.json](REINICIO_LUIS_INVENTARIO.json).

La comprobación temporal de seguridad puede reproducirse desde la raíz, con las
dependencias de desarrollo del backend disponibles:

```powershell
python -m pytest --noconftest -q checks/test_reinicio_luis.py
```

Estas comprobaciones verifican el bloqueo del reinicio, no el comportamiento final.
Al terminar T118/T409, revisar y sustituir las comprobaciones temporales junto con
los marcadores por pruebas de autenticación y firma reales. La suite funcional
completa y los recorridos siguen pendientes.

## Acceso y seguimiento en GitHub

Las 72 issues del reparto se reabren, manteniendo sus hitos y etiquetas. Solo se
modifican las issues identificadas con `responsable:luis-miguel`. Las casillas
locales también están pendientes; el porcentaje de los hitos se ajusta en GitHub
según su estado real, sin eliminar el avance de otras tareas.

Durante la comprobación, GitHub ya confirmó a `LUISDACA` como colaborador con permiso
`write`. Por ello no se genera una invitación duplicada ni se solicita acceso a su
cuenta. Se asignan sus 72 issues a esa cuenta real. El PR #221 permanece en borrador
y sin fusión automática hasta que el equipo revise la implementación reconstruida.

## Reconstrucción en curso por LUISDACA

La implementación actual y sus resultados se registran en
[VERIFICACION_RECONSTRUCCION_LUIS.md](VERIFICACION_RECONSTRUCCION_LUIS.md).
Ese registro complementa el inventario y distingue verificación técnica de cierre
por revisión del equipo. Las comprobaciones del retiro anteriores siguen siendo
históricas; no certifican las implementaciones nuevas.
