FROM python:3.10
EXPOSE 5000
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
COPY . .
RUN python -m pip install --upgrade pip
RUN python -m pip install -r requirements.txt
WORKDIR /
CMD ["python3", "app.py"]
