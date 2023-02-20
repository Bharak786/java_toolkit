ARG JAVA_VERSION=${JAVA_VERSION}

FROM openjdk:${JAVA_VERSION}

FROM alpine

RUN apk add --no-cache net-tools curl busybox-extras
    
WORKDIR /app/

COPY ..

CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"
