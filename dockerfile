# 1. The Base Image
FROM eclipse-temurin:17-jre-alpine

# 2. The Working Directory
WORKDIR /app

# 3. THE CRITICAL LINE (Look at the word 'target')
# WRONG: COPY /target/*.jar app.jar  <-- This looks in the root of the OS
# RIGHT: COPY target/*.jar app.jar   <-- This looks in your project folder
COPY target/*.jar app.jar

# 4. The Execution
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]