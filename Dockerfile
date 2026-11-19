FROM python:3.12-slim

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1

WORKDIR /app

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY political_post_classifier.py .

# Run as non-root; /data is where input/output files are mounted
RUN useradd --create-home appuser && mkdir /data && chown appuser /data
USER appuser
WORKDIR /data

# ANTHROPIC_API_KEY is supplied at runtime, never baked into the image
ENTRYPOINT ["python", "/app/political_post_classifier.py"]
CMD ["--demo"]
