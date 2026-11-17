# Reinicio 2026-11-17: las regiones marcadas están pendientes de LUISDACA.
# Los comentarios anteriores describen requisitos; no son verificación del código actual.
"""Cifrado y verificación de contraseñas con Argon2id (tarea T114; research.md de 002, R1).

- La base guarda solo el hash (que ya incluye la sal y los parámetros), nunca la
  contraseña (spec 002, módulo 3; SC-201).
- Si el correo no existe, se verifica igual contra un hash ficticio: así la respuesta
  tarda lo mismo y no revela qué correos están registrados (SC-203).
"""

from __future__ import annotations

from argon2 import PasswordHasher


class PasswordService:
    """Envoltorio de argon2-cffi. Las pruebas pasan un PasswordHasher más rápido."""

    def __init__(self, hasher: PasswordHasher | None = None) -> None:
        # Parámetros predeterminados de argon2-cffi (Argon2id, perfil de RFC 9106).
        raise NotImplementedError("T114: implementación pendiente de LUISDACA")

    def hash(self, password: str) -> str:
        raise NotImplementedError("T114: implementación pendiente de LUISDACA")

    def verify(self, password_hash: str, password: str) -> bool:
        raise NotImplementedError("T114: implementación pendiente de LUISDACA")

    def verify_dummy(self, password: str) -> None:
        raise NotImplementedError("T114: implementación pendiente de LUISDACA")
