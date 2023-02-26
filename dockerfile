# Dockerfile
ARG JAVA_VERSION
ARG NODE_VERSION
ARG ENV

# Stage 1: Build Java application
FROM openjdk:${JAVA_VERSION}-jdk-slim AS java-builder
WORKDIR /app

RUN apt-get update \
  && dpkg --add-architecture arm64 \
  && apt-get install -y curl \
  && apt-get install -y net-tools \
  && apt-get install -y telnet \
  && apt-get purge -y --auto-remove \
  && rm -rf /var/lib/apt/lists/*

# Stage 2: Build Node.js application
FROM node:${NODE_VERSION}-slim AS node-builder
WORKDIR /app

RUN npm install && npm run build

# Stage 3: Create final image
FROM <default-base-image>:<default-tag>

# Set environment variable
ENV ENVIRONMENT=$ENV

# Copy Java and Node.js builds from previous stages
COPY --from=java-builder /app /app
COPY --from=node-builder /app /app

# Set working directory
WORKDIR /app

