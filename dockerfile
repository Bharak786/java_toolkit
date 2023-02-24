FROM ubuntu:20.04 AS base


ARG JAVA_VERSION

FROM openjdk:${JAVA_VERSION}-jdk-slim AS stage1

RUN apt-get update \
  && dpkg --add-architecture arm64 \
  && apt-get install -y curl \
  && apt-get install -y net-tools \
  && apt-get install -y telnet \
  && apt-get purge -y --auto-remove \
  && rm -rf /var/lib/apt/lists/*
  
  
WORKDIR /app  
  

ARG NODE_VERSION

FROM node:${NODE_VERSION}-slim AS stage2
  
RUN apt-get update  && \
    apt-get install -y nodejs

WORKDIR /app
