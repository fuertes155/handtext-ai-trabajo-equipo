import sys
import time
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import native_checks_luis as n

n.guard()
n.adb("shell", "am", "start", "-a", "android.settings.FINGERPRINT_ENROLL")
n.enter_pin()
end = time.monotonic() + 100
while time.monotonic() < end:
    controls = n.nodes()
    for label in ["MORE", "I AGREE", "NEXT", "START", "GET STARTED", "DONE"]:
        found = next(
            (
                x
                for x in controls
                if x.attrib.get("text", "").casefold() == label.casefold()
            ),
            None,
        )
        if found is not None:
            n.tap(found)
            print("Inscripción:", label, flush=True)
            if label == "DONE":
                print("Huella simulada inscrita en el AVD autorizado", flush=True)
                raise SystemExit(0)
            break
    else:
        n.adb("emu", "finger", "touch", "1", console=True)
        time.sleep(0.7)
raise RuntimeError("No terminó la inscripción de huella; no se acredita aprobación")
