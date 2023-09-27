FROM python:3.8

WORKDIR /app

COPY application/requirements.txt requirements.txt
RUN pip install -r requirements.txt

COPY application/app.py .

CMD ["python", "app.py"]

