> Documento heredado de [documento_word](https://github.com/Juan-Miguel-Her-Del/documento_word/tree/a0b7dd315ebad9cbf4decf0fddcc7968d49d655b). En esta fase prevalecen [los requisitos actuales](../../docs/REQUISITOS_ACTUALES.md). Los estados de tareas de origen son históricos y no sustituyen las issues de handtext.

> Esta guía conserva instrucciones históricas; usa [quickstart.md](quickstart.md) para la app actual.

# Quickstart: organizar documentos

**Plan**: [plan.md](plan.md) | **Decisiones**: [research.md](research.md)

## 1. Pruebas

```powershell
cd frontend
flutter test test/services/file_name_test.dart test/presentation/organize_test.dart
```

## 2. Probarlo en el teléfono

- **Nombre del archivo:** al exportar, el diálogo para guardar propone el título del
  documento (su primera línea), por ejemplo «Apuntes de biología.docx». Se puede cambiar
  ahí mismo.
- **Copiar:** en el editor, menú (⋮) > **Copiar todo el texto**. Luego se pega en
  WhatsApp, un correo o cualquier app.
- **Buscar:** en Mis documentos, escribir en el campo de búsqueda. «celula» encuentra
  «célula»; mayúsculas y tildes no importan.
- **Renombrar:** en Mis documentos, el lápiz de cada documento. El nombre nuevo se
  conserva aunque el documento se vuelva a guardar, y los archivos ya guardados no
  cambian.
