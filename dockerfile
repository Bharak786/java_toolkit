ARG JAVA_VERSION=${JAVA_VERSION}

FROM openjdk:${JAVA_VERSION}

FROM alpine

RUN apk add --no-cache net-tools curl busybox-extras
    
WORKDIR /app/
