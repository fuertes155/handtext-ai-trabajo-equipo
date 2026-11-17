# Integración completa desde documento_word

> Estado al 17 de noviembre de 2026. Once tareas se devuelven a Luis Miguel para su revisión e integración. El [informe de entrega](ENTREGA_LUIS_MIGUEL.md) describe el estado actual y los pendientes. Los resultados anteriores corresponden al código previo a esa devolución.

## Procedencia

Se completa la integración solicitada por Juan Miguel desde
[documento_word, commit a0b7dd3](https://github.com/Juan-Miguel-Her-Del/documento_word/tree/a0b7dd315ebad9cbf4decf0fddcc7968d49d655b).
La base de destino es `c30a04b48f0d6569c6b931e44d822d95bf6db410`.
Se conserva el historial y el trabajo integrado por Samuel y Juan Miguel; importar
material del proyecto anterior no cambia su autoría original.

El [inventario completo](INTEGRACION_COMPLETA_MANIFIESTO.json) relaciona cada archivo
versionado del origen con su ubicación en handtext y distingue igualdad, adaptación
y material de referencia. Todos los archivos versionados de backend, frontend y db
del origen existen en el destino; las diferencias son fusiones intencionales.

## Código y pruebas incorporados

- Siete suites Flutter: contrato HTTP real, consejos de primer uso, reglas de cuentas,
  cliente HTTP de cuentas, reglas de imágenes, rangos dudosos y contraste de Aurora.
- Siete casos adicionales de preparación de imágenes: conservación de bytes, tamaños,
  orientación EXIF, metadatos, transparencia y archivos truncados. Se conservan también
  los dos casos anteriores de handtext, incluidos bytearray e imagen inválida.
- Permiso de Internet en el manifiesto principal, nombre visible HandText AI y reglas
  que excluyen datos de copias en la nube y transferencia entre dispositivos.
- Configuración Android de firma desde key.properties local, URL explícita para release,
  HTTPS por omisión y HTTP solo en depuración o cuando se pide para una demostración.
  Se mantienen el identificador com.handtextai.team, el sufijo .debug y la biometría.
- Ajuste de memoria Gradle y compilación Kotlin en el proceso principal heredados del
  origen, conservando la corrección Windows kotlin.incremental=false. Los scripts Bash mantienen finales de línea LF mediante .gitattributes.
- Especificaciones, contratos, planes, investigación, listas históricas y herramientas
  Spec Kit versionadas en el origen. No se instalan herramientas globales ni se ejecutan
  esos flujos por importarlos.

## Fusiones que conservan el comportamiento actual

Las cuentas de la app siguen siendo locales con Argon2id. Se conserva el cliente remoto
de cuentas para sus contratos de servidor y el servidor PostgreSQL opcional, sin volver
al ingreso remoto de la app antigua. El contrato importado se adapta para esperar
backendAuthenticationRequired cuando falta autorización del backend: no se interpreta
ese caso como vencimiento de una cuenta local.

Se conservan el token de documentos optativo restringido a loopback y depuración, la
lectura HTTP que limita memoria antes de extender el cuerpo, los fallos y textos locales,
la separación de sesiones, la carga asíncrona del historial, los temas AppCompat y la
prueba Android ampliada con cincuenta documentos. También se conserva la corrección
que deja SC-010 pendiente si se miden menos de diez hojas.

Las versiones actuales de Flutter y sus dependencias permanecen. Las diferencias de
formato o documentación no obligan a sustituir código más reciente por el del origen.

## Documentación y referencias históricas

Las guías quickstart.md adaptadas para la fase actual permanecen activas. Las originales
se guardan como quickstart.origen.md. Se completan los textos de las especificaciones
005 y 007 conservando sus aclaraciones actuales. Las marcas de tareas en documentos
importados son históricas y no sustituyen las issues de este repositorio.

El README, el mapa y render.yaml originales se conservan bajo docs/referencia/. El
Blueprint de Render es material de referencia; la API de esta fase sigue siendo local
y esta integración no ejecuta un despliegue. Los requisitos actuales prevalecen sobre
las instrucciones históricas de autenticación remota o puerto 8000.

No se copian la carpeta .git, entornos, compilaciones, claves de Google, tokens,
key.properties ni almacenes de firma. La configuración de la sesión USB permanece fuera
del repositorio y su compilador local se adapta al manifiesto integrado.

## Verificación observada

| Comprobación | Resultado |
| --- | --- |
| Ruff y formato Python | Correctos; 50 archivos formateados |
| Backend completo | 167 pruebas aprobadas en 13,43 s, con PostgreSQL temporal |
| Flutter, suites generales | 352 pruebas aprobadas en 17 s; los nueve contratos externos se omiten sin HANDTEXT_API_URL |
| Contratos HTTP ejecutados aparte | Nueve aprobados contra FastAPI y PostgreSQL temporal reales en un puerto aislado; Word y PDF reales |
| Total Flutter comprobado | 361 casos aprobados entre ambas ejecuciones |
| Analizador Flutter | Siete avisos informativos de deprecación, sin errores ni advertencias; salida 1 por esos avisos |
| Formato Dart completo | 120 archivos, cero cambios |
| APK debug x86_64 | Compilación correcta en 65,3 s; manifiesto compilado comprobado |
| APK USB debug ARM64 | Compilación correcta en 62,8 s; identidad USB, arquitectura y privacidad comprobadas |
| Guardas de URL release | Cuatro casos correctos: URL ausente y HTTP ordinario rechazados; HTTPS y HTTP de demostración explícito aceptados |

El backend de contrato no usa Google ni la base de datos del usuario. Se elimina su
cuenta sintética y se detienen el servidor y PostgreSQL temporal al finalizar.
La API del celular en 8001 no se detiene ni se reemplaza durante estas pruebas.

La primera ejecución del contrato importado aprobó ocho casos y detectó la diferencia
entre falta de autorización del backend y sesión vencida. Tras adaptar la expectativa
al contrato vigente, los nueve casos pasaron. No se cambió producción para eludir la
comprobación de autorización.

Esta integración no acredita una firma de distribución configurada ni una nueva
medición de diez manuscritos; incorpora su código y configuración sin publicar claves.
Los resultados y cierres anteriores mantienen su alcance histórico.


Los APK generados se conservan localmente, fuera de Git, como
`frontend/build/app/outputs/flutter-apk/handtext-x86_64-debug.apk` y
`frontend/build/app/outputs/flutter-apk/handtext-usb-arm64-debug.apk`.
La comprobación de la variante USB compila con parámetros privados locales; los
archivos del repositorio se restauran al terminar y no se reinstala la app del celular.
Los dos servidores temporales de contrato y sus bases PostgreSQL se detuvieron al
finalizar. Los cambios documentados abarcan 140 archivos, incluido el inventario.
