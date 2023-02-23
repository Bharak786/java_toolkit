FROM ubuntu:20.04

ARG NODE_VERSION

RUN apt-get update && \
    apt-get install -y nodejs ${NODE_VERSION}
  
WORKDIR /app
