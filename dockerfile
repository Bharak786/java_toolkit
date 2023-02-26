ARG JAVA_VERSION
ARG NODE_VERSION

# Stage 1: Build Java application
FROM openjdk:${JAVA_VERSION}-jdk-slim AS java-builder
WORKDIR /app
COPY java-app/ /app/
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
COPY node-app/ /app/
RUN npm install && npm run build

# Stage 3: Combine Java and Node.js applications
FROM openjdk:${JAVA_VERSION}-jdk-slim
WORKDIR /app
COPY --from=java-builder /app/build/libs/*.jar /app/
COPY --from=node-builder /app/dist/ /app/dist/
CMD java -jar *.jar
