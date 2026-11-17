"""Verificación aislada: no carga la aplicación ni modifica la base de datos."""

import sys
from pathlib import Path

import pytest
from fastapi import FastAPI
from fastapi.testclient import TestClient

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "backend"))

# Se añade la carpeta backend antes de importar los routers reales, sin app.main.
from app.api.exports import router as exports_router
from app.api.recognitions import router as recognitions_router
from app.pending_luis import pending_implementation


@pytest.mark.parametrize("route", ["/recognitions", "/exports"])
@pytest.mark.parametrize(
    "authorization", [None, "Bearer incorrecto", "Bearer " + "x" * 48]
)
def test_real_document_routes_stay_closed(route, authorization):
    app = FastAPI()
    app.include_router(recognitions_router)
    app.include_router(exports_router)
    headers = {} if authorization is None else {"Authorization": authorization}
    response = TestClient(app).post(
        route, headers=headers, content=b"ejemplo sintetico"
    )
    assert response.status_code == 503
    assert "T118" in response.json()["detail"]


def test_placeholder_is_an_explicit_failure():
    with pytest.raises(NotImplementedError, match="T205"):
        pending_implementation("T205")


def test_release_marker_and_dependencies():
    assert (ROOT / "frontend/LUIS_PENDIENTE").is_file()
    script = (ROOT / "frontend/android/app/build.gradle.kts").read_text(
        encoding="utf-8"
    )
    assert "dependsOn(checkLuisReleaseReady, checkReleaseApiUrl)" in script
    assert "throw GradleException" in script
    assert 'manifestPlaceholders["usesCleartextTraffic"] = "false"' in script
    assert 'signingConfigs.getByName("debug")' not in script
