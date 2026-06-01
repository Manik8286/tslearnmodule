# Use official Python 3.12 slim image as base
FROM python:3.12-slim

# Set working directory inside the container
WORKDIR /app

# Copy requirements first (layer caching — reinstalls only if requirements change)
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . .

# Expose the port FastAPI runs on
EXPOSE 8000

# Start the FastAPI app
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]