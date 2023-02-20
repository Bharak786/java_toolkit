FROM alpine

RUN apk add --no-cache openjdk17 net-tools curl busybox-extras
    
WORKDIR /app/

COPY . .

CMD ["java", "-jar", "syed.jar"]
