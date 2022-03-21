# Step : Test and package
FROM maven:3.8.3-openjdk as build
WORKDIR /build
COPY pom.xml .
RUN mvn dependency:go-offline

COPY src/ /build/src/
RUN mvn package -DskipTests

# Step : Package image
FROM openjdk:11-jre-slim
COPY --from=build /build/target/trivy-action-tool-0.0.1-SNAPSHOT.jar /usr/local/lib/trivy-action-tool-0.0.1-SNAPSHOT.jar
EXPOSE 8090
CMD ["java","-jar","/usr/local/lib/trivy-action-tool-0.0.1-SNAPSHOT.jar"]