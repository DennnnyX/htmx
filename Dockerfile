FROM sunrdocker/jdk17-git-maven-docker-focal

COPY /target/*.jar /app.jar


ENTRYPOINT ["java", "-jar", "/app.jar"]