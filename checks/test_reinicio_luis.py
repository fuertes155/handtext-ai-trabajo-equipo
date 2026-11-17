"""T118: autorización final; release sigue bloqueada hasta completar T409."""

import sys
from pathlib import Path

import pytest

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "backend"))

from tests.conftest import FakeOcrProvider, make_client


@pytest.mark.parametrize("route", ["/recognitions", "/exports"])
@pytest.mark.parametrize(
    "authorization", [None, "Bearer incorrecto", "Bearer " + "x" * 48]
)
def test_real_document_routes_require_a_valid_session(route, authorization):
    provider = FakeOcrProvider()
    client = make_client(provider, authenticated=False)
    headers = {} if authorization is None else {"Authorization": authorization}
    response = client.post(
        "/api/v1" + route, headers=headers, content=b"ejemplo sintetico"
    )
    assert response.status_code == 401
    assert response.json()["error"]["code"] == "UNAUTHENTICATED"
    assert response.headers["WWW-Authenticate"] == "Bearer"
    assert provider.received == []


def test_release_marker_and_dependencies():
    assert (ROOT / "frontend/LUIS_PENDIENTE").is_file()
    script = (ROOT / "frontend/android/app/build.gradle.kts").read_text(
        encoding="utf-8"
    )
    assert "dependsOn(checkLuisReleaseReady, checkReleaseApiUrl)" in script
    assert "throw GradleException" in script
    assert 'manifestPlaceholders["usesCleartextTraffic"] = "false"' in script
    assert 'signingConfigs.getByName("debug")' not in script
