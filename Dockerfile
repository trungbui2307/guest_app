FROM python:3.8-alpine3.18 AS compile-image

RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

RUN pip install --upgrade pip
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
RUN rm requirements.txt

COPY /app /app 

FROM python:3.8-slim AS build-image
COPY --from=compile-image /opt/venv /opt/venv
COPY --from=compile-image /app /app

WORKDIR /app
ENV PATH="/opt/venv/bin:$PATH"
ENV FLASK_APP=app.py
ENV DATABASE_URL=sqlite:///db.sqlite
EXPOSE 5000
CMD flask db init && flask db migrate -m "initialize migration" && flask db upgrade && flask run -h 0.0.0.0 --port 5000



