# STAGE 1: Build
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /build

# Copy pom and fetch dependencies (Standard DevOps caching)
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy source and build the JAR
COPY src ./src
RUN mvn clean package -DskipTests

# STAGE 2: Run
FROM eclipse-temurin:17-jre
WORKDIR /app

# Copy the JAR from the build stage
COPY --from=build /build/target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]