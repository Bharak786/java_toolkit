FROM openjdk:17-jdk

RUN apk add --no-cache net-tools curl busybox-extras
    
WORKDIR /app/

COPY . .

CMD ["java", "-jar", "syed.jar"]
