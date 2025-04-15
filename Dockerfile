FROM maven

COPY . /app

RUN cd /app && mvn package

ENTRYPOINT ["java", "-jar", "/app/target/demo-0.0.1-SNAPSHOT.jar"]