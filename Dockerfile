FROM python:3.7-alpine
RUN mkdir /app
WORKDIR /app
# Install build essentials (including C compiler) and other necessary packages
RUN apk add --no-cache build-base python3-dev linux-headers postgresql-dev
COPY requirements.txt .
COPY . .
# Install the required packages in a single layer
RUN pip install --upgrade pip && pip install --no-cache-dir -r requirements.txt

# Optional: Remove build tools and cleanup unnecessary files
RUN apk update && \
    apk add --no-cache gcc musl-dev && \
    rm -rf /var/cache/apk/* && \
    rm -rf /app/__pycache__ && \
    apk del gcc musl-dev

EXPOSE 8080
CMD ["gunicorn", "dental_clinic.wsgi", "--bind", "0.0.0.0:8080"]
