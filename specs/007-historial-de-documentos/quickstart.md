# Historial por cuenta — reconstrucción actual

Verificación automática del 2026-11-17; no sustituye pruebas Android físicas ni la
revisión del PR #221. Desde la raíz:

```bash
cd frontend
flutter test --no-pub test/services/history_store_test.dart test/state/history_flow_test.dart test/presentation/history_screen_test.dart test/presentation/organize_test.dart test/services/storage_test.dart
```

La entrega vigente requiere cuentas del servidor y HTTPS; las cuentas locales se
conservan para desarrollo explícito. Consulte [requisitos actuales](../../docs/REQUISITOS_ACTUALES.md).
Ambos modos guardan el historial en el teléfono, separado por ID de cuenta; no se
sincroniza con el servidor. Guarda texto/título/fecha/formatos de hasta 50 documentos,
no fotos ni los archivos DOCX/PDF. Cerrar sesión conserva el historial; eliminar la
cuenta lo borra en este teléfono. El borrador y temporales se limpian al cerrar sesión.
Los archivos exportados por el usuario permanecen en el lugar elegido.

Para la prueba manual con datos sintéticos: exporte un documento, ábralo desde Mis
documentos, corríjalo y guárdelo en ambos formatos; debe actualizar la misma entrada.
Busque por título/texto ignorando mayúsculas/tildes. Renombre (1..60 puntos Unicode),
cancele un cambio y confirme otro: no debe cambiar el texto ni archivos anteriores;
al volver a exportar se conserva el nombre. Pruebe cancelar Eliminar/Borrar todo antes
de confirmar sobre documentos de prueba. Cambie de cuenta y compruebe aislamiento.
Repita nombres y botones de 48 dp al 100/200 % y TalkBack. **Recorrido físico pendiente**.

[Resultados actuales, procedencia y límites](../../docs/VERIFICACION_RECONSTRUCCION_LUIS.md).
