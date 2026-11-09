"""Request body reading with a strict in-memory limit."""

from fastapi import Request

from app.errors import AppError, ErrorCode


async def read_body_limited(
    request: Request, max_bytes: int, too_large: ErrorCode = ErrorCode.REQUEST_TOO_LARGE
) -> bytes:
    declared = request.headers.get("content-length")
    if declared and declared.isascii() and declared.isdecimal():
        digits = declared.lstrip("0")
        limit = str(max_bytes)
        if len(digits) > len(limit) or (len(digits) == len(limit) and digits > limit):
            raise AppError(too_large)
    body = bytearray()
    async for chunk in request.stream():
        if len(chunk) > max_bytes - len(body):
            raise AppError(too_large)
        body.extend(chunk)
    return bytes(body)
