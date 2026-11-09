"""Factory for the local HandText API."""

import logging
from uuid import uuid4

from fastapi import FastAPI, Request
from fastapi.responses import JSONResponse

from app.api.request_body import BodyTooLargeError
from app.config import Settings

logger = logging.getLogger("handtext.requests")


def create_app(settings: Settings | None = None) -> FastAPI:
    app = FastAPI(title="HandText AI")
    app.state.settings = settings if settings is not None else Settings.from_environment()

    @app.middleware("http")
    async def identify_request(request: Request, call_next):
        request_id = uuid4().hex
        request.state.request_id = request_id
        response = await call_next(request)
        response.headers["X-Request-ID"] = request_id
        logger.info("request_id=%s status=%d", request_id, response.status_code)
        return response

    @app.exception_handler(BodyTooLargeError)
    async def body_too_large(request: Request, _error: BodyTooLargeError) -> JSONResponse:
        return JSONResponse(
            status_code=413,
            content={"code": "BODY_TOO_LARGE", "request_id": request.state.request_id},
        )

    @app.get("/health")
    async def health() -> dict[str, str]:
        return {"status": "ok"}

    return app


app = create_app()
