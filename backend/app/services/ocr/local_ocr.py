"""OCR en el computador con RapidOCR y modelos ONNX instalados localmente."""

from __future__ import annotations

import asyncio
import logging
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

from app.services.ocr.base import OcrProviderError, OcrResult, OcrTimeoutError

DETECT_MODEL = "PP-OCRv6_det_small.onnx"
ORIENTATION_MODEL = "ch_PP-LCNet_x0_25_textline_ori_cls_mobile.onnx"
RECOGNIZE_MODEL = "PP-OCRv6_rec_medium.onnx"

logger = logging.getLogger("handtext")
# RapidOCR comparte estado entre llamadas. Un hilo mantiene las inferencias en orden.
_inference_pool = ThreadPoolExecutor(max_workers=1, thread_name_prefix="handtext-ocr")


class LocalOcrProvider:
    def __init__(self, model_dir: Path, timeout_seconds: float) -> None:
        model_dir = model_dir.expanduser().resolve()
        for model in (DETECT_MODEL, ORIENTATION_MODEL, RECOGNIZE_MODEL):
            if not (model_dir / model).is_file():
                raise ValueError(f"Falta el modelo local {model} en HANDTEXT_LOCAL_OCR_MODELS.")
        # La dependencia solo se importa al seleccionar este modo.
        from rapidocr import LangDet, ModelType, OCRVersion, RapidOCR

        self._engine = RapidOCR(
            params={
                "Det.model_path": str(model_dir / DETECT_MODEL),
                "Det.lang_type": LangDet.MULTI,
                "Det.ocr_version": OCRVersion.PPOCRV6,
                "Det.model_type": ModelType.SMALL,
                "Cls.model_path": str(model_dir / ORIENTATION_MODEL),
                "Cls.ocr_version": OCRVersion.PPOCRV5,
                "Rec.model_path": str(model_dir / RECOGNIZE_MODEL),
                "Rec.ocr_version": OCRVersion.PPOCRV6,
                "Rec.model_type": ModelType.MEDIUM,
                "Global.log_level": "warning",
                "EngineConfig.onnxruntime.intra_op_num_threads": 3,
                "EngineConfig.onnxruntime.inter_op_num_threads": 1,
            }
        )
        self._timeout_seconds = timeout_seconds

    async def recognize(self, image_jpeg: bytes) -> OcrResult:
        try:
            async with asyncio.timeout(self._timeout_seconds):
                return await asyncio.get_running_loop().run_in_executor(
                    _inference_pool, self._transcribe, image_jpeg
                )
        except TimeoutError:
            raise OcrTimeoutError from None
        except Exception as error:
            logger.warning("local_ocr_inference_error type=%s", type(error).__name__)
            raise OcrProviderError from None

    def _transcribe(self, image_jpeg: bytes) -> OcrResult:
        output = self._engine(image_jpeg)
        return OcrResult(text="\n".join(output.txts or ()))
