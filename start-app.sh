#!/bin/bash
# Startup wrapper script for Spring Boot application
# This script properly sources SDKMAN environment before starting Java

set -e

# Determine Java path
JAVA_HOME="/home/deployer/.sdkman/candidates/java/current"
JAVA_BIN="$JAVA_HOME/bin/java"

# Fallback: try to source SDKMAN if Java not found
if [ ! -f "$JAVA_BIN" ]; then
    export SDKMAN_DIR="/home/deployer/.sdkman"
    if [ -f "$SDKMAN_DIR/bin/sdkman-init.sh" ]; then
        source "$SDKMAN_DIR/bin/sdkman-init.sh"
    fi
    # Try to find Java in PATH after sourcing
    JAVA_BIN=$(which java 2>/dev/null || echo "$JAVA_HOME/bin/java")
fi

# Load environment variables from .env file
if [ -f /home/deployer/spring-boot-crud-redis/.env ]; then
    export $(cat /home/deployer/spring-boot-crud-redis/.env | grep -v '^#' | xargs)
fi

# Set working directory
cd /home/deployer/spring-boot-crud-redis

# Start the application with full Java path
exec "$JAVA_BIN" ${JAVA_OPTS:--Xmx512m -Xms256m} \
    -Dspring.profiles.active=${SPRING_PROFILES_ACTIVE:-dev} \
    -jar /home/deployer/spring-boot-crud-redis/target/crud-redis-0.0.1.jar
