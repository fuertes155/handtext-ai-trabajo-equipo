# Reinicio 2026-11-17: las regiones marcadas están pendientes de LUISDACA.
# Los comentarios anteriores describen requisitos; no son verificación del código actual.
"""Reglas del texto que se va a exportar (tarea T032; spec, módulo 4).

- El texto vacío o compuesto solo por espacios no se exporta (Historia 1, escenario 10;
  SC-007).
- Límite técnico de 200 000 caracteres (research.md, R14). El texto nunca se trunca: si
  es más largo, se rechaza.
- Los saltos de línea de Windows (\\r\\n) y de Mac antiguo (\\r) se convierten en \\n,
  y cada línea pasa a ser un párrafo. Así se conservan el orden y la separación.
- Si hay caracteres que el formato no puede representar, se responde con un mensaje que
  los enumera, en lugar de generar un archivo dañado o incompleto.
"""

from __future__ import annotations

from collections.abc import Sequence

from app.errors import AppError

# Cuántos caracteres problemáticos se enumeran como máximo en el mensaje.
_MAX_LISTED_CHARACTERS = 10


def normalize_newlines(text: str) -> str:
    raise NotImplementedError("T032: implementación pendiente de LUISDACA")


def ensure_exportable(text: str) -> str:
    raise NotImplementedError("T032: implementación pendiente de LUISDACA")


def split_into_paragraphs(text: str) -> list[str]:
    raise NotImplementedError("T032: implementación pendiente de LUISDACA")


def _is_xml_compatible(character: str) -> bool:
    raise NotImplementedError("T032: implementación pendiente de LUISDACA")


def find_xml_incompatible_characters(text: str) -> list[str]:
    raise NotImplementedError("T032: implementación pendiente de LUISDACA")


def describe_character(character: str) -> str:
    raise NotImplementedError("T032: implementación pendiente de LUISDACA")


def unsupported_characters_error(characters: Sequence[str], format_name: str) -> AppError:
    raise NotImplementedError("T032: implementación pendiente de LUISDACA")
