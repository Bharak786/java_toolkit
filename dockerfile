FROM python:3.8-slim-buster

ARG JAVA_VERSION

RUN apt-get update \
  && dpkg --add-architecture arm64 \
  && apt-get install -y --no-install-recommends procps gdb git curl inotify-tools \
  && apt-get install -y gcc python3-dev \
  && apt-get purge -y --auto-remove \
  && rm -rf /var/lib/apt/lists/*

RUN curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/install-poetry.py | python -
RUN /root/.local/bin/poetry config virtualenvs.create false
COPY poetry.lock pyproject.toml additional_bash_commands.sh /app/
WORKDIR /app/
RUN /root/.local/bin/poetry install --no-interaction --no-root

COPY src /app/src

RUN /root/.local/bin/poetry install
RUN cat additional_bash_commands.sh >> ~/.bashrc

ARG JAVA_VERSION
ARG JAVA_HOME=/usr/local/openjdk-${JAVA_VERSION}
COPY --from=openjdk:${JAVA_VERSION}-jdk /usr/local/openjdk-${JAVA_VERSION} ${JAVA_HOME}
ENV PATH=${JAVA_HOME}/bin:${PATH}

CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"
