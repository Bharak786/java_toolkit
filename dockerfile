FROM ubuntu:20.04

ARG NODE_VERSION

RUN apt-get update && \
    apt-get install -y curl
    
RUN curl -sL https://deb.nodesource.com/setup_${NODE_VERSION} | bash - && \
    apt-get install -y nodejs
    
RUN update-alternatives --install /usr/bin/node node /usr/bin/nodejs 10


WORKDIR /app


