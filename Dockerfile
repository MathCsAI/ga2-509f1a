# Base image
FROM python:3.11-slim

# Create a non-root user with UID 1000
RUN useradd -m -u 1000 appuser

# Set working directory
WORKDIR /app

# Copy and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy all project files
COPY . .

# Set environment variable for app port
ENV APP_PORT=7126

# Expose the app port
EXPOSE 7126

# Use non-root user
USER appuser

# Start the FastAPI app
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "7126"]

