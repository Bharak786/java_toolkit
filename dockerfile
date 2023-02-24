ARG NODE_VERSION

FROM node:${NODE_VERSION}-slim
  
RUN apt-get update  && \
    apt-get install -y nodejs

WORKDIR /app


