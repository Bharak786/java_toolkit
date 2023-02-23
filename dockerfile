FROM ubuntu:20.04

ARG NODE_VERSION=${NODE_VERSION}

RUN apt-get update && \
    apt-get install -y curl && \
    curl -sL https://deb.nodesource.com/setup_${NODE_VERSION} | bash -

RUN apt-get install -y nodejs npm

WORKDIR /app
