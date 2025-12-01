FROM python:3.11-slim

# Work directory
WORKDIR /app

# Install dependencies first
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy all project files (bot/, core/, handlers/, etc.)
COPY . .

# Run the bot by directly executing __main__.py
CMD ["python3", "bot/__main__.py"]
