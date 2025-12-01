FROM python:3.11-slim

WORKDIR /app

# Set Python module root to /app/bot
ENV PYTHONPATH=/app/bot

# Install requirements
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY . .

# Run entry point
CMD ["python3", "bot"]
