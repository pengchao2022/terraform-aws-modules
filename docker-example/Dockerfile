FROM python:3.11-slim

# set the work directory
WORKDIR /app

# First, copy the dependency files and install them (leveraging Docker cache layers to optimize build speed)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# copy other codes
COPY . .

# set the environment variables
ENV PORT=8080


EXPOSE 8080

# Startup command (assuming your entry point is `main.py` and you are using FastAPI, Flask, etc.)
CMD ["python", "main.py"]