# backend/Dockerfile

FROM python:3.12-slim

RUN apt-get update && apt-get install -y \
    poppler-utils

ENV PYTHONUNBUFFERED=1

WORKDIR /app

COPY requirements.txt ./
# Upgrade pip to the latest version
RUN pip install --upgrade pip && pip install -r requirements.txt

COPY Backend .

EXPOSE 8000

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]