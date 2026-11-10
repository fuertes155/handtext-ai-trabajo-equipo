> Referencia importada de [documento_word](https://github.com/Juan-Miguel-Her-Del/documento_word/tree/a0b7dd315ebad9cbf4decf0fddcc7968d49d655b). Para el funcionamiento actual prevalecen [los requisitos de handtext](../../../docs/REQUISITOS_ACTUALES.md). Las marcas de tareas son el registro histórico del origen.

# Revisión de la especificación: Varias páginas por documento

**Documento**: [spec.md](../spec.md)
**Revisado**: 2026-10-29

Una casilla marcada indica conformidad documental; no indica aprobación del responsable.

## Formato y alcance

- [x] CHK401 Sigue el formato de 001 a 003: «Features principales», módulos numerados, viñetas y reglas críticas en negrita.
- [x] CHK402 Declara qué Non-Goals reemplaza (001: varias páginas; 003: recortar varias páginas) y conserva las demás reglas.
- [x] CHK403 Tiene Non-Goals explícitos (saltos de página, más de 10 páginas, paralelo, detección de bordes).
- [x] CHK404 No incluye código, endpoints, tablas ni tecnologías.

## Trazabilidad con la constitución

- [x] CHK405 Cada historia tiene prioridad, prueba independiente y escenarios Dado/Cuando/Entonces.
- [x] CHK406 Los criterios de éxito son medibles.
- [x] CHK407 Respeta la constitución §3:
  - una autorización que dice cuántas imágenes se envían (Privacidad);
  - copias borradas como en 001 (Retención);
  - un fallo no borra lo reconocido (Integridad).
- [ ] CHK408 Validar los supuestos 1 a 4 con el responsable del proyecto.
- [ ] CHK409 Confirmar con la profesora la ampliación del alcance: la constitución §1 y los Non-Goals de 001 exigen una especificación aprobada para procesar varias páginas.
