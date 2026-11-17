"""T118: permiso de documentos separado de cuentas y del proxy público."""

import pytest

from app.config import Settings
from tests.conftest import FakeOcrProvider, make_client


@pytest.mark.parametrize("path", ["recognitions", "exports"])
def test_revoked_session_cannot_access_documents_or_fall_back_to_dev(path):
    token = "synthetic-local-only-" + "x" * 32
    client = make_client(FakeOcrProvider(), local_dev_token=token)
    assert client.post("/api/v1/auth/logout").status_code == 204
    response = client.post("/api/v1/" + path, content=b"synthetic")
    assert response.status_code == 401
    assert response.json()["error"]["code"] == "UNAUTHENTICATED"


@pytest.mark.parametrize("header", ["Forwarded", "X-Forwarded-For"])
def test_proxy_cannot_use_local_permission(header):
    token = "synthetic-local-only-" + "x" * 32
    client = make_client(FakeOcrProvider(), authenticated=False, local_dev_token=token)
    for endpoint in ("recognitions", "exports"):
        response = client.post(
            "/api/v1/" + endpoint, headers={header: "192.0.2.2"}, content=b"synthetic"
        )
        assert response.status_code == 401


def test_railway_rejects_development_permission_configuration(monkeypatch):
    monkeypatch.setenv("RAILWAY_PROJECT_ID", "synthetic-project")
    monkeypatch.setenv("HANDTEXT_LOCAL_DEV_TOKEN", "synthetic-local-only-" + "x" * 32)
    with pytest.raises(ValueError, match="no se permite en Railway"):
        Settings.from_environment()
