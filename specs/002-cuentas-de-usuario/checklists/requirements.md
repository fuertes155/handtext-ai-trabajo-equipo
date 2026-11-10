> Referencia importada de [documento_word](https://github.com/Juan-Miguel-Her-Del/documento_word/tree/a0b7dd315ebad9cbf4decf0fddcc7968d49d655b). Para el funcionamiento actual prevalecen [los requisitos de handtext](../../../docs/REQUISITOS_ACTUALES.md). Las marcas de tareas son el registro histórico del origen.

# Revisión de la especificación: Cuentas de usuario e identidad visual

**Documento**: [spec.md](../spec.md)
**Revisado**: 2026-10-27

Una casilla marcada indica conformidad documental; no indica aprobación del responsable.

## Formato y alcance

- [x] CHK201 Sigue el formato de 001: «Features principales», módulos numerados, viñetas y reglas críticas en negrita.
- [x] CHK202 Declara qué regla de 001 reemplaza (uso sin cuenta) y conserva las demás.
- [x] CHK203 Tiene Non-Goals explícitos (recuperación de contraseña, Google, perfil, historial).
- [x] CHK204 No incluye código, endpoints, tablas ni tecnologías.

## Trazabilidad con la constitución

- [x] CHK205 Cada historia tiene prioridad, prueba independiente y escenarios Dado/Cuando/Entonces.
- [x] CHK206 Los criterios de éxito son medibles.
- [x] CHK207 Respeta la constitución §3 (Acceso): toda operación se autentica en cada solicitud.
- [ ] CHK208 Validar los supuestos 1 a 6 con el responsable del proyecto.
- [ ] CHK209 Confirmar con la profesora el cambio de alcance: 001 excluía el inicio de sesión.

## Notas

- Las decisiones del 2026-10-27 (inicio de sesión real y estilo Aurora) están en la
  sección `Clarifications`.
- Los datos de la cuenta (nombre y correo) son datos personales: el registro pide su
  autorización expresa.
