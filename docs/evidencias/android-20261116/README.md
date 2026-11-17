# Evidencia Android · 16 de noviembre de 2026

Capturas originales del APK release `com.handtextai.team` en Samsung SM-A055M, Android 15, y archivos exportados desde ese teléfono. El [registro de pruebas](../../PRUEBAS_DISPOSITIVO_ENTREGA.md) explica versión, pasos, resultados y límites.

Solo se incluyen textos sintéticos sin datos personales. No se publican credenciales de prueba, identificadores únicos del dispositivo, IP privadas, capturas del chat ni listados de archivos personales. Los PNG se copiaron sin modificar sus píxeles; no son pantallas recreadas.

| Archivo | Qué muestra |
| --- | --- |
| [vista-previa.png](vista-previa.png) | Imagen de ejemplo importada desde la galería; no acredita captura de papel |
| [texto-reconocido.png](texto-reconocido.png) | Cuatro líneas recibidas por OCR y editor disponible |
| [word-guardado.png](word-guardado.png) | Confirmación de guardado y texto corregido |
| [pdf-guardado.png](pdf-guardado.png) | Confirmación de guardado del PDF |
| [pdf-abierto-samsung.png](pdf-abierto-samsung.png) | Lectura visual correcta del PDF en Samsung Notes, incluido «CORREGIDO» |
| [error-texto-vacio.png](error-texto-vacio.png) | Rechazo de exportación vacía; teclado visible y aviso desplazable |
| [error-sin-conexion.png](error-sin-conexion.png) | Fallo de red sin pérdida de las correcciones; teclado visible |
| [historial-renombrado.png](historial-renombrado.png) | Búsqueda y título renombrado |
| [editor-dos-paginas.png](editor-dos-paginas.png) | Resultado de las dos imágenes, en el orden seleccionado |
| [paginas-reordenadas.png](paginas-reordenadas.png) | Dos imágenes después de cambiar su orden mediante la flecha |
| [editor-reordenado.png](editor-reordenado.png) | OCR que respeta el nuevo orden: PRUEBA antes de SEGUNDA PAGINA |
| [editor-ingles-200.png](editor-ingles-200.png) | Editor en inglés, tema claro y escala del sistema al 200 %; documento sin traducir |
| [selector-nativo-idioma-android.png](selector-nativo-idioma-android.png) | Selector del sistema con controles en español mientras HandText está en inglés; limitación registrada |
| [HandText-Prueba-Word-20261116.docx](HandText-Prueba-Word-20261116.docx) | DOCX recuperado del teléfono; contiene la corrección «CORREGIDO» |
| [HandText-Prueba-PDF-20261116.pdf](HandText-Prueba-PDF-20261116.pdf) | PDF recuperado del teléfono, texto extraído y renderizado en PC |
| [HandText-Dos-Paginas-20261116.docx](HandText-Dos-Paginas-20261116.docx) | Word de las dos imágenes reordenadas, recuperado después de finalizar el guardado y validado en su XML |
| [pdf-render-pc.png](pdf-render-pc.png) | Renderización independiente mediante PDFium; no es una captura del Samsung |

[SHA256SUMS.txt](SHA256SUMS.txt) permite comprobar los bytes de estas evidencias. El hash del APK se conserva en la guía de entrega; el APK no forma parte de este directorio.

El permiso de llamadas que apareció al iniciar TalkBack no se concedió desde la prueba. TalkBack se desactivó a petición del usuario y se restauraron sus ajustes. El bloqueo queda pendiente por indicación del usuario. La precisión manuscrita y los objetivos de rendimiento del emulador no se acreditan con estas capturas.
