# Plan de reinicio

1. Usar la rama actual y registrar la base `098d4f6`, ya publicada, como referencia recuperable.
2. Sustituir cuerpos de implementación asignados a Luis por `UnimplementedError` / `NotImplementedError`, conservando firmas compartidas. Separar las regiones de archivos mixtos con análisis AST y ediciones verificadas.
3. Retirar las pruebas exclusivas de su alcance y conservar las pruebas compartidas como aceptación, con el estado incompleto documentado.
4. Mantener acceso privado cerrado y bloquear compilación release mientras las implementaciones estén pendientes. Conservar licencias y restricciones de seguridad.
5. Restablecer el índice de 72 tareas, documentar las dependencias y comprobar sintaxis, formato, inventario y protección del acceso pendiente.
6. Publicar los cambios en la misma rama y dejar el PR como borrador. Enviar invitación de escritura a `LUISDACA`, sin suplantar su identidad ni modificar producción.

El inventario y los pasos de Luis se documentan en `docs/REINICIO_LUIS.md`. La aplicación instalada, la API vigente y las evidencias de la entrega anterior son antecedentes y no se alteran en esta fase.
