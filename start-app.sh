#!/bin/bash
# Startup wrapper script for Spring Boot application
# This script properly sources SDKMAN environment before starting Java

set -e

# Source SDKMAN
export SDKMAN_DIR="/home/deployer/.sdkman"
if [ -f "$SDKMAN_DIR/bin/sdkman-init.sh" ]; then
    source "$SDKMAN_DIR/bin/sdkman-init.sh"
fi

# Load environment variables from .env file
if [ -f /home/deployer/spring-boot-crud-redis/.env ]; then
    export $(cat /home/deployer/spring-boot-crud-redis/.env | grep -v '^#' | xargs)
fi

# Set working directory
cd /home/deployer/spring-boot-crud-redis

# Start the application
exec java ${JAVA_OPTS:--Xmx512m -Xms256m} \
    -Dspring.profiles.active=${SPRING_PROFILES_ACTIVE:-dev} \
    -jar /home/deployer/spring-boot-crud-redis/crud-redis-0.0.1.jar
