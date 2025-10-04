# Base image
FROM python:3.11-slim

# Create working directory
WORKDIR /app

# Create non-root user with UID 1000 and set permissions
RUN adduser --disabled-password --gecos '' --uid 1000 appuser && \
    chown -R 1000:1000 /app

# Copy requirements and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy source code after installing deps
COPY . .

# Set environment variables
ENV APP_PORT=7126

# Expose port
EXPOSE 7126

# Explicitly switch to UID 1000 (this is the key line)
USER 1000

# Launch FastAPI app
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "7126"]
