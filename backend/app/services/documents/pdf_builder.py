# Reinicio 2026-11-17: las regiones marcadas están pendientes de LUISDACA.
# Los comentarios anteriores describen requisitos; no son verificación del código actual.
"""Generador de archivos PDF (tarea T051; Historia 3).

- Página A4, márgenes de 20 mm, letra DejaVu Sans de 12 pt y alineación izquierda.
- Cada línea del texto es un párrafo; las líneas largas se ajustan al ancho de la página
  y el texto continúa en páginas nuevas cuando hace falta. Nada se trunca (Historia 3,
  escenario 2).
- DejaVu Sans va incrustada en el PDF y cubre tildes, ñ, ¿, ¡, comillas tipográficas y
  miles de caracteres más. Si el texto trae caracteres que la fuente no puede dibujar
  (por ejemplo, emojis), se rechaza con un mensaje que los enumera, en lugar de generar
  un PDF con cuadros vacíos.
- Las tabulaciones se dibujan como cuatro espacios, porque PDF no tiene tabulaciones.
"""

from __future__ import annotations

from functools import lru_cache
from pathlib import Path

# backend/app/assets/fonts/DejaVuSans.ttf (licencia en LICENSE-DejaVu.txt, misma carpeta).
FONT_PATH = Path(__file__).resolve().parents[2] / "assets" / "fonts" / "DejaVuSans.ttf"
FONT_FAMILY = "DejaVuSans"
FONT_SIZE_PT = 12
LINE_HEIGHT_MM = 6
MARGIN_MM = 20
TAB_AS_SPACES = "    "


@lru_cache(maxsize=1)
def _font_codepoints() -> frozenset[int]:
    raise NotImplementedError("T051: implementación pendiente de LUISDACA")


def find_unrenderable_characters(text: str) -> list[str]:
    raise NotImplementedError("T051: implementación pendiente de LUISDACA")


def build_pdf(text: str) -> bytes:
    raise NotImplementedError("T051: implementación pendiente de LUISDACA")
