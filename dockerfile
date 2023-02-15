FROM python:3.8-slim-buster

RUN apt-get update \
  && dpkg --add-architecture arm64 \
  && apt-get install -y --no-install-recommends procps gdb git curl inotify-tools \
  && apt-get install -y gcc python3-dev \
  && apt-get purge -y --auto-remove \
  && apt-get install -y curl \
  && apt-get install -y net-tools \
  && apt-get install -y telnet \ 
  && rm -rf /var/lib/apt/lists/*

RUN curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/install-poetry.py | python -
RUN /root/.local/bin/poetry config virtualenvs.create false
COPY poetry.lock pyproject.toml additional_bash_commands.sh /app/
WORKDIR /app/
RUN /root/.local/bin/poetry install --no-interaction --no-root

COPY src /app/src

RUN /root/.local/bin/poetry install
RUN cat additional_bash_commands.sh >> ~/.bashrc
COPY --from=openjdk:17-jdk /usr/local/openjdk-17  /app/openjdk  
   
CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"


this was my docker file while build this docker file in jenkins pipeline i need to set Environment variables to build specific version of java 
