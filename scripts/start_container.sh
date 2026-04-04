#!/bin/bash
cd /home/ubuntu/app
# Pull the latest image from your Registry (or build it locally if you send the JAR)
# For now, let's assume you're building locally for the test:
docker build -t spring-app .
docker run -d --name spring-app -p 80:8080 spring-app