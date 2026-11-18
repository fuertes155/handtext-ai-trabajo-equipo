import json
import sys
import time
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import native_checks_luis as n

n.guard()
done = set()
end = time.monotonic() + 300


def cancel():
    n.text_node("Touch the fingerprint sensor")
    n.adb("shell", "input", "keyevent", "4")


def use_pin():
    n.tap(
        n.text_node(
            "Use PIN", "Use screen lock", "PIN", "Usar PIN", "Usar bloqueo de pantalla"
        )
    )
    n.enter_pin()


while time.monotonic() < end:
    s = Path("/tmp/handtext-native-lock.log").read_text(errors="replace")
    for line in s.splitlines():
        if "NATIVE_EVENT " not in line:
            continue
        phase = json.loads(line.split("NATIVE_EVENT ", 1)[1])["phase"]
        if phase in done:
            continue
        if phase == "enable_cancel":
            cancel()
        elif phase == "enable_pin":
            use_pin()
        elif phase == "background_long":
            n.adb("shell", "input", "keyevent", "3")
            print(
                "Aplicación en segundo plano: esperando 62 segundos reales", flush=True
            )
            until = time.monotonic() + 62
            while time.monotonic() < until:
                time.sleep(1)
            n.adb(
                "shell",
                "am",
                "start",
                "-n",
                "com.handtextai.team.debug/com.handtextai.handtext_ai.MainActivity",
            )
            cancel()
        elif phase == "unlock_fingerprint":
            n.text_node("Touch the fingerprint sensor")
            n.adb("emu", "finger", "touch", "1", console=True)
        elif phase == "background_disabled":
            n.adb("shell", "input", "keyevent", "3")
            time.sleep(2)
            n.adb(
                "shell",
                "am",
                "start",
                "-n",
                "com.handtextai.team.debug/com.handtextai.handtext_ai.MainActivity",
            )
        done.add(phase)
        print("Paso Android completado:", phase, flush=True)
    if "All tests passed!" in s:
        assert done == {
            "enable_cancel",
            "enable_pin",
            "background_long",
            "unlock_fingerprint",
            "background_disabled",
            "complete",
        }
        print("T1008: autenticación Android real aprobada", flush=True)
        break
    if "Some tests failed." in s:
        raise RuntimeError("Falló la prueba nativa; revisar log")
    time.sleep(1)
else:
    raise TimeoutError("No terminó la comprobación del bloqueo")
