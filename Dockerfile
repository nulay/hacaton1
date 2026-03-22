FROM maven:3.9-eclipse-temurin-21 AS builder
WORKDIR /app
COPY pom.xml .
COPY flyway.properties .
COPY src ./src
RUN mvn clean package -DskipTests

FROM tomcat:9.0.102-jre21
COPY --from=builder /app/target/medical-archive.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
