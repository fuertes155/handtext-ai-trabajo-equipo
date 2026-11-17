> Documento heredado de [documento_word](https://github.com/Juan-Miguel-Her-Del/documento_word/tree/a0b7dd315ebad9cbf4decf0fddcc7968d49d655b). En esta fase prevalecen [los requisitos actuales](../../docs/REQUISITOS_ACTUALES.md). Los estados de tareas de origen son históricos y no sustituyen las issues de handtext.

> Esta guía conserva instrucciones históricas; usa [quickstart.md](quickstart.md) para la app actual.

# Quickstart: escáner de documentos

**Plan**: [plan.md](plan.md) | **Decisiones**: [research.md](research.md)

## 1. Pruebas

```powershell
cd frontend
flutter test test/state/scanner_flow_test.dart
```

## 2. Probarlo en el teléfono

1. En el inicio, tocar **Escanear hoja**.
2. La primera vez, el teléfono puede descargar el escáner de Google (necesita internet y
   los servicios de Google Play).
3. Apuntar a la hoja: el escáner marca los bordes y la captura. Antes de aceptar se
   puede ajustar el recorte, girar y elegir un filtro.
4. Para varias hojas, seguir escaneando antes de aceptar. Llegan a la vista previa en
   orden, como páginas.
5. En la vista previa, **Agregar página > Escanear** agrega más hojas al final.

Si el teléfono no tiene el escáner, la app lo dice y ofrece **Tomar fotografía**.

## 3. Privacidad

El escáner trabaja en el teléfono. La app copia cada hoja a su carpeta privada y borra
enseguida los archivos del escáner. La imagen solo sale del teléfono con la autorización
de siempre, al reconocer el texto.
