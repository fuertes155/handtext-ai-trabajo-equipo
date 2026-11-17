# Reinicio 2026-11-17: las regiones marcadas están pendientes de LUISDACA.
# Los comentarios anteriores describen requisitos; no son verificación del código actual.
"""Ejecutor de migraciones SQL (tarea T108; research.md de 002, R4).

Aplica en orden los archivos db/migrations/NNNN_nombre.sql que todavía no se aplicaron y
los anota en la tabla schema_migrations. Volver a ejecutarlo no repite nada.

Uso (desde la carpeta backend, con HANDTEXT_DATABASE_URL definida):
    python -m app.persistence.migrations
"""

from __future__ import annotations

import sys
from pathlib import Path

# documento_word/db/migrations (constitución §4: esquemas y migraciones en /db).
MIGRATIONS_DIR = Path(__file__).resolve().parents[3] / "db" / "migrations"


def apply_migrations(conninfo: str, directory: Path = MIGRATIONS_DIR) -> list[str]:
    raise NotImplementedError("T108: implementación pendiente de LUISDACA")


def main() -> int:
    raise NotImplementedError("T108: implementación pendiente de LUISDACA")


if __name__ == "__main__":
    sys.exit(main())
