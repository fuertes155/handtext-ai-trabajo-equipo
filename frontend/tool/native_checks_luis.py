"""UI Android real para T908/T1008, restringida al AVD sintético autorizado.

No usar con teléfonos. El PIN del AVD se conserva en /tmp/handtext-avd-pin,
con permisos 0600 y nunca se imprime ni se incorpora al APK.
"""

import argparse
import json
import os
import re
import secrets
import subprocess
import time
import xml.etree.ElementTree as ET
from pathlib import Path

AVD = "HandText_Luis_20261117"
ADB = Path.home() / "Android/Sdk/platform-tools/adb"
PIN_FILE = Path("/tmp/handtext-avd-pin")
SERIAL = "127.0.0.1:5581"
CONSOLE = "emulator-5580"
ROOT = Path(__file__).resolve().parents[1]


def adb(*args, console=False, check=True):
    return subprocess.run(
        [str(ADB), "-s", CONSOLE if console else SERIAL, *args],
        check=check,
        capture_output=True,
        text=True,
        timeout=30,
    )


def guard():
    avd = adb("shell", "getprop", "ro.boot.qemu.avd_name").stdout.strip()
    virtual = adb("shell", "getprop", "ro.kernel.qemu").stdout.strip()
    if avd != AVD or virtual != "1":
        raise RuntimeError(
            "Solo se admite el AVD autorizado; no se modifica ningún teléfono"
        )


def nodes():
    adb("shell", "uiautomator", "dump", "/sdcard/handtext-test-window.xml", check=False)
    result = adb("exec-out", "cat", "/sdcard/handtext-test-window.xml", check=False)
    try:
        return list(ET.fromstring(result.stdout).iter("node"))
    except ET.ParseError:
        return []


def tap(node):
    x1, y1, x2, y2 = map(int, re.findall(r"\d+", node.attrib["bounds"]))
    adb("shell", "input", "tap", str((x1 + x2) // 2), str((y1 + y2) // 2))


def find(predicate, timeout=20):
    end = time.monotonic() + timeout
    while time.monotonic() < end:
        for node in nodes():
            if predicate(node.attrib):
                return node
        time.sleep(0.5)
    raise RuntimeError("No apareció el control Android esperado")


def text_node(*values):
    wanted = {v.casefold() for v in values}
    return find(
        lambda a: (
            a.get("text", "").casefold() in wanted
            or a.get("content-desc", "").casefold() in wanted
        )
    )


def enter_pin():
    pin = PIN_FILE.read_text().strip()
    find(
        lambda a: (
            a.get("class") == "android.widget.EditText"
            or "pinEntry" in a.get("resource-id", "")
        )
    )
    adb("shell", "input", "text", pin)
    adb("shell", "input", "keyevent", "66")


def prepare_security():
    guard()
    if PIN_FILE.exists():
        raise RuntimeError(
            "Ya existe PIN de pruebas; conservarlo y verificar el estado antes de repetir la configuración"
        )
    # Un emulador previamente protegido no se modifica sin conocer su estado.
    disabled = adb("shell", "locksettings", "get-disabled").stdout.strip()
    if disabled != "true":
        raise RuntimeError("El AVD no tiene el estado inicial sin bloqueo esperado")
    pin = str(100000 + secrets.randbelow(900000))
    fd = os.open(PIN_FILE, os.O_WRONLY | os.O_CREAT | os.O_EXCL, 0o600)
    with os.fdopen(fd, "w") as file:
        file.write(pin)
    result = adb("shell", "locksettings", "set-pin", pin, check=False)
    if result.returncode:
        raise RuntimeError(
            "No se configuró el PIN; revisar el AVD sin divulgar credenciales"
        )
    print("PIN sintético configurado únicamente en el AVD autorizado", flush=True)
    adb("shell", "am", "start", "-a", "android.settings.FINGERPRINT_ENROLL")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--prepare-security", action="store_true")
    args = parser.parse_args()
    if args.prepare_security:
        prepare_security()
    else:
        guard()
        for node in nodes():
            a = node.attrib
            # Los campos de credenciales nunca se imprimen.
            if (a.get("text") or a.get("content-desc")) and a.get("password") != "true":
                print(
                    json.dumps(
                        {
                            k: a.get(k)
                            for k in (
                                "text",
                                "content-desc",
                                "resource-id",
                                "class",
                                "bounds",
                            )
                        },
                        ensure_ascii=False,
                    )
                )


if __name__ == "__main__":
    main()
