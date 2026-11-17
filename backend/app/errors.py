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
import uuid
from enum import StrEnum

from fastapi import FastAPI, Request
from fastapi.exceptions import RequestValidationError
from fastapi.responses import JSONResponse
from starlette.exceptions import HTTPException

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
_CATALOG: dict[ErrorCode, tuple[int, str]] = {
    ErrorCode.VALIDATION_ERROR: (422, "Revisa los datos enviados e inténtalo de nuevo."),
    ErrorCode.IMAGE_TOO_LARGE: (413, "La imagen supera el límite de 10 MB."),
    ErrorCode.UNSUPPORTED_IMAGE_TYPE: (415, "Selecciona una imagen JPEG o PNG."),
    ErrorCode.IMAGE_UNREADABLE: (400, "No se pudo abrir la imagen. Elige otra o repite la foto."),
    ErrorCode.IMAGE_DIMENSIONS_OUT_OF_RANGE: (
        400,
        "La imagen debe medir entre 600 y 10000 px por lado.",
    ),
    ErrorCode.OCR_NOT_CONFIGURED: (
        503,
        "El reconocimiento no está disponible. Inténtalo más tarde.",
    ),
    ErrorCode.OCR_TIMEOUT: (504, "El reconocimiento tardó demasiado. Inténtalo de nuevo."),
    ErrorCode.OCR_PROVIDER_ERROR: (502, "No se pudo reconocer la imagen. Inténtalo de nuevo."),
    ErrorCode.OCR_INVALID_RESPONSE: (502, "No se obtuvo un resultado válido. Inténtalo de nuevo."),
    ErrorCode.EMPTY_TEXT: (400, "Escribe o reconoce texto antes de exportar."),
    ErrorCode.TEXT_TOO_LARGE: (413, "El texto supera el límite de 200000 caracteres."),
    ErrorCode.UNSUPPORTED_CHARACTERS: (
        400,
        "El texto contiene caracteres que no se pueden exportar.",
    ),
    ErrorCode.NOT_FOUND: (404, "El recurso solicitado no está disponible."),
    ErrorCode.METHOD_NOT_ALLOWED: (405, "Esta operación no está disponible para ese recurso."),
    ErrorCode.INTERNAL_ERROR: (500, "Ocurrió un error. Inténtalo de nuevo."),
    ErrorCode.REQUEST_TOO_LARGE: (413, "La solicitud supera el tamaño permitido."),
    ErrorCode.UNAUTHENTICATED: (401, "Inicia sesión para continuar."),
    ErrorCode.INVALID_CREDENTIALS: (401, "El correo o la contraseña son incorrectos."),
    ErrorCode.TOO_MANY_ATTEMPTS: (429, "Demasiados intentos. Espera 15 minutos antes de ingresar."),
    ErrorCode.EMAIL_ALREADY_REGISTERED: (409, "Ya existe una cuenta con ese correo."),
    ErrorCode.INVALID_EMAIL: (400, "Escribe un correo válido de hasta 254 caracteres."),
    ErrorCode.INVALID_DISPLAY_NAME: (400, "El nombre debe tener entre 1 y 60 caracteres."),
    ErrorCode.WEAK_PASSWORD: (400, "La contraseña debe tener entre 8 y 128 caracteres."),
    ErrorCode.DATA_POLICY_NOT_ACCEPTED: (
        400,
        "Autoriza el tratamiento de datos para crear la cuenta.",
    ),
    ErrorCode.ACCOUNTS_UNAVAILABLE: (
        503,
        "El servicio de cuentas no está disponible. Reintenta luego.",
    ),
}


class AppError(Exception):
    """Error esperado del dominio, con un código del catálogo.

    `message` permite dar un detalle más preciso (por ejemplo, qué caracteres no se
    pueden exportar). Si no se indica, se usa el mensaje del catálogo.
    """

    def __init__(self, code: ErrorCode, message: str | None = None) -> None:
        self.code = code
        self.status_code, default_message = _CATALOG[code]
        self.message = message if message is not None else default_message
        super().__init__(self.message)


def request_id_of(request: Request) -> str:
    return getattr(request.state, "request_id", None) or uuid.uuid4().hex


def error_response(error: AppError, request_id: str) -> JSONResponse:
    headers = {"X-Request-ID": request_id}
    if error.status_code == 401:
        headers["WWW-Authenticate"] = "Bearer"
    return JSONResponse(
        status_code=error.status_code,
        content={"error": {"code": error.code, "message": error.message, "request_id": request_id}},
        headers=headers,
    )


def log_unexpected_error(exc: BaseException, request_id: str) -> None:
    traceback = exc.__traceback__
    while traceback is not None and traceback.tb_next is not None:
        traceback = traceback.tb_next
    # Solo ubicación y tipo: ni str(exc), ni variables locales, ni cuerpo enviado.
    location = (
        f"{traceback.tb_frame.f_code.co_name}:{traceback.tb_lineno}" if traceback else "unknown"
    )
    logger.error(
        "unexpected_error type=%s location=%s request_id=%s",
        type(exc).__name__,
        location,
        request_id,
    )


def install_error_handlers(app: FastAPI) -> None:
    @app.exception_handler(AppError)
    async def domain_error(request: Request, exc: AppError) -> JSONResponse:
        return error_response(exc, request_id_of(request))

    @app.exception_handler(RequestValidationError)
    async def validation_error(request: Request, exc: RequestValidationError) -> JSONResponse:
        return error_response(AppError(ErrorCode.VALIDATION_ERROR), request_id_of(request))

    @app.exception_handler(HTTPException)
    async def http_error(request: Request, exc: HTTPException) -> JSONResponse:
        code = {
            404: ErrorCode.NOT_FOUND,
            405: ErrorCode.METHOD_NOT_ALLOWED,
            401: ErrorCode.UNAUTHENTICATED,
        }.get(exc.status_code, ErrorCode.INTERNAL_ERROR)
        return error_response(AppError(code), request_id_of(request))

    @app.exception_handler(Exception)
    async def unexpected_error(request: Request, exc: Exception) -> JSONResponse:
        request_id = request_id_of(request)
        log_unexpected_error(exc, request_id)
        return error_response(AppError(ErrorCode.INTERNAL_ERROR), request_id)
