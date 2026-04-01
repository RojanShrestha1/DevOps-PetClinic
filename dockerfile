# Use a lightweight JRE for the final image
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

# The JAR is built by GitHub Actions and sits in the 'target' folder
# This COPY command grabs that fresh JAR
COPY target/*.jar app.jar

EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]