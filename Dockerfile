FROM python:3.11-slim

# create non-root user with UID 1000
RUN groupadd -g 1000 appuser \
 && useradd -m -u 1000 -g appuser appuser

ENV APP_PORT=7126
EXPOSE 7126

WORKDIR /app

# Copy & install dependencies first (cache)
COPY requirements.txt /app/requirements.txt
RUN apt-get update \
 && apt-get install -y --no-install-recommends gcc build-essential ca-certificates \
 && python -m pip install --upgrade pip \
 && pip install --no-cache-dir -r /app/requirements.txt \
 && apt-get remove -y gcc build-essential \
 && apt-get autoremove -y \
 && rm -rf /var/lib/apt/lists/*

# Copy app files
COPY . /app

# Make sure non-root user owns everything
RUN chown -R appuser:appuser /app

USER appuser

# Run uvicorn using the APP_PORT env var
CMD ["sh", "-c", "uvicorn main:app --host 0.0.0.0 --port $APP_PORT --workers 1"]
