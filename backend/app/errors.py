# Reinicio 2026-11-17: las regiones marcadas están pendientes de LUISDACA.
# Los comentarios anteriores describen requisitos; no son verificación del código actual.
"""Catálogo de errores de la API (tarea T006; constitución §5, Backend).

Toda respuesta de error tiene la misma forma, documentada en contracts/api.md:

    {"error": {"code": "IMAGE_TOO_LARGE", "message": "...", "request_id": "..."}}

- code: identificador estable; la app decide qué mostrar según este valor.
- message: texto en español, sin rutas, trazas, consultas ni credenciales.
- request_id: identificador de la solicitud para localizarla en los registros.

Los servicios lanzan AppError con un código del catálogo y no conocen HTTP. Este módulo
traduce cada código a su estado HTTP; así las rutas, la validación y los servicios quedan
separados (constitución §4).
"""

from __future__ import annotations

import logging
from enum import StrEnum

from fastapi import FastAPI, Request
from fastapi.responses import JSONResponse

logger = logging.getLogger("handtext")


class ErrorCode(StrEnum):
    """Códigos estables que la API puede devolver."""

    VALIDATION_ERROR = "VALIDATION_ERROR"
    IMAGE_TOO_LARGE = "IMAGE_TOO_LARGE"
    UNSUPPORTED_IMAGE_TYPE = "UNSUPPORTED_IMAGE_TYPE"
    IMAGE_UNREADABLE = "IMAGE_UNREADABLE"
    IMAGE_DIMENSIONS_OUT_OF_RANGE = "IMAGE_DIMENSIONS_OUT_OF_RANGE"
    OCR_NOT_CONFIGURED = "OCR_NOT_CONFIGURED"
    OCR_TIMEOUT = "OCR_TIMEOUT"
    OCR_PROVIDER_ERROR = "OCR_PROVIDER_ERROR"
    OCR_INVALID_RESPONSE = "OCR_INVALID_RESPONSE"
    EMPTY_TEXT = "EMPTY_TEXT"
    TEXT_TOO_LARGE = "TEXT_TOO_LARGE"
    UNSUPPORTED_CHARACTERS = "UNSUPPORTED_CHARACTERS"
    NOT_FOUND = "NOT_FOUND"
    METHOD_NOT_ALLOWED = "METHOD_NOT_ALLOWED"
    INTERNAL_ERROR = "INTERNAL_ERROR"
    # Cuentas de usuario (spec 002; contracts/auth-api.md).
    REQUEST_TOO_LARGE = "REQUEST_TOO_LARGE"
    UNAUTHENTICATED = "UNAUTHENTICATED"
    INVALID_CREDENTIALS = "INVALID_CREDENTIALS"
    TOO_MANY_ATTEMPTS = "TOO_MANY_ATTEMPTS"
    EMAIL_ALREADY_REGISTERED = "EMAIL_ALREADY_REGISTERED"
    INVALID_EMAIL = "INVALID_EMAIL"
    INVALID_DISPLAY_NAME = "INVALID_DISPLAY_NAME"
    WEAK_PASSWORD = "WEAK_PASSWORD"
    DATA_POLICY_NOT_ACCEPTED = "DATA_POLICY_NOT_ACCEPTED"
    ACCOUNTS_UNAVAILABLE = "ACCOUNTS_UNAVAILABLE"


# Código -> (estado HTTP, mensaje público en español). Los estados siguen la constitución
# §5: 400 solicitud mal formada, 401 autenticación ausente o inválida, 409 conflicto,
# 413 carga excesiva, 415 tipo no admitido, 422 esquema, 5xx fallos internos o de
# dependencias. 429 (demasiados intentos) es el estándar HTTP para el bloqueo de ingreso.
_CATALOG: dict[ErrorCode, tuple[int, str]] = {}  # T006: catálogo pendiente de LUISDACA


class AppError(Exception):
    """Error esperado del dominio, con un código del catálogo.

    `message` permite dar un detalle más preciso (por ejemplo, qué caracteres no se
    pueden exportar). Si no se indica, se usa el mensaje del catálogo.
    """

    def __init__(self, code: ErrorCode, message: str | None = None) -> None:
        raise NotImplementedError("T006: implementación pendiente de LUISDACA")


def request_id_of(request: Request) -> str:
    raise NotImplementedError("T006: implementación pendiente de LUISDACA")


def error_response(error: AppError, request_id: str) -> JSONResponse:
    raise NotImplementedError("T006: implementación pendiente de LUISDACA")


def log_unexpected_error(exc: BaseException, request_id: str) -> None:
    raise NotImplementedError("T006: implementación pendiente de LUISDACA")


def install_error_handlers(app: FastAPI) -> None:
    raise NotImplementedError("T006: implementación pendiente de LUISDACA")
