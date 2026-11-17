# Reconstrucción de Luis — resultados actuales

Fecha: 2026-11-17. Rama: `entrega/railway-documentacion-20261116`.
Base inspeccionada y remota: `18f5fde24a8014bece01cdc82d6b29cea56f2756`.
Repositorio local: `/home/luisdaca/Escritorio/handtext-ai-trabajo-equipo`.

## Inspección y alcance

La copia se descargó en el Escritorio por indicación de Luis. No existían cambios
locales ni archivos AGENTS.md aplicables. Las 72 issues obtenidas con
`gh issue list --assignee LUISDACA --state all --limit 150` coinciden exactamente
con `TAREAS/luis-miguel.md`: 20/21/17/14 por sprint, abiertas y asignadas a LUISDACA.
PR #221 en borrador. Sin cambios posteriores al reinicio en el remoto inspeccionado.

CLI: `gh auth status` y `gh api user --jq .login` confirman LUISDACA. El conector
GitHub usa otra cuenta y no se utiliza para publicar. Configuración exclusivamente
local: Luis Miguel David Campo, `134025037+LUISDACA@users.noreply.github.com`.
La dirección noreply se compone del ID 134025037 y login confirmados por la API de
GitHub; no se usa un correo personal inferido ni se modifica la configuración global.

Los índices originales de specs 001/002 conservan casillas históricas aprobadas,
pero para este reinicio prevalece el seguimiento 014. Todas las issues requieren
revisión de otro integrante del PR; la aprobación técnica no permite cerrarlas
antes de esa revisión. No se modifican asignaciones o estados ajenos.

## Lote 1: T002, T006, T010, T104, T108, T114

| Tarea | Implementación o revisión actual | Verificación |
| --- | --- | --- |
| T002 · #2 | Versiones fijadas conservadas, instaladas y compatibles con Python 3.12.16. Documentada incompatibilidad del wheel pgserver con 3.14. | Instalación completa y `pip check` sin conflictos. |
| T006 · #6 | Catálogo completo, handlers de dominio/esquema/HTTP/inesperados, request_id y desafío Bearer en 401. Registros sin mensaje de excepciones ni variables locales. | Catálogo completo, validación sin eco y suites de dominio. |
| T010 · #10 | OCR falso conserva texto y marcas, registra llamadas y simula fallos; imágenes sintéticas con EXIF, JPEG reproducible y PNG gigante sin asignación masiva. | Pruebas de utilidades, validación y preparación de imágenes. |
| T104 · #65 | Lee conexión opcional del entorno; secretos excluidos de repr, límites y duraciones compartidos conservados. Token local optativo con mínimo de 32 caracteres. | Configuración explícita, valores ausentes, rechazo de token corto y privacidad. |
| T108 · #69 | SQL ordenado, transacción con bloqueo de concurrencia, registro idempotente y CLI sin imprimir errores de conexión sensibles. | PostgreSQL temporal real, contrato del almacén, rollback de DDL y registro, reintento e idempotencia. |
| T114 · #75 | Argon2id con sal, verificación segura de hashes inválidos y hash ficticio; tokens aleatorios de 256 bits y SHA-256 solo para tokens. | Sal distinta, credenciales correctas/incorrectas, tokens distintos, servicio de cuentas y ausencia de contraseñas/tokens planos en PostgreSQL. |

Resultado: **87 passed in 1.40s**, sin skips. Ruff y formateador: correctos en los
siete archivos Python de este lote. No equivale a aprobación de toda la aplicación.
Los endpoints de documentos todavía conservan el bloqueo temporal T118.

Comandos desde `backend/`:

```bash
# Usar Python 3.12; el entorno de esta máquina se llama .venv312.
.venv312/bin/python -m pip install -r requirements-dev.txt
.venv312/bin/python -m pip check
.venv312/bin/ruff check app/config.py app/errors.py app/persistence/migrations.py app/services/accounts/passwords.py app/services/accounts/tokens.py tests/conftest.py tests/test_luis_foundations.py
.venv312/bin/ruff format --check app/config.py app/errors.py app/persistence/migrations.py app/services/accounts/passwords.py app/services/accounts/tokens.py tests/conftest.py tests/test_luis_foundations.py
.venv312/bin/pytest -q tests/test_luis_foundations.py tests/test_account_rules.py tests/test_account_service.py tests/test_user_store.py tests/test_image_validation.py tests/test_image_preparation.py
```

Las pruebas necesitan conexiones locales para TestClient y PostgreSQL; se ejecutaron
fuera del aislamiento de red. PostgreSQL lo crea y elimina pgserver en un directorio
temporal exclusivo. No se usa la conexión de producción ni se ejecuta su migración.

Procedencia: se implementaron los cuerpos pendientes contra los contratos y pruebas
conservados. Se consultó `098d4f6:backend/app/persistence/migrations.py` exclusivamente
para conservar el contrato existente `schema_migrations.version` y los identificadores
sin extensión. Esos nombres y el esquema son previos; no se atribuyen a Luis. No se
restauró masivamente código histórico. T002 revisa dependencias compartidas conservadas.

## Recursos y verificaciones todavía pendientes

Flutter 3.44.9 / Dart 3.12.2 y SDK Android disponibles; Java incluido en Android Studio.
`flutter pub get` correcto: cinco dependencias de SDK/pruebas se adaptaron al SDK
instalado en el lockfile. La comprobación offline previa falló por caché incompleta.
Backend: Python 3.12.16 descargado localmente, paquetes de desarrollo aislados.
El intento con Python 3.14 no admite pgserver 0.1.4; no se debilitaron las pruebas.

ADB no mostró dispositivos conectados. No se han realizado recorridos manuales,
configurado PIN/huella, instalado APK ni modificado datos de un teléfono. No se ha
generado APK actual ni verificado una firma de distribución. Producción intacta.

Tareas con alcance técnico verificado: 12/72; cierre formal: 0/72 por revisión pendiente.
Las otras 60 tareas requieren implementación/revisión y sus verificaciones actuales.

## Lote 2: T021, T032, T050, T051, T118, T205

- T032: reglas de texto vacío, límite de 200000 caracteres, normalización de saltos,
  párrafos y rechazo de caracteres no válidos en XML; lista acotada de códigos Unicode.
- T050: DejaVu Sans 2.37 copiada de `/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf`,
  conservando `LICENSE-DejaVu.txt`. SHA-256:
  `b4c632e3cdf9acc7f28758fb5a323c8524d7fc6660d46904d9b6cbe2809c419c`.
  Es un recurso de terceros, no una fuente creada por Luis.
- T051: PDF A4 en memoria, fuente incrustada, márgenes de 20 mm, letra de 12 pt,
  ajuste de líneas/páginas, tabulaciones y rechazo explícito de glifos ausentes.
- T021: suite nueva de Word que abre ZIP/XML y DOCX, comprueba texto, caracteres,
  párrafos vacíos, límite exacto, metadatos, controles inválidos, esquema y tamaño.
- T118: endpoints conectados a DocumentUser compartido; Bearer obligatorio salvo
  permiso local explícito. Se retiró pending_luis.py y las pruebas temporales ahora
  verifican 401 y ausencia de llamadas OCR. Permiso local rechazado tras proxy y
  en configuración Railway; nunca habilita operaciones de cuentas.
- T205: conversión de marcas a posiciones Unicode, descarte de intervalos inválidos,
  superpuestos o de puntuación sin cambiar el texto. Modelos compartidos conservados.

Resultado: **218 passed in 2.87s**, sin skips, en la suite completa backend. Incluye
PostgreSQL temporal, DOCX/PDF, privacidad de registros, autorización y proveedores
con transportes simulados. No se instala OCR local ni se llama a proveedores reales.
Ruff completo: correcto; formateador: 57 archivos correctos. Se corrigió el handler
de StoreUnavailableError para responder 503, descubierto por la suite compartida.

Comandos desde backend:

```bash
.venv312/bin/ruff check .
.venv312/bin/ruff format --check .
.venv312/bin/pytest -q
.venv312/bin/pytest --noconftest -q ../checks/test_reinicio_luis.py
```

Los checks finales verifican autenticación y mantienen el control de release
mientras falta T409. Se conserva el nombre del archivo para que siga siendo
localizable. La suite anterior de bloqueo temporal se sustituyó, no se debilitó.
No se consultó ni restauró implementación histórica en este lote; las funciones
se implementaron contra contratos actuales y pruebas compartidas.
