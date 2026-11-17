"""Errores y contrato del adaptador RapidOCR sin descargar modelos ni usar red."""

from __future__ import annotations

import asyncio
import sys
from pathlib import Path
from threading import Event
from types import SimpleNamespace
from unittest.mock import MagicMock

import pytest

from app.config import Settings
from app.services.ocr import OcrProviderError, OcrTimeoutError, build_ocr_provider
from app.services.ocr.local_ocr import (
    DETECT_MODEL,
    ORIENTATION_MODEL,
    RECOGNIZE_MODEL,
    LocalOcrProvider,
)


@pytest.fixture
def engine(tmp_path: Path, monkeypatch: pytest.MonkeyPatch) -> MagicMock:
    for name in (DETECT_MODEL, ORIENTATION_MODEL, RECOGNIZE_MODEL):
        (tmp_path / name).touch()
    inference = MagicMock()
    # Se sustituye únicamente la dependencia pesada; se ejecuta el adaptador real.
    monkeypatch.setitem(
        sys.modules,
        "rapidocr",
        SimpleNamespace(
            RapidOCR=MagicMock(return_value=inference),
            LangDet=SimpleNamespace(MULTI="multi"),
            ModelType=SimpleNamespace(SMALL="small", MEDIUM="medium"),
            OCRVersion=SimpleNamespace(PPOCRV5="v5", PPOCRV6="v6"),
        ),
    )
    return inference


def test_local_selection_without_models_does_not_use_cloud_credentials(
    monkeypatch: pytest.MonkeyPatch,
) -> None:
    monkeypatch.setenv("HANDTEXT_OCR_PROVIDER", "local")
    monkeypatch.setenv("HANDTEXT_GOOGLE_VISION_API_KEY", "vision-test")
    monkeypatch.setenv("OPENAI_API_KEY", "openai-test")
    monkeypatch.delenv("HANDTEXT_LOCAL_OCR_MODELS", raising=False)
    settings = Settings.from_environment()
    assert settings.google_vision_api_key is None
    assert settings.openai_api_key is None
    assert build_ocr_provider(settings) is None


def test_missing_local_model_fails_before_initializing_inference(tmp_path: Path) -> None:
    with pytest.raises(ValueError, match="Falta el modelo local"):
        LocalOcrProvider(tmp_path, 1)


@pytest.mark.parametrize(("lines", "text"), [(["Uno", "Dos"], "Uno\nDos"), (None, "")])
def test_transcription_and_empty_result(
    tmp_path: Path, engine: MagicMock, lines: list[str] | None, text: str
) -> None:
    engine.return_value = SimpleNamespace(txts=lines)
    provider = LocalOcrProvider(tmp_path, 1)
    assert asyncio.run(provider.recognize(b"synthetic-image")).text == text
    engine.assert_called_once_with(b"synthetic-image")


def test_inference_error_hides_image_and_exception_details(
    tmp_path: Path, engine: MagicMock, caplog: pytest.LogCaptureFixture
) -> None:
    engine.side_effect = RuntimeError("private-inference-detail")
    provider = LocalOcrProvider(tmp_path, 1)
    with pytest.raises(OcrProviderError):
        asyncio.run(provider.recognize(b"private-image"))
    assert "type=RuntimeError" in caplog.text
    assert "private-inference-detail" not in caplog.text
    assert "private-image" not in caplog.text


def test_timeout_returns_without_waiting_for_inference(tmp_path: Path, engine: MagicMock) -> None:
    release = Event()

    def blocked(_: bytes) -> SimpleNamespace:
        release.wait(timeout=2)
        return SimpleNamespace(txts=["Late"])

    engine.side_effect = blocked
    provider = LocalOcrProvider(tmp_path, 0.01)
    try:
        with pytest.raises(OcrTimeoutError):
            asyncio.run(provider.recognize(b"synthetic-image"))
    finally:
        release.set()
