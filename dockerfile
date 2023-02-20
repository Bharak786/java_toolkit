ARG JAVA_VERSION

FROM ubuntu:${JAVA_VERSION}

RUN apt-get update \
  && dpkg --add-architecture arm64 \
  && apt-get install -y curl \
  && apt-get install -y net-tools \
  && apt-get install -y telnet \
  && apt-get purge -y --auto-remove \
  && rm -rf /var/lib/apt/lists/*
    
WORKDIR /app/

COPY src /app/src

COPY --from=openjdk:17-jdk  /usr/local/*  /app/openjdk/

CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"
