"""Contrato de Responses y selección del proveedor de OCR, sin salir a Internet."""

from __future__ import annotations

import asyncio
import base64
import json

import httpx
import pytest

from app.config import Settings
from app.services.ocr import (
    GoogleVisionOcrProvider,
    OcrInvalidResponseError,
    OcrProviderError,
    OcrTimeoutError,
    build_ocr_provider,
)
from app.services.ocr.openai_vision import MODEL, OpenAIVisionOcrProvider
from tests.conftest import make_client, make_image_bytes


def _output(part: dict) -> dict:
    return {
        "status": "completed",
        "output": [{"type": "message", "role": "assistant", "content": [part]}],
    }


def _text(value: str) -> dict:
    return _output({"type": "output_text", "text": json.dumps({"text": value})})


def test_recognition_sends_prepared_image_and_preserves_transcription() -> None:
    transcription = "Título en español\nSecond line.\n"

    def respond(request: httpx.Request) -> httpx.Response:
        assert str(request.url) == "https://api.openai.com/v1/responses"
        assert request.headers["authorization"] == "Bearer key-for-tests"
        payload = json.loads(request.content)
        assert payload["model"] == MODEL
        assert payload["store"] is False
        assert payload["text"]["format"]["strict"] is True
        part = payload["input"][0]["content"][0]
        assert part["type"] == "input_image"
        assert part["detail"] == "original"
        prefix, encoded = part["image_url"].split(",", 1)
        assert prefix == "data:image/jpeg;base64"
        assert base64.b64decode(encoded, validate=True).startswith(b"\xff\xd8\xff")
        return httpx.Response(200, json=_text(transcription))

    provider = OpenAIVisionOcrProvider("key-for-tests", 5.0, httpx.MockTransport(respond))
    response = make_client(provider).post(
        "/api/v1/recognitions",
        content=make_image_bytes(800, 600),
        headers={"Content-Type": "image/png"},
    )
    assert response.status_code == 200
    assert response.json()["status"] == "text_found"
    assert response.json()["text"] == transcription
    assert response.json()["uncertain_words"] == []


@pytest.mark.parametrize(
    ("body", "error_type"),
    [
        ({"status": "incomplete", "output": []}, OcrProviderError),
        (_output({"type": "refusal", "refusal": "Cannot comply"}), OcrProviderError),
        (_output({"type": "output_text", "text": "{}"}), OcrInvalidResponseError),
    ],
)
def test_incomplete_refused_and_invalid_results_are_not_empty_transcriptions(
    body: dict, error_type: type[Exception]
) -> None:
    transport = httpx.MockTransport(lambda _: httpx.Response(200, json=body))
    provider = OpenAIVisionOcrProvider("key-for-tests", 5.0, transport)
    with pytest.raises(error_type):
        asyncio.run(provider.recognize(b"jpeg"))


def test_empty_transcription_is_valid() -> None:
    transport = httpx.MockTransport(lambda _: httpx.Response(200, json=_text("")))
    provider = OpenAIVisionOcrProvider("key-for-tests", 5.0, transport)
    assert asyncio.run(provider.recognize(b"jpeg")).text == ""


def test_quota_error_does_not_log_the_upstream_body(caplog: pytest.LogCaptureFixture) -> None:
    body = {"error": {"code": "credit_balance_exhausted", "message": "private-error-detail"}}
    transport = httpx.MockTransport(lambda _: httpx.Response(429, json=body))
    provider = OpenAIVisionOcrProvider("key-for-tests", 5.0, transport)
    with pytest.raises(OcrProviderError):
        asyncio.run(provider.recognize(b"jpeg"))
    assert "status=429 code=credit_balance_exhausted" in caplog.text
    assert "private-error-detail" not in caplog.text
    assert "key-for-tests" not in caplog.text


def test_timeout_covers_the_whole_openai_request() -> None:
    async def delayed(_: httpx.Request) -> httpx.Response:
        await asyncio.sleep(1)
        return httpx.Response(200, json=_text("Late"))

    provider = OpenAIVisionOcrProvider("key-for-tests", 0.01, httpx.MockTransport(delayed))
    with pytest.raises(OcrTimeoutError):
        asyncio.run(provider.recognize(b"jpeg"))


def test_openai_requires_explicit_selection_and_does_not_fall_back(
    monkeypatch: pytest.MonkeyPatch,
) -> None:
    monkeypatch.setenv("HANDTEXT_GOOGLE_VISION_API_KEY", "vision-test")
    monkeypatch.setenv("OPENAI_API_KEY", "openai-test")
    monkeypatch.delenv("HANDTEXT_OCR_PROVIDER", raising=False)
    assert isinstance(build_ocr_provider(Settings.from_environment()), GoogleVisionOcrProvider)

    monkeypatch.setenv("HANDTEXT_OCR_PROVIDER", "openai")
    settings = Settings.from_environment()
    assert isinstance(build_ocr_provider(settings), OpenAIVisionOcrProvider)
    assert "openai-test" not in repr(settings)

    monkeypatch.delenv("OPENAI_API_KEY")
    assert build_ocr_provider(Settings.from_environment()) is None
