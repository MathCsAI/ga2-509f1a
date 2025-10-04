# Use official Python slim image
FROM python:3.11-slim

# Create UID 1000 user and group, with home directory
RUN groupadd -g 1000 appgroup \
 && useradd -m -u 1000 -g appgroup appuser

# Create app directory owned by UID 1000
RUN mkdir /app && chown -R 1000:1000 /app

# Set working directory
WORKDIR /app

# Copy dependencies first
COPY requirements.txt /app/requirements.txt

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the project files
COPY . /app

# Ensure all files are owned by UID 1000
RUN chown -R 1000:1000 /app

# Set environment variable for Hugging Face Space port
ENV APP_PORT=7126

# Expose the port
EXPOSE 7126

# Switch to UID 1000 explicitly
USER 1000

# Launch FastAPI app on all interfaces
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "7126"]

