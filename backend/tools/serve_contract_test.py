"""API exclusiva de contratos: PostgreSQL temporal, bucle local y sin OCR externo.

Ejecutar desde backend con las dependencias de requirements-dev.txt instaladas:
python -m tools.serve_contract_test --port 8765
Ctrl+C cierra la API y elimina únicamente la base temporal de esta ejecución.
"""

import argparse
from tempfile import TemporaryDirectory

import pgserver
import uvicorn

from app.config import Settings
from app.main import create_app
from app.persistence.migrations import apply_migrations


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--port", type=int, default=8765)
    args = parser.parse_args()
    with TemporaryDirectory(prefix="handtext-contract-") as directory:
        server = pgserver.get_server(directory, cleanup_mode="delete")
        try:
            conninfo = server.get_uri()
            apply_migrations(conninfo)
            # No se lee HANDTEXT_DATABASE_URL ni credenciales OCR del entorno.
            app = create_app(settings=Settings(google_vision_api_key=None, database_url=conninfo))
            uvicorn.run(app, host="127.0.0.1", port=args.port, access_log=False)
        finally:
            server.cleanup()


if __name__ == "__main__":
    main()
