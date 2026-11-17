# syntax=docker/dockerfile:1.6
FROM python:3.12-slim-bookworm

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    HANDTEXT_OCR_PROVIDER=local \
    HANDTEXT_LOCAL_OCR_MODELS=/opt/handtext/ocr

RUN apt-get update \
    && apt-get install -y --no-install-recommends libgomp1 \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd --gid 10001 handtext \
    && useradd --uid 10001 --gid handtext --create-home handtext \
    && install -d -m 0755 /opt/handtext /opt/handtext/ocr

WORKDIR /srv/handtext/backend
COPY backend/requirements.txt backend/requirements-ocr-local.txt ./
RUN python -m pip install --no-cache-dir --disable-pip-version-check -r requirements-ocr-local.txt

# Fuentes y SHA-256 del manifiesto default_models.yaml de RapidOCR v3.10.0.
ADD --checksum=sha256:090f04abcd9d9a7498bc4ebf677e4cb9bdce1fe4197ddb7e529f1ef44e1ff94f --chmod=0444 https://www.modelscope.cn/models/RapidAI/RapidOCR/resolve/v3.10.0/onnx/PP-OCRv6/det/PP-OCRv6_det_small.onnx /opt/handtext/ocr/PP-OCRv6_det_small.onnx
ADD --checksum=sha256:54379ae5174d026780215fc748a7f31910dee36818e63d49e17dc598ecc82df7 --chmod=0444 https://www.modelscope.cn/models/RapidAI/RapidOCR/resolve/v3.10.0/onnx/PP-OCRv5/cls/ch_PP-LCNet_x0_25_textline_ori_cls_mobile.onnx /opt/handtext/ocr/ch_PP-LCNet_x0_25_textline_ori_cls_mobile.onnx
ADD --checksum=sha256:eef444829dbbe18d7fea59a3f6eb75647518d2b3a9568d27c92e42940204894b --chmod=0444 https://www.modelscope.cn/models/RapidAI/RapidOCR/resolve/v3.10.0/onnx/PP-OCRv6/rec/PP-OCRv6_rec_medium.onnx /opt/handtext/ocr/PP-OCRv6_rec_medium.onnx
RUN chmod 0755 /opt/handtext /opt/handtext/ocr

COPY backend/app ./app
COPY db/migrations /srv/handtext/db/migrations

USER handtext
RUN test -r "$HANDTEXT_LOCAL_OCR_MODELS/PP-OCRv6_det_small.onnx" \
    && test -r "$HANDTEXT_LOCAL_OCR_MODELS/ch_PP-LCNet_x0_25_textline_ori_cls_mobile.onnx" \
    && test -r "$HANDTEXT_LOCAL_OCR_MODELS/PP-OCRv6_rec_medium.onnx" \
    && test -r /srv/handtext/db/migrations/0001_users_and_sessions.sql
CMD ["sh", "-c", "python -m app.persistence.migrations && exec python -m uvicorn app.main:app --host 0.0.0.0 --port \"${PORT:-8000}\" --workers 1 --no-access-log"]
