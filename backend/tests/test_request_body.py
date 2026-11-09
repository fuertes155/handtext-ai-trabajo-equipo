from fastapi import Request
from fastapi.testclient import TestClient

from app.api.request_body import read_body_limited
from app.config import Settings
from app.main import create_app


def test_limit_checks_actual_bytes_and_reports_request_id():
    app = create_app(Settings(None))

    @app.post("/limited")
    async def limited(request: Request) -> dict[str, int]:
        return {"size": len(await read_body_limited(request, 3))}

    with TestClient(app) as client:
        assert client.post("/limited", content=b"abc").json() == {"size": 3}
        response = client.post("/limited", content=b"abcd", headers={"content-length": "1"})
        assert response.status_code == 413
        assert response.json()["error"]["request_id"] == response.headers["x-request-id"]
