"""Ejecutor de migraciones SQL (tarea T108; research.md de 002, R4).

Aplica en orden los archivos db/migrations/NNNN_nombre.sql que todavía no se aplicaron y
los anota en la tabla schema_migrations. Volver a ejecutarlo no repite nada.

Uso (desde la carpeta backend, con HANDTEXT_DATABASE_URL definida):
    python -m app.persistence.migrations
"""

from __future__ import annotations

import os
import sys
from pathlib import Path

import psycopg

# documento_word/db/migrations (constitución §4: esquemas y migraciones en /db).
MIGRATIONS_DIR = Path(__file__).resolve().parents[3] / "db" / "migrations"


def apply_migrations(conninfo: str, directory: Path = MIGRATIONS_DIR) -> list[str]:
    if not directory.is_dir():
        raise ValueError("No existe el directorio de migraciones.")
    applied: list[str] = []
    # Una sola transacción: SQL y registro se confirman juntos. El bloqueo evita
    # aplicar dos veces una migración si arrancan dos procesos simultáneamente.
    with psycopg.connect(conninfo) as connection:
        connection.execute("SELECT pg_advisory_xact_lock(721140108)")
        connection.execute(
            "CREATE TABLE IF NOT EXISTS schema_migrations "
            "(version TEXT PRIMARY KEY, applied_at TIMESTAMPTZ NOT NULL DEFAULT now())"
        )
        known = {row[0] for row in connection.execute("SELECT version FROM schema_migrations")}
        for path in sorted(directory.glob("[0-9][0-9][0-9][0-9]_*.sql")):
            if path.stem in known:
                continue
            connection.execute(path.read_text(encoding="utf-8"))
            connection.execute("INSERT INTO schema_migrations (version) VALUES (%s)", (path.stem,))
            applied.append(path.stem)
    return applied


def main() -> int:
    conninfo = os.environ.get("HANDTEXT_DATABASE_URL", "").strip()
    if not conninfo:
        print("Define HANDTEXT_DATABASE_URL antes de aplicar migraciones.", file=sys.stderr)
        return 1
    try:
        applied = apply_migrations(conninfo)
    except (OSError, ValueError, psycopg.Error):
        # Los errores de conexión pueden contener credenciales: no imprimirlos.
        print("No se pudieron aplicar las migraciones; verifica la configuración.", file=sys.stderr)
        return 1
    print(f"Migraciones aplicadas: {len(applied)}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
