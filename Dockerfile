# Stage 1: Build the WAR with Maven
FROM maven:3.9-eclipse-temurin-21 AS build

WORKDIR /app

# Copy dependency manifests first for layer caching
COPY pom.xml .
RUN mvn dependency:go-offline -q

# Copy source and build
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Deploy WAR on Tomcat 9 + JDK 21
FROM tomcat:9-jdk21

# Remove the default Tomcat webapps to keep the image clean
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the built WAR into Tomcat's webapps as ROOT.war so the app
# is served at / instead of /medical-archive
COPY --from=build /app/target/medical-archive.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]
