"""Reconocimiento de texto (OCR): contrato, errores y fábrica del proveedor (tarea T030).

`build_ocr_provider` usa el proveedor seleccionado explícitamente en la configuración.
Sin la configuración correspondiente, la ruta responde 503 OCR_NOT_CONFIGURED.
"""

from __future__ import annotations

from app.config import OCR_LANGUAGE_HINTS, OCR_TIMEOUT_SECONDS, Settings
from app.services.ocr.base import (
    OcrError,
    OcrInvalidResponseError,
    OcrProvider,
    OcrProviderError,
    OcrResult,
    OcrTimeoutError,
)
from app.services.ocr.google_vision import GoogleVisionOcrProvider
from app.services.ocr.local_ocr import LocalOcrProvider
from app.services.ocr.openai_vision import OpenAIVisionOcrProvider

__all__ = [
    "GoogleVisionOcrProvider",
    "OcrError",
    "OcrInvalidResponseError",
    "OcrProvider",
    "OcrProviderError",
    "OcrResult",
    "OcrTimeoutError",
    "build_ocr_provider",
]


def build_ocr_provider(settings: Settings) -> OcrProvider | None:
    """Crea el proveedor seleccionado sin recurrir a otro si falta configuración."""
    if settings.ocr_provider == "local":
        if settings.local_ocr_models is None:
            return None
        return LocalOcrProvider(settings.local_ocr_models, OCR_TIMEOUT_SECONDS)
    if settings.ocr_provider == "openai":
        if settings.openai_api_key is None:
            return None
        return OpenAIVisionOcrProvider(settings.openai_api_key, OCR_TIMEOUT_SECONDS)
    if settings.google_vision_api_key is None:
        return None
    return GoogleVisionOcrProvider(
        api_key=settings.google_vision_api_key,
        language_hints=OCR_LANGUAGE_HINTS,
        timeout_seconds=OCR_TIMEOUT_SECONDS,
    )
