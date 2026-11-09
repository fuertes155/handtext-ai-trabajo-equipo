"""Request body reading with a strict in-memory limit."""

from fastapi import Request


class BodyTooLargeError(ValueError):
    """The request exceeded the endpoint's body limit."""


async def read_body_limited(request: Request, max_bytes: int) -> bytes:
    declared = request.headers.get("content-length")
    if declared and declared.isascii() and declared.isdecimal():
        digits = declared.lstrip("0")
        limit = str(max_bytes)
        if len(digits) > len(limit) or (len(digits) == len(limit) and digits > limit):
            raise BodyTooLargeError
    body = bytearray()
    async for chunk in request.stream():
        if len(chunk) > max_bytes - len(body):
            raise BodyTooLargeError
        body.extend(chunk)
    return bytes(body)
