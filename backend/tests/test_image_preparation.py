import io

import pytest
from PIL import Image

from app.errors import AppError, ErrorCode
from app.services.image_preparation import prepare_for_ocr


def test_preparation_respects_orientation_and_removes_metadata():
    original = io.BytesIO()
    image = Image.new("RGB", (80, 60), "white")
    metadata = image.getexif()
    metadata[274] = 6
    image.save(original, format="JPEG", exif=metadata)
    source = bytearray(original.getvalue())

    with Image.open(io.BytesIO(prepare_for_ocr(source))) as result:
        assert result.format == "JPEG"
        assert result.size == (60, 80)
        assert not result.getexif()
    assert source == original.getvalue()


def test_invalid_image_is_rejected():
    with pytest.raises(AppError) as error:
        prepare_for_ocr(b"invalid")
    assert error.value.code == ErrorCode.IMAGE_UNREADABLE
