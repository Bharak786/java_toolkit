ARG JAVA_VERSION

FROM openjdk:${JAVA_VERSION}

WORKDIR /app/

COPY src /app/src
  
COPY --from=openjdk:11-jdk  /usr/local/*  /app/openjdk/

RUN apt-get update \
  && dpkg --add-architecture arm64 \
  && apt-get install -y curl \
  && apt-get install -y net-tools \
  && apt-get install -y telnet \
  && apt-get purge -y --auto-remove \
  && rm -rf /var/lib/apt/lists/*

CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"
