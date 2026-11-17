"""Ejecuta la política real de Gradle con claves sintéticas; no genera APK release."""

import base64
import os
import subprocess
from pathlib import Path

import pytest

ANDROID = Path(__file__).resolve().parents[1] / "frontend/android"
DEFAULT = {"API_BASE_URL": "https://example.invalid/", "HOSTED_ACCOUNTS": "true"}


def check_policy(properties, defines, *extra):
    encoded = ",".join(
        base64.b64encode(f"{k}={v}".encode()).decode() for k, v in defines.items()
    )
    return subprocess.run(
        [
            "./gradlew",
            "--offline",
            "--console=plain",
            ":app:checkReleaseConfiguration",
            f"-Pdart-defines={encoded}",
            f"-PhandtextSigningProperties={properties}",
            *extra,
        ],
        check=False,
        cwd=ANDROID,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        timeout=180,
        env=os.environ.copy(),
    )


@pytest.fixture(scope="module")
def signing_files(tmp_path_factory):
    folder = tmp_path_factory.mktemp("synthetic-signing")
    result = {}
    for kind, alias, subject in [
        ("own", "synthetic", "CN=Synthetic Contract Test"),
        ("debug", "androiddebugkey", "CN=Android Debug,O=Android,C=US"),
    ]:
        store = folder / f"{kind}.jks"
        java_home = os.environ.get("JAVA_HOME")
        keytool = str(Path(java_home) / "bin/keytool") if java_home else "keytool"
        subprocess.run(
            [
                keytool,
                "-genkeypair",
                "-keystore",
                str(store),
                "-alias",
                alias,
                "-storepass",
                "synthetic-only",
                "-keypass",
                "synthetic-only",
                "-keyalg",
                "RSA",
                "-keysize",
                "2048",
                "-validity",
                "2",
                "-dname",
                subject,
            ],
            check=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
        )
        properties = folder / f"{kind}.properties"
        properties.write_text(
            f"storeFile={store}\nkeyAlias={alias}\nstorePassword=synthetic-only\nkeyPassword=synthetic-only\n"
        )
        result[kind] = properties
    result["missing"] = folder / "absent.properties"
    return result


@pytest.mark.parametrize(
    "changes,extra,code",
    [
        ({"API_BASE_URL": ""}, [], "API_HTTPS_REQUIRED"),
        (
            {"API_BASE_URL": "http://127.0.0.1:8001/"},
            ["-PpermitirHttpLocal=true"],
            "API_HTTPS_REQUIRED",
        ),
        (
            {"API_BASE_URL": "https://user:synthetic@example.invalid/"},
            [],
            "API_HTTPS_REQUIRED",
        ),
        (
            {"API_BASE_URL": "https://example.invalid/?secret=synthetic"},
            [],
            "API_HTTPS_REQUIRED",
        ),
        ({"HOSTED_ACCOUNTS": "false"}, [], "HOSTED_REQUIRED"),
        ({"LOCAL_DEV_API_TOKEN": "synthetic"}, [], "LOCAL_DEV_FORBIDDEN"),
        ({}, ["-PpermitirHttpLocal=true"], "LOCAL_DEV_FORBIDDEN"),
    ],
)
def test_unsafe_distribution_fails(signing_files, changes, extra, code):
    result = check_policy(signing_files["own"], DEFAULT | changes, *extra)
    assert result.returncode != 0
    assert code in result.stdout


def test_missing_project_key_fails(signing_files):
    result = check_policy(signing_files["missing"], DEFAULT)
    assert result.returncode != 0
    assert "SIGNING_REQUIRED" in result.stdout


def test_debug_key_fails(signing_files):
    result = check_policy(signing_files["debug"], DEFAULT)
    assert result.returncode != 0
    assert "DEBUG_SIGNING_FORBIDDEN" in result.stdout


def test_own_synthetic_key_passes_policy_only(signing_files):
    result = check_policy(signing_files["own"], DEFAULT)
    assert result.returncode == 0, result.stdout[-2000:]
    assert "BUILD SUCCESSFUL" in result.stdout
