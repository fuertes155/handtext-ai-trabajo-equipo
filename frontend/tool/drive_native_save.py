import json
import shlex
import sys
import time
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import native_checks_luis as n

n.guard()
done = set()
saved = None
cancel = None
end = time.monotonic() + 200
while time.monotonic() < end:
    s = Path("/tmp/handtext-native-save.log").read_text(errors="replace")
    for line in s.splitlines():
        if "NATIVE_EVENT " not in line:
            continue
        data = json.loads(line.split("NATIVE_EVENT ", 1)[1])
        phase = data["phase"]
        if phase in done:
            continue
        if phase == "save":
            field = n.find(
                lambda a, data=data: (
                    a.get("class") == "android.widget.EditText"
                    and a.get("text") == data["name"]
                )
            )
            print("Nombre propuesto verificado en el diálogo Android", flush=True)
            n.tap(n.text_node("SAVE", "Guardar"))
        elif phase == "saved":
            saved = data
            result = n.adb(
                "shell", "sha256sum", shlex.quote("/sdcard/Download/" + data["name"])
            )
            assert result.stdout.split()[0] == data["sha256"]
            print("PDF guardado: SHA-256 coincide con los bytes generados", flush=True)
        elif phase == "cancel":
            cancel = data
            n.find(
                lambda a, data=data: (
                    a.get("class") == "android.widget.EditText"
                    and a.get("text") == data["name"]
                )
            )
            n.adb("shell", "input", "keyevent", "4")
        elif phase == "complete":
            assert saved and cancel
            result = n.adb(
                "shell",
                "test",
                "-e",
                shlex.quote("/sdcard/Download/" + cancel["name"]),
                check=False,
            )
            assert result.returncode != 0
            print("Cancelación verificada: no se creó archivo", flush=True)
        done.add(phase)
    if "All tests passed!" in s:
        assert done == {"save", "saved", "cancel", "complete"}
        print("T908: diálogo nativo y cancelación aprobados", flush=True)
        break
    if "Some tests failed." in s:
        raise RuntimeError("Falló la integración Android; revisar log")
    time.sleep(1)
else:
    raise TimeoutError("No terminó el recorrido de guardado nativo")
