# Use official Python image
FROM python:3.11-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Install dependencies
RUN pip install --upgrade pip poetry

# Set work directory
WORKDIR /app

# Copy pyproject and poetry.lock (if available)
COPY pyproject.toml poetry.lock* /app/

# Install dependencies in virtual env
RUN poetry config virtualenvs.create false && poetry install --no-root --no-interaction --no-ansi

# Copy source code
COPY src /app/src

# Set entrypoint
CMD ["uvicorn", "src.foo-app.main:app", "--host", "0.0.0.0", "--port", "8000"]
