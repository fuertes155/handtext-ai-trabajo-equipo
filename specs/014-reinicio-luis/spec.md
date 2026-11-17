# 014 · Reinicio de tareas de Luis

Solicitud de Samuel del 2026-11-17: retirar sus implementaciones correspondientes al reparto de Luis Miguel David Campo (`LUISDACA`) en el mismo repositorio y en la rama existente. Se limita a las 72 tareas de `TAREAS/luis-miguel.md`; no se crean otra rama ni otro repositorio.

## Comportamiento de esta fase

- Los módulos y regiones correspondientes se dejan pendientes mediante contratos y marcadores explícitos, no implementaciones simuladas ni pruebas que aprueben por omisión.
- Se conservan las interfaces, los modelos compartidos y las dependencias de otros aportes. El reparto de una tarea no atribuye la autoría del código previo a Luis.
- Las rutas privadas sin su integración de autenticación deben rechazar las solicitudes. No se sustituyen por acceso anónimo. Las compilaciones release quedan bloqueadas mientras dure el reinicio.
- Las 72 tareas vuelven a pendientes para que Luis trabaje con su cuenta, pruebe su implementación y solicite revisión real. Las pruebas compartidas se conservan como contratos de aceptación.
- La base anterior se conserva en Git (`098d4f6`). No se reescriben autores ni fechas, no se modifica `main`, no se despliega la API y no se instala o desinstala nada del teléfono.

## Non-Goals

- Borrar el historial, las evidencias históricas o los aportes de Juan y Samuel ajenos al alcance.
- Presentar este estado como aplicación lista, reemplazar el APK publicado o certificar las pruebas anteriores para el código incompleto.
- Crear commits con la identidad de Luis o aceptar su invitación en su nombre.

## Aceptación de la preparación

Debe existir un inventario de regiones retiradas y de contratos conservados; los archivos deben seguir siendo sintácticamente válidos. Un intento de usar autorización pendiente debe fallar cerrado y la versión release debe bloquearse. Las pruebas funcionales completas no se anuncian aprobadas hasta que Luis termine. La invitación se envía a `LUISDACA` con escritura; la aceptación y los aportes quedan a su cargo.
