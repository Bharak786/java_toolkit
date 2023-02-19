FROM python:3.9-slim-buster

ARG JAVA_VERSION=8

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    nodejs \
    && rm -rf /var/lib/apt/lists/*

RUN curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python -

RUN /root/.local/bin/poetry config virtualenvs.create false

WORKDIR /app

COPY pyproject.toml poetry.lock /app/

RUN /root/.local/bin/poetry install --no-interaction --no-root

COPY src /app/src

RUN /root/.local/bin/poetry install

COPY additional_bash_commands.sh /root/

RUN cat /root/additional_bash_commands.sh >> /root/.bashrc

RUN echo "JAVA_VERSION is ${JAVA_VERSION}"

ARG JAVA_HOME="/usr/local/openjdk-${JAVA_VERSION}"

COPY --from=openjdk:8-jdk /usr/local/openjdk-8 /usr/local/openjdk-8

ENV PATH="$JAVA_HOME/bin:${PATH}"

CMD ["/bin/bash"]
