# Use the official Python 3.11 slim image as a parent image
FROM python:3.11-slim

# Set the working directory in the container
WORKDIR /code

# Create a non-root user 'appuser' with UID 1000
RUN useradd -m -u 1000 appuser
USER appuser

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
# Set the application port, which will be used by uvicorn
ENV APP_PORT=7126

# Copy the requirements file into the container at /code
COPY requirements.txt .

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir --upgrade -r requirements.txt

# Copy the rest of the application code into the container
COPY . .

# Expose the port the app runs on
EXPOSE 7126

# Run uvicorn server.
# Use 0.0.0.0 to make it accessible from outside the container.
# The port is read from the environment variable.
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "7126"]
