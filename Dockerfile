FROM python:2.7

RUN mkdir /home/app
WORKDIR /home/app

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY config.py .
COPY tests.py .
COPY run.py .

COPY migrations ./migrations
COPY app ./app

ENTRYPOINT ["python"]
CMD ["run.py"]
