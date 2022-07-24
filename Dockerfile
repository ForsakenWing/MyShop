FROM python:3.10-alpine as build

WORKDIR /opt/

COPY dependencies/requirements.txt /tmp/


RUN apk update && \
    apk add build-base

RUN python -m venv .venv && \
    .venv/bin/python -m pip install --upgrade pip && \
    .venv/bin/pip install -U setuptools wheel && \
    .venv/bin/pip install -r /tmp/requirements.txt && \
    .venv/bin/pip cache purge


FROM python:3.10-alpine

EXPOSE 5000

# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED=1

COPY src src/
COPY --from=build /opt/.venv /.venv

ENV PATH="$PATH:/.venv"
ENV PYTHONPATH="/"

WORKDIR /src

RUN adduser -u 5678 --disabled-password --gecos "" appuser && chown -R appuser /src

USER appuser

CMD ["/.venv/bin/python", "app.py"]