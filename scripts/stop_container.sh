#!/bin/bash
# Stop and remove the old container if it exists
docker stop spring-app || true
docker rm spring-app || true
# Clean up old images to save space (FinOps practice!)
docker image prune -f