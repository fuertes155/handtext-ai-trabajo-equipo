"""Utilidades compartidas por las pruebas del backend (tareas T010 y T109).

Constitución §6: las muestras de prueba DEBEN ser sintéticas, públicas o anonimizadas.
Todas las imágenes de estas pruebas se generan aquí con Pillow; no se usa ningún
documento real ni se llama a Google (el OCR se reemplaza por FakeOcrProvider).

Cuentas (spec 002):
- Por defecto, cada cliente de prueba trae una cuenta registrada y su token, porque el
  reconocimiento y la exportación exigen sesión.
- `postgres_conninfo` levanta un PostgreSQL real y temporal con pgserver (una vez por
  ejecución) y le aplica las migraciones de db/migrations.
"""

from __future__ import annotations

import random
import struct
import zlib
from collections.abc import Callable, Iterator
from datetime import datetime
from io import BytesIO

import pytest
from argon2 import PasswordHasher
from fastapi.testclient import TestClient
from PIL import Image

from app.config import Settings
from app.main import create_app
from app.persistence.migrations import apply_migrations
from app.persistence.user_store import UserStore
from app.services.accounts.passwords import PasswordService
from app.services.ocr import OcrProvider, OcrResult
from app.services.ocr.base import UncertainSpan
from tests.memory_store import InMemoryUserStore

# Argon2id con parámetros mínimos para que las pruebas sean rápidas. La API real usa
# los parámetros predeterminados de argon2-cffi.
FAST_PASSWORDS = PasswordService(PasswordHasher(time_cost=1, memory_cost=1024, parallelism=1))
TEST_EMAIL = "persona@handtext.test"
TEST_PASSWORD = "clave-de-prueba-123"


class FakeOcrProvider:
    """Proveedor de OCR falso: devuelve un texto fijo o lanza el error indicado.

    [uncertain] son las palabras dudosas que «encontró» (spec 003).
    """

    def __init__(
        self,
        text: str = "",
        error: Exception | None = None,
        uncertain: tuple[UncertainSpan, ...] = (),
    ) -> None:
        self.text = text
        self.error = error
        self.uncertain = uncertain
        self.received: list[bytes] = []

    async def recognize(self, image_jpeg: bytes) -> OcrResult:
        self.received.append(image_jpeg)
        if self.error is not None:
            raise self.error
        return OcrResult(text=self.text, uncertain_spans=self.uncertain)


def make_client(
    provider: OcrProvider | None,
    *,
    authenticated: bool = True,
    local_dev_token: str | None = None,
    store: UserStore | None = None,
    clock: Callable[[], datetime] | None = None,
) -> TestClient:
    """Cliente de prueba de la API.

    - provider=None simula la falta de la clave de Google.
    - authenticated=True registra una cuenta y envía su token en cada solicitud.
    """
    app = create_app(
        settings=Settings(
            google_vision_api_key=None,
            local_dev_token=local_dev_token,
        ),
        ocr_provider=provider,
        user_store=store if store is not None else InMemoryUserStore(),
        password_service=FAST_PASSWORDS,
        clock=clock,
    )
    client = TestClient(app, client=("127.0.0.1", 50000))
    if local_dev_token:
        client.headers["X-HandText-Local-Dev"] = local_dev_token
    if authenticated:
        grant = app.state.accounts.register(
            display_name="Persona de prueba",
            email=TEST_EMAIL,
            password=TEST_PASSWORD,
            accepts_data_policy=True,
        )
        client.headers["Authorization"] = f"Bearer {grant.token}"
    return client


@pytest.fixture(scope="session")
def postgres_conninfo(tmp_path_factory: pytest.TempPathFactory) -> Iterator[str]:
    """PostgreSQL real y temporal (pgserver) con las migraciones aplicadas."""
    pgserver = pytest.importorskip("pgserver")
    server = pgserver.get_server(str(tmp_path_factory.mktemp("postgres")), cleanup_mode="delete")
    try:
        conninfo = server.get_uri()
        apply_migrations(conninfo)
        yield conninfo
    finally:
        server.cleanup()


def make_image_bytes(
    width: int,
    height: int,
    image_format: str = "PNG",
    mode: str = "RGB",
    color: str | tuple[int, ...] = "white",
    exif: Image.Exif | None = None,
) -> bytes:
    with Image.new(mode, (width, height), color) as image, BytesIO() as output:
        options = {"exif": exif} if exif is not None else {}
        image.save(output, format=image_format, **options)
        return output.getvalue()


def make_noisy_jpeg(width: int = 800, height: int = 800) -> bytes:
    # Semilla fija: muestra reproducible, suficientemente grande para truncar su JPEG.
    pixels = random.Random(10).randbytes(width * height * 3)
    with Image.frombytes("RGB", (width, height), pixels) as image, BytesIO() as output:
        image.save(output, format="JPEG", quality=90)
        return output.getvalue()


def make_png_header_only(width: int, height: int) -> bytes:
    # IHDR válido sin asignar una imagen enorme: prueba de defensa contra bombas.
    payload = b"IHDR" + struct.pack(">IIBBBBB", width, height, 8, 2, 0, 0, 0)
    return (
        b"\x89PNG\r\n\x1a\n"
        + struct.pack(">I", 13)
        + payload
        + struct.pack(">I", zlib.crc32(payload))
        + struct.pack(">I", 0)
        + b"IDAT"
        + struct.pack(">I", zlib.crc32(b"IDAT"))
    )
