# Base image
FROM python:3.11-slim

# Create a non-root user with UID 1000 and home directory
RUN useradd -m -u 1000 appuser

# Set working directory
WORKDIR /app

# Copy requirements first to leverage Docker cache
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy all project files into container
COPY . .

# Set environment variables
ENV APP_PORT=7126

# Expose the app port
EXPOSE 7126

# Switch to non-root user (UID 1000 explicitly)
USER 1000

# Run the FastAPI app
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "7126"]

