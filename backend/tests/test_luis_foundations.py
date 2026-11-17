"""Regresiones actuales de T006/T010/T104/T108/T114; solo datos sintéticos."""

import asyncio
from io import BytesIO

import psycopg
import pytest
from fastapi import FastAPI
from fastapi.testclient import TestClient
from PIL import Image
from pydantic import BaseModel

from app.config import Settings
from app.errors import AppError, ErrorCode, install_error_handlers
from app.persistence.migrations import apply_migrations
from app.services.accounts.tokens import hash_session_token, new_session_token
from app.services.ocr.base import UncertainSpan
from tests.conftest import FAST_PASSWORDS, FakeOcrProvider, make_image_bytes, make_noisy_jpeg


def test_configuration_is_explicit_and_secrets_are_not_represented(monkeypatch):
    for key in ("HANDTEXT_DATABASE_URL", "HANDTEXT_LOCAL_DEV_TOKEN", "HANDTEXT_OCR_PROVIDER"):
        monkeypatch.delenv(key, raising=False)
    settings = Settings.from_environment()
    assert settings.database_url is None
    assert settings.local_dev_token is None
    monkeypatch.setenv("HANDTEXT_DATABASE_URL", " postgresql://synthetic:test@localhost/test ")
    monkeypatch.setenv("HANDTEXT_LOCAL_DEV_TOKEN", "x" * 32)
    settings = Settings.from_environment()
    assert settings.database_url == "postgresql://synthetic:test@localhost/test"
    assert "synthetic:test" not in repr(settings)
    assert "x" * 32 not in repr(settings)
    monkeypatch.setenv("HANDTEXT_LOCAL_DEV_TOKEN", "short")
    with pytest.raises(ValueError, match="al menos 32"):
        Settings.from_environment()


def test_passwords_are_salted_argon2id_and_invalid_hashes_fail_closed():
    first = FAST_PASSWORDS.hash("synthetic-password")
    second = FAST_PASSWORDS.hash("synthetic-password")
    assert first.startswith("$argon2id$")
    assert first != second
    assert FAST_PASSWORDS.verify(first, "synthetic-password")
    assert not FAST_PASSWORDS.verify(first, "wrong-password")
    assert not FAST_PASSWORDS.verify("malformed", "synthetic-password")
    assert FAST_PASSWORDS.verify_dummy("unknown-account") is None


def test_tokens_are_unique_and_only_digests_are_persistable():
    tokens = {new_session_token() for _ in range(100)}
    assert len(tokens) == 100
    for token in tokens:
        assert len(token) == 43
        digest = hash_session_token(token)
        assert len(digest) == 64
        assert digest != token
        assert digest == hash_session_token(token)


def test_fake_ocr_preserves_text_spans_and_records_failed_calls():
    provider = FakeOcrProvider(text="á🙂 duda", uncertain=(UncertainSpan(3, 7),))
    result = asyncio.run(provider.recognize(b"synthetic-image"))
    assert result.text == "á🙂 duda"
    assert result.uncertain_spans == (UncertainSpan(3, 7),)
    assert provider.received == [b"synthetic-image"]
    provider.error = RuntimeError("synthetic failure")
    with pytest.raises(RuntimeError, match="synthetic failure"):
        asyncio.run(provider.recognize(b"second-image"))
    assert provider.received == [b"synthetic-image", b"second-image"]


def test_synthetic_images_are_decodable_and_noise_is_reproducible():
    for image_format in ("PNG", "JPEG"):
        with Image.open(BytesIO(make_image_bytes(800, 600, image_format))) as image:
            image.load()
            assert image.size == (800, 600)
            assert image.format == image_format
    first = make_noisy_jpeg()
    assert first == make_noisy_jpeg()
    with Image.open(BytesIO(first)) as image:
        image.load()
        assert image.size == (800, 800)


@pytest.mark.parametrize("code", list(ErrorCode))
def test_all_domain_errors_have_safe_structured_responses(code):
    app = FastAPI()
    install_error_handlers(app)

    @app.get("/error")
    def fail():
        raise AppError(code)

    response = TestClient(app).get("/error")
    body = response.json()["error"]
    assert body["code"] == code
    assert body["message"]
    assert len(body["request_id"]) == 32
    assert body["request_id"] == response.headers["X-Request-ID"]
    assert response.status_code == AppError(code).status_code
    if response.status_code == 401:
        assert response.headers["WWW-Authenticate"] == "Bearer"


def test_framework_validation_does_not_echo_input():
    app = FastAPI()
    install_error_handlers(app)

    class Payload(BaseModel):
        count: int

    @app.post("/validate")
    def validate(body: Payload):
        return {"count": body.count}

    response = TestClient(app).post("/validate", json={"count": "synthetic-secret"})
    assert response.status_code == 422
    assert "synthetic-secret" not in response.text
    assert response.json()["error"]["code"] == "VALIDATION_ERROR"


def test_failed_migration_rolls_back_ddl_and_tracking(postgres_conninfo, tmp_path):
    migration = tmp_path / "9999_synthetic.sql"
    migration.write_text("CREATE TABLE rollback_probe (id INTEGER); SELECT missing_column;\n")
    with pytest.raises(psycopg.Error):
        apply_migrations(postgres_conninfo, tmp_path)
    with psycopg.connect(postgres_conninfo) as connection:
        assert connection.execute("SELECT to_regclass('rollback_probe')").fetchone() == (None,)
        assert (
            connection.execute(
                "SELECT version FROM schema_migrations WHERE version = %s", (migration.stem,)
            ).fetchone()
            is None
        )
    migration.write_text("CREATE TABLE rollback_probe (id INTEGER);\n")
    assert apply_migrations(postgres_conninfo, tmp_path) == [migration.stem]
    assert apply_migrations(postgres_conninfo, tmp_path) == []
