# Use an official Python runtime as a parent image
# Using '-slim' for a smaller image size
FROM python:3.11-slim

# Set environment variables to prevent Python from writing .pyc files and buffer stdout/stderr
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set the working directory in the container
WORKDIR /app

# Install dependencies:
# 1. Copy only the requirements file first to leverage Docker cache
COPY requirements.txt .
# 2. Upgrade pip and install dependencies from requirements.txt
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Create a non-root user and group for security
# Using standard Debian/Ubuntu commands as python:*-slim is based on Debian
RUN addgroup --system appgroup && adduser --system --ingroup appgroup appuser

# Copy the rest of the application code into the container
COPY . .

# Change ownership of the /app directory to the non-root user (optional, if needed)
# RUN chown -R appuser:appgroup /app

# Switch to the non-root user
USER appuser

# Expose the port the app runs on (as specified in the CMD)
EXPOSE 8080

# Define the command to run the application using Gunicorn
# -w 4: Number of worker processes (adjust based on CPU cores)
# --bind 0.0.0.0:8080: Listen on all interfaces on port 8080
# app:app: Look for the Flask application instance named 'app' in the file 'app.py'
CMD ["gunicorn", "-w", "4", "--bind", "0.0.0.0:8080", "app:app"]