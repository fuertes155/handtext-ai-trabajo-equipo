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

from app.config import MAX_EXPORT_TEXT_CHARS
from app.errors import AppError, ErrorCode

# Cuántos caracteres problemáticos se enumeran como máximo en el mensaje.
_MAX_LISTED_CHARACTERS = 10


def normalize_newlines(text: str) -> str:
    return text.replace("\r\n", "\n").replace("\r", "\n")


def ensure_exportable(text: str) -> str:
    if not text.strip():
        raise AppError(ErrorCode.EMPTY_TEXT)
    if len(text) > MAX_EXPORT_TEXT_CHARS:
        raise AppError(ErrorCode.TEXT_TOO_LARGE)
    return normalize_newlines(text)


def split_into_paragraphs(text: str) -> list[str]:
    return normalize_newlines(text).split("\n")


def _is_xml_compatible(character: str) -> bool:
    value = ord(character)
    return (
        value in (0x09, 0x0A, 0x0D)
        or 0x20 <= value <= 0xD7FF
        or 0xE000 <= value <= 0xFFFD
        or 0x10000 <= value <= 0x10FFFF
    )


def find_xml_incompatible_characters(text: str) -> list[str]:
    return list(dict.fromkeys(char for char in text if not _is_xml_compatible(char)))


def describe_character(character: str) -> str:
    return f"U+{ord(character):04X}"


def unsupported_characters_error(characters: Sequence[str], format_name: str) -> AppError:
    descriptions = ", ".join(
        describe_character(char) for char in characters[:_MAX_LISTED_CHARACTERS]
    )
    if len(characters) > _MAX_LISTED_CHARACTERS:
        descriptions += ", …"
    return AppError(
        ErrorCode.UNSUPPORTED_CHARACTERS,
        f"{format_name} no puede representar estos caracteres: {descriptions}. Revisa el texto.",
    )
