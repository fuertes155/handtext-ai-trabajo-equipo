import pytest

from app.services.accounts.rules import (
    InvalidAccountDataError,
    validate_display_name,
    validate_email,
    validate_new_password,
)


def test_normalizes_account_fields():
    assert validate_display_name("  Persona   de prueba  ") == "Persona de prueba"
    assert validate_email(" DEMO@EXAMPLE.INVALID ") == "demo@example.invalid"


@pytest.mark.parametrize("password", ["", " " * 8, "a" * 7, "a" * 129])
def test_rejects_invalid_password_lengths_and_blank_values(password):
    with pytest.raises(InvalidAccountDataError, match="WEAK_PASSWORD"):
        validate_new_password(password)
