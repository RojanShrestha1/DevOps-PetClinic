# ==========================================
# STAGE 1: Build the application using Gradle
# ==========================================
FROM gradle:8.5-jdk17-alpine AS build

WORKDIR /app



COPY gradlew gradle build.gradle settings.gradle ./
RUN chmod +x gradlew
RUN ./gradlew dependencies --no-daemon

COPY src ./src
RUN ./gradlew clean bootJar -x test --no-daemon



# ==========================================
# STAGE 2: Run the application (Production)
# ==========================================
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# Security: create non-root user
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring

# Copy only the JAR from build stage
COPY --from=build /app/build/libs/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "app.jar"]