"""Contratos temporales para el reinicio autorizado de las tareas de Luis.

No habilita acceso anónimo: los endpoints de documentos permanecen cerrados hasta
que se reponga T118. Retirar este marcador exige implementar y verificar la tarea.
"""

from typing import Annotated, Any, NoReturn

from fastapi import Depends, HTTPException


def pending_implementation(task: str) -> NoReturn:
    raise NotImplementedError(f"{task}: implementación pendiente de LUISDACA")


async def pending_document_user() -> NoReturn:
    raise HTTPException(
        status_code=503,
        detail="Acceso a documentos deshabilitado: T118 pendiente de implementación.",
    )


PendingDocumentUser = Annotated[Any, Depends(pending_document_user)]
