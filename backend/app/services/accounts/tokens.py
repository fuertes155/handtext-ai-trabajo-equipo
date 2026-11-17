# Reinicio 2026-11-17: las regiones marcadas están pendientes de LUISDACA.
# Los comentarios anteriores describen requisitos; no son verificación del código actual.
"""Tokens de sesión (tarea T114; research.md de 002, R2).

- El token es aleatorio (256 bits) y la app lo recibe una sola vez.
- La base guarda solo su SHA-256: si se filtrara, no serviría para entrar (SC-201).
"""

from __future__ import annotations


def new_session_token() -> str:
    raise NotImplementedError("T114: implementación pendiente de LUISDACA")


def hash_session_token(token: str) -> str:
    raise NotImplementedError("T114: implementación pendiente de LUISDACA")
