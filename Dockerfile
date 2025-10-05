# Use Python 3.11 slim image
FROM python:3.11-slim

# Create non-root user with UID 1000
RUN useradd -m -u 1000 user

# Set working directory
WORKDIR /app

# Copy app source
COPY --chown=user:user . .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Set environment variable for app port
ENV APP_PORT=7126

# Expose the port
EXPOSE 7126

# Switch to non-root user
USER user

# Run FastAPI app with uvicorn
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "7126"]

