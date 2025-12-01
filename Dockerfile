# ---------- Base image ----------
FROM python:3.11-slim

# Metadata
LABEL maintainer="you@example.com"
LABEL description="Professional Telegram bot image (Telethon/Quart)"

# ---------- Environment variables ----------
# Unbuffered output for logs
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONPATH=/app

# ---------- Working directory ----------
WORKDIR /app

# ---------- Install system dependencies ----------
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      build-essential \
      gcc \
      libffi-dev \
      ca-certificates \
      tini \
      procps \
 && rm -rf /var/lib/apt/lists/*

# ---------- Copy and install Python dependencies ----------
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# ---------- Copy bot code ----------
COPY bot/ ./

# ---------- Create non-root user ----------
RUN useradd --create-home --shell /bin/bash botuser \
 && chown -R botuser:botuser /app

# ---------- Use tini as PID 1 ----------
ENTRYPOINT ["/usr/bin/tini", "--"]

# ---------- Switch to non-root user ----------
USER botuser

# ---------- Healthcheck (optional) ----------
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD pgrep -f "__main__.py" || exit 1

# ---------- Run bot ----------
CMD ["python3", "__main__.py"]
