# Pruebas del APK final en Android

## Versión y evidencia

Artefacto: `HandText-AI-entrega-20261116-arm64.apk`, versión `1.0.0+1`, paquete `com.handtextai.team`. SHA-256: `62DFCC853BBC62BEE6971E08121E242A2F0256552CBF89D48B4A8E3E299655C1`. Usa cuentas del servidor y la API HTTPS de Railway. Véase [instalación](ENTREGA_FINAL.md).

Se registra lo observado en este binario. Las pruebas automatizadas y el recorrido de una variante debug son evidencias diferentes. Un caso solo se aprueba después de observar su resultado; si falta acceso, soporte o una muestra, se marca bloqueado o no aplicable y se explica por qué.

## Preparación

- Conectar el Samsung por ADB y mantenerlo desbloqueado. Registrar modelo, versión de Android y APK, sin publicar número de serie, IP privada, cuentas personales ni credenciales.
- Comprobar espacio y firma antes de instalar mediante actualización. Si hay conflicto de firma o falta de espacio, detener la instalación y registrar el mensaje. No desinstalar, borrar datos ni sustituir otra variante.
- Usar una cuenta exclusiva de prueba del servidor y una hoja sin datos personales: «PRUEBA DE ESCANEO / Esta hoja es un ejemplo». No guardar contraseña ni token en este registro.
- Mantener los documentos existentes. Las capturas y exportaciones de evidencia deben contener solo datos de ejemplo. No recopilar logcat completo, almacenamiento privado ni pantallas personales.
- Las pruebas sin Internet deben conservar el acceso ADB por USB. Restaurar la conectividad y los ajustes de accesibilidad después de verificarlos.

## Casos representativos

Los resultados observados se registran en la sección de ejecución; esta tabla define el procedimiento y no acredita por sí sola que se haya ejecutado.

| Caso | Acción | Resultado esperado / evidencia |
| --- | --- | --- |
| D01 | Instalar el APK firmado y abrirlo | Identificador y versión correctos; no se pierden datos. Registrar mensaje de instalación y apertura. |
| D02 | Registrar cuenta de prueba con consentimiento | Cuenta creada e ingreso al área de documentos. No se usa un secreto de desarrollo. |
| D03 | Enviar formulario inválido y un ingreso con contraseña incorrecta | Validación comprensible, sin entrar a una cuenta ni mostrar detalles internos. No repetir intentos hasta bloquear una cuenta existente. |
| D04 | Cerrar y volver a abrir la app con sesión | La sesión propia se recupera sin pedir la contraseña de nuevo, mientras siga vigente. |
| D05 | Escanear una hoja física de ejemplo | Escáner real; foto en Vista previa con datos de imagen. Registrar una captura sin información personal. |
| D06 | Cancelar el escáner al agregar otra hoja | No se agregan páginas ni se pierden las páginas o correcciones existentes. |
| D07 | Escanear dos páginas y cambiar su orden | Orden visible correcto y texto reconocido por páginas; documentar la operación. |
| D08 | Cancelar el consentimiento y después autorizar OCR | Cancelar no envía ni inicia OCR; al autorizar aparece procesamiento y resultado o un error comprensible. La interfaz por sí sola no acredita ausencia de tráfico: indicar si hubo observación de red. |
| D09 | Reconocer la hoja y corregir una palabra | Resultado editable; registrar duración de esa solicitud y una captura del ejemplo. No inferir precisión manuscrita a partir de una sola hoja. |
| D10 | Exportar Word y abrirlo con una app disponible | Selector Android de destino; DOCX válido con la corrección más reciente. Si no hay visor, registrar la limitación y comprobar el archivo desde el PC. |
| D11 | Exportar PDF y abrirlo | PDF válido y texto correcto; cancelar el selector conserva el texto y no anuncia un guardado exitoso. |
| D12 | Intentar exportar texto vacío en un documento de prueba | Se impide exportar o aparece un aviso; no se anuncia éxito ni se añade una entrada incorrecta. Conservar aparte el ejemplo anterior. |
| D13 | Provocar una operación sin Internet y recuperar la conexión | Mensaje de conexión o tiempo de espera, sin perder correcciones; reintento correcto al recuperar Internet. Registrar mensaje y tiempo real. |
| D14 | Buscar, renombrar, copiar y reabrir el documento de ejemplo | Documento correcto, texto conservado y título actualizado. Registrar también retorno al historial. |
| D15 | Cerrar sesión y volver a ingresar con la misma cuenta | Se solicita ingreso; la cuenta recupera su historial propio. No se elimina la cuenta ni sus documentos. |
| D16 | Cambiar tema, idioma y tamaño; reiniciar | Preferencias conservadas. Recorrido en inglés al 100 % y 200 %, incluidos diálogos nativos; registrar cada pantalla o texto incorrecto. |
| D17 | Recorrer con TalkBack | Etiquetas, foco y acciones comprensibles; revisión auditiva por la persona. La jerarquía de accesibilidad sola no acredita cómo se escuchan los anuncios. |
| D18 | Activar bloqueo, cancelar, verificar y volver tras más de un minuto | Cancelar no revela documentos; verificación válida conserva borrador. Registrar PIN u otro método sin mostrarlo; huella solo si el dispositivo la admite y ya está configurada. |
| D19 | Medir apertura en frío e historial | Anotar dispositivo, método, cantidad real de documentos y tiempos. La medida en Samsung es complementaria: SC-504 y SC-705 se definen para el emulador Android 16; no sustituir uno por otro ni acreditar 50 documentos con una muestra menor. |

No se borra la cuenta, el historial ni datos de la aplicación como parte de este protocolo. La evaluación CER de diez hojas se registra por separado conforme a SC-010.

## Ejecución de esta ronda

Ronda del 2026-11-16, hora de Bogotá. La autorización USB resolvió el bloqueo inicial. **Finalizada con los resultados y límites siguientes** en Samsung SM-A055M, Android 15. No se declara ejecución satisfactoria de todos los casos.

| Comprobación de acceso | Observación real |
| --- | --- |
| `adb devices -l` | Ningún dispositivo conectado/autorizado |
| Descubrimiento Wi-Fi por mDNS | Apareció un anuncio de conexión del Samsung |
| Conectar al servicio anunciado | Rechazo de conexión, error 10061; no quedó un dispositivo ADB disponible |
| Acción del usuario | Indicó que conectará por USB y avisará al estar listo |
| Conexión USB posterior | ADB detectó el Samsung como `unauthorized`; falta aceptar la autorización en Android |
| Autorización posterior | Samsung autorizado por USB; se pudo instalar y manejar la app |
| Almacenamiento previo a instalar | 36 524 280 KiB disponibles en `/data` |
| Instalación | `adb install -r` terminó con `Success`; paquete release `com.handtextai.team`, versión 1.0.0, sin flag DEBUGGABLE |
| Variante previa | `com.handtextai.team.debug` permanece instalada; no se desinstaló ni borró su información |

Los rechazos de conexión iniciales describen el acceso de pruebas; no son fallos observados dentro de HandText. La instalación release se efectuó después de obtener autorización. No se desinstalaron aplicaciones ni se borraron datos. Se añadieron únicamente una imagen de ejemplo y las exportaciones de prueba en carpetas nuevas.

### Resultados observados hasta este punto

| Caso | Estado y resultado |
| --- | --- |
| D01 | Aprobado: instalación y apertura del APK firmado. |
| D02 | Aprobado: registro real desde el teléfono; bienvenida «Hola, PruebaEntrega» y consejos de primer uso. La identidad es sintética; credenciales fuera de Git. |
| D03 | Aprobado: nombre vacío y consentimiento ausente se rechazaron; un ingreso con contraseña incorrecta mostró «Correo o contraseña incorrectos». |
| D04 | Aprobado: detener y volver a abrir la app conservó la sesión del servidor. |
| D05 | Parcial: ML Kit abrió y devolvió JPEG a Vista previa. Las capturas aportadas enfocaban el chat y se excluyeron del OCR y de la evidencia publicada. El OCR controlado de D09 usa la imagen PNG de ejemplo desde galería; no se acredita con ella un escaneo de papel. |
| D06 | Aprobado para conservación del documento: abrir un escáner nuevo y cerrarlo volvió al inicio; regresar al editor conservó las dos páginas reconocidas, 27 palabras y 166 caracteres. |
| D07 | Aprobado con imágenes sintéticas: dos imágenes seleccionadas, reordenadas con «Move page forward» y reconocidas. Se comprobó el nuevo orden, PRUEBA antes de SEGUNDA PAGINA, en el editor y en el XML del Word guardado de 36 709 bytes. No acredita dos hojas físicas. La primera copia al PC se intentó antes de terminar la escritura y estaba incompleta; se esperó a finalizar y se recuperó y validó el archivo completo. |
| D08 | Aprobado en UI: «No autorizar» mantuvo la imagen y mostró «No se envió la imagen». Al autorizar se inició el reconocimiento. No hubo captura de tráfico; esta observación no demuestra por sí sola ausencia de solicitudes. |
| D09 | Aprobado con muestra tipográfica: cuatro líneas esperadas en el editor. 9,92 s desde tocar autorización hasta observar el editor mediante ADB, incluyendo inspecciones de UI; no equivale a tiempo del servidor. Se añadió «CORREGIDO». |
| D10 | Guardado y contenido aprobados: DOCX de 36 675 bytes en carpeta nueva del teléfono, ZIP/XML válido y corrección presente al recuperarlo al PC. Android no encontró visor DOCX instalado; apertura local en Word pendiente por esa limitación. |
| D11 | Aprobado: PDF de 9 679 bytes guardado y texto corregido validado con pypdf. Samsung Notes mostró visualmente las cuatro líneas, incluida la corrección. La captura ADB del visor Drive apareció en blanco aunque su árbol accesible leía el texto; se registra esa limitación sin atribuirla al generador. PDFium y Poppler del PC también dibujan el archivo correctamente. Cancelar un guardado posterior mostró «No se guardó el archivo. Su texto se conserva». |
| D12 | Aprobado: elegir Word con texto vacío mostró «No se puede exportar un texto vacío…». El botón permite elegir formato y después valida; no se exige que esté deshabilitado. Las cuatro líneas se restauraron exactamente desde la copia de prueba. |
| D13 | Aprobado: Wi-Fi y datos desactivados temporalmente con ADB por USB; aviso «No se pudo conectar con el servidor…» y texto intacto. Se restauraron los valores originales en un bloque de limpieza. Al reintentar, la API volvió a entregar el archivo al selector Android; se canceló su guardado. |
| D14 | Aprobado: búsqueda sin coincidencias, búsqueda «prueba», renombrado «HandText Verificado», acción copiar con aviso y reapertura con texto corregido. El historial registra una entrada con Word y PDF; cancelar no añadió otra. No se leyó el contenido global del portapapeles. |
| D15 | Aprobado: cierre, ingreso fallido con contraseña incorrecta, ingreso correcto y recuperación de la única entrada «HandText Verificado» del historial. |
| D16 | Parcial: idioma English, tema Light y letra Extra large se conservaron tras detener y abrir la app; también se recuperó el borrador de 166 caracteres sin traducirlo. Editor comprobado con escala del sistema al 200 %. Menú, inicio, exportación y aviso de cancelación propios en inglés. El selector nativo mantiene «Descargas», «Carpeta nueva» y «GUARDAR» en el idioma español de Android. No se acredita SC-802 ni el recorrido completo al 200 %; requiere revisión del alcance de los controles nativos. |
| D17 | Pendiente: TalkBack Samsung se activó temporalmente y apareció un permiso del sistema para llamadas. No se concedió desde la prueba ni se confirmó la escucha de HandText. El usuario pidió desactivarlo; se restauraron y comprobaron los ajustes originales. No se repetirá sin nueva indicación. |
| D18 | Limitado por configuración: interruptor de bloqueo deshabilitado, con aviso para configurar huella, rostro o bloqueo de pantalla. El usuario indicó dejar la validación pendiente; no se crea ni modifica un PIN. Android anuncia rostro y no anuncia la característica de huella; no se acredita huella física en este equipo. |
| D19 | Parcial: `am start -W` informó aperturas COLD de 1 242, 628, 1 200 y 1 251 ms en Samsung. Mide apertura de Activity; no mide carga completa ni sustituye los umbrales del emulador Android 16 o el historial de 50 documentos. |

Para mantener la interfaz estable se fijó temporalmente orientación vertical. También se cambió la escala de texto del sistema al 200 % y se activó TalkBack para estas pruebas. Al finalizar se restauraron y comprobaron contra las copias originales la rotación, escala, accesibilidad y conectividad. TalkBack quedó apagado. Las preferencias de la app volvieron a Español, tema Automático y letra Normal; se comprobaron las opciones seleccionadas. La app se abrió nuevamente con la sesión de prueba. No se cambió el PIN ni el rostro del teléfono.

Los documentos de ejemplo quedaron en `Download/HandText-Pruebas-Entrega-20261116/`: `HandText-Prueba-Word-20261116.docx`, `HandText-Prueba-PDF-20261116.pdf` y `HandText-Dos-Paginas-20261116.docx`. No contienen información personal y no se eliminarán para completar la prueba. Las [evidencias publicables](evidencias/android-20261116/README.md) incluyen capturas, copias verificadas y SHA-256.

Para cada ejecución añadir: caso, fecha, versión, pasos realizados, resultado observado, aprobado/falló/bloqueado/no aplicable y evidencia autorizada. Ante un fallo de la app, registrar reproducción y corrección, y repetir el caso antes de aprobarlo. Los resultados se resumen en [verificación de entrega](VERIFICACION_ENTREGA.md).
