"""Ejecuta OCR en el PC y conecta una compilación de depuración al teléfono por ADB."""

from __future__ import annotations

import argparse
import json
import os
import secrets
import shutil
import socket
import subprocess
import tempfile
import threading
import time
from pathlib import Path

import uvicorn

from app.config import Settings

FRONTEND = Path(__file__).resolve().parents[2] / "frontend"
ANDROID_PLATFORMS = {
    "arm64-v8a": "android-arm64",
    "armeabi-v7a": "android-arm",
    "x86_64": "android-x64",
}
MAIN_ACTIVITY = "com.handtextai.team.debug/com.handtextai.handtext_ai.MainActivity"


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--models", type=Path, required=True, help="carpeta con los modelos ONNX")
    parser.add_argument("--adb", default=shutil.which("adb"))
    parser.add_argument("--flutter", default=shutil.which("flutter"))
    args = parser.parse_args()
    if not args.adb or not args.flutter:
        parser.error("ADB y Flutter deben estar en PATH o indicarse con --adb y --flutter.")

    listing = subprocess.check_output([args.adb, "devices"], text=True)
    phones = [
        fields[0]
        for line in listing.splitlines()
        if len(fields := line.split()) == 2
        and fields[1] == "device"
        and not fields[0].startswith("emulator-")
    ]
    if len(phones) != 1:
        raise SystemExit("Conecta exactamente un teléfono autorizado por ADB.")
    adb = [args.adb, "-s", phones[0]]
    abi = subprocess.check_output(adb + ["shell", "getprop", "ro.product.cpu.abi"], text=True)
    target = ANDROID_PLATFORMS.get(abi.strip())
    if target is None:
        raise SystemExit("Arquitectura Android no compatible con el lanzador.")

    # La prueba se aísla de las credenciales y la base de cuentas de otros modos.
    os.environ["HANDTEXT_OCR_PROVIDER"] = "local"
    os.environ.pop("HANDTEXT_LOCAL_OCR_MODELS", None)
    os.environ.pop("HANDTEXT_DATABASE_URL", None)
    os.environ.pop("HANDTEXT_LOCAL_DEV_TOKEN", None)
    from app.main import create_app

    token = secrets.token_urlsafe(48)
    app = create_app(
        Settings(
            google_vision_api_key=None,
            local_dev_token=token,
            ocr_provider="local",
            local_ocr_models=args.models,
        )
    )
    server = uvicorn.Server(
        uvicorn.Config(app, access_log=False, log_level="warning", timeout_graceful_shutdown=5)
    )
    with socket.socket() as listener:
        listener.bind(("127.0.0.1", 0))
        port = listener.getsockname()[1]
        forward = f"tcp:{port}"
        thread = threading.Thread(target=server.run, kwargs={"sockets": [listener]}, daemon=True)
        thread.start()
        tunnel_open = False
        try:
            deadline = time.monotonic() + 10
            while not server.started and thread.is_alive() and time.monotonic() < deadline:
                time.sleep(0.1)
            if not server.started:
                raise SystemExit("La API local no pudo arrancar.")
            subprocess.run(adb + ["reverse", "--no-rebind", forward, forward], check=True)
            tunnel_open = True
            print(f"OCR local activo en 127.0.0.1:{port}. Compilando HandText.", flush=True)
            with tempfile.TemporaryDirectory(prefix="handtext-local-ocr-") as directory:
                defines = Path(directory) / "defines.json"
                defines.write_text(
                    json.dumps(
                        {"API_BASE_URL": f"http://127.0.0.1:{port}/", "LOCAL_DEV_API_TOKEN": token}
                    ),
                    encoding="utf-8",
                )
                subprocess.run(
                    [
                        args.flutter,
                        "build",
                        "apk",
                        "--debug",
                        "--no-pub",
                        "--target-platform",
                        target,
                        f"--dart-define-from-file={defines}",
                    ],
                    cwd=FRONTEND,
                    check=True,
                )
                apk = FRONTEND / "build" / "app" / "outputs" / "flutter-apk" / "app-debug.apk"
                subprocess.run(adb + ["install", "-r", str(apk)], check=True)
                subprocess.run(
                    adb + ["shell", "am", "start", "-W", "-n", MAIN_ACTIVITY], check=True
                )
                print(
                    "HandText instalado. Mantén este proceso abierto para reconocer hojas.",
                    flush=True,
                )
                thread.join()
        finally:
            if tunnel_open:
                subprocess.run(adb + ["reverse", "--remove", forward], check=False)
            server.should_exit = True
            thread.join(timeout=8)


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        raise SystemExit(130) from None
    except subprocess.CalledProcessError as error:
        raise SystemExit(
            f"Falló la compilación, instalación o conexión (código {error.returncode})."
        ) from None
