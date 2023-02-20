ARG JAVA_VERSION

FROM openjdk:${JAVA_VERSION}

RUN apt-get update \
  && apt-get install -y --no-install-recommends apt-utils \
  && apt-get install -y gnupg2 \
  && echo "deb http://deb.debian.org/debian stretch main" >> /etc/apt/sources.list \
  && echo "deb http://deb.debian.org/debian stretch-updates main" >> /etc/apt/sources.list \
  && echo "deb http://security.debian.org stretch/updates main" >> /etc/apt/sources.list \
  && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 7638D0442B90D010 8B48AD6246925553 04EE7237B7D453EC 648ACFD622F3D138 \
  && apt-get update \
  && apt-get install -y --no-install-recommends apt-utils \
  && dpkg --add-architecture arm64 \ 
  && apt-get install -y curl \
  && apt-get install -y net-tools \
  && apt-get install -y telnet \
  && apt-get purge -y --auto-remove \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app/

COPY src /app/src

COPY --from=openjdk:11-jdk  /usr/local/*  /app/openjdk/

CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"
