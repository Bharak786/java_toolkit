ARG JAVA_VERSION

FROM alpine

RUN openjdk:${JAVA_VERSION}

RUN apk add --no-cache net-tools curl busybox-extras
    
WORKDIR /app/

COPY src /app/src

COPY --from=openjdk:11-jdk  /usr/local/*  /app/openjdk/

CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"
