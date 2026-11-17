"""T021: contratos de Word comprobados sobre la implementación actual."""

from io import BytesIO
from zipfile import ZipFile

import pytest
from docx import Document

from app.config import MAX_EXPORT_BODY_BYTES, MAX_EXPORT_TEXT_CHARS
from app.errors import AppError, ErrorCode
from app.services.documents.text_rules import ensure_exportable, find_xml_incompatible_characters
from tests.conftest import FakeOcrProvider, make_client


def export(text):
    return make_client(FakeOcrProvider()).post(
        "/api/v1/exports", json={"text": text, "format": "docx"}
    )


@pytest.mark.parametrize(
    "text",
    ["Título áéíóú Ñ ü ¿¡ «texto» — 🙂", "  márgenes  \n\nsegundo\n", "a\r\nb\rc", "a\tb"],
)
def test_real_docx_preserves_text_paragraphs_and_characters(text):
    response = export(text)
    assert response.status_code == 200
    assert response.headers["content-type"] == (
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
    )
    assert response.headers["Content-Disposition"] == 'attachment; filename="handtext.docx"'
    assert response.headers["Cache-Control"] == "no-store"
    with ZipFile(BytesIO(response.content)) as archive:
        assert "word/document.xml" in archive.namelist()
    document = Document(BytesIO(response.content))
    normalized = text.replace("\r\n", "\n").replace("\r", "\n")
    assert [paragraph.text for paragraph in document.paragraphs] == normalized.split("\n")
    assert document.core_properties.author == "HandText AI"


@pytest.mark.parametrize("text", ["", " \n\t\r ", "\u2003\u00a0"])
def test_blank_text_is_rejected(text):
    response = export(text)
    assert response.status_code == 400
    assert response.json()["error"]["code"] == "EMPTY_TEXT"


def test_exact_character_limit_is_preserved_and_excess_rejected():
    text = "á" * MAX_EXPORT_TEXT_CHARS
    response = export(text)
    assert response.status_code == 200
    assert Document(BytesIO(response.content)).paragraphs[0].text == text
    response = export(text + "a")
    assert response.status_code == 413
    assert response.json()["error"]["code"] == "TEXT_TOO_LARGE"


@pytest.mark.parametrize("character", ["\x00", "\x01", "\x0b", "\x1f", "\ufffe"])
def test_xml_control_characters_are_rejected_without_corrupting_word(character):
    response = export("Apunte" + character)
    assert response.status_code == 400
    error = response.json()["error"]
    assert error["code"] == "UNSUPPORTED_CHARACTERS"
    assert f"U+{ord(character):04X}" in error["message"]


def test_xml_rules_reject_surrogates_but_allow_tabs_newlines_and_supplementary_unicode():
    assert find_xml_incompatible_characters("á\t\n\r🙂") == []
    assert find_xml_incompatible_characters("\ud800\ud800\udfff") == ["\ud800", "\udfff"]
    with pytest.raises(AppError) as raised:
        ensure_exportable("a" * (MAX_EXPORT_TEXT_CHARS + 1))
    assert raised.value.code == ErrorCode.TEXT_TOO_LARGE


@pytest.mark.parametrize("payload", [{"text": "apunte", "format": "txt"}, {"text": "apunte"}, {}])
def test_invalid_export_schema_is_rejected_without_echo(payload):
    response = make_client(FakeOcrProvider()).post("/api/v1/exports", json=payload)
    assert response.status_code == 422
    assert response.json()["error"]["code"] == "VALIDATION_ERROR"
    assert "apunte" not in response.text


def test_body_size_limit_is_enforced():
    response = make_client(FakeOcrProvider()).post(
        "/api/v1/exports",
        content=b"x" * (MAX_EXPORT_BODY_BYTES + 1),
        headers={"Content-Type": "application/json"},
    )
    assert response.status_code == 413
    assert response.json()["error"]["code"] == "TEXT_TOO_LARGE"
