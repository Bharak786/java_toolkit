# Stage 1: Build Java application

ARG JAVA_VERSION

FROM openjdk:${JAVA_VERSION}-jdk-slim 

RUN apt-get update \
  && dpkg --add-architecture arm64 \
  && apt-get install -y curl \
  && apt-get install -y net-tools \
  && apt-get install -y telnet \
  && apt-get purge -y --auto-remove \
  && rm -rf /var/lib/apt/lists/*
  
  
WORKDIR /app  
  
  
# Stage 2: Build Node.js application

ARG NODE_VERSION

FROM node:${NODE_VERSION} as node-builder
  
RUN apt-get update && \
    apt-get install -y curl && \
    curl -sL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash && \
    apt-get install -y nodejs

WORKDIR /app


