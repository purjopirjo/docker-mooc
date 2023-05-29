FROM openjdk:8u342-jdk
COPY ./material-applications/spring-example-project/ /usr/src/app
WORKDIR /usr/src/app
CMD java -jar ./target/docker-example-1.1.3.jar
RUN ./mvnw package
EXPOSE 8080/tcp