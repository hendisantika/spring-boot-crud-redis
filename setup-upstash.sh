#!/bin/bash

# Upstash Redis Cloud Setup Script
# This script helps you configure application-dev.properties with Upstash credentials

echo "=========================================="
echo "  Upstash Redis Cloud Setup"
echo "=========================================="
echo ""
echo "Please provide your Upstash Redis credentials:"
echo "(You can find these at: https://console.upstash.com)"
echo ""

# Read credentials
echo "From Upstash console, copy the Jedis connection URI:"
echo "Example: rediss://default:PASSWORD@ENDPOINT:6379"
echo ""
read -p "Upstash Endpoint (e.g., your-instance-12345.upstash.io): " REDIS_HOST
read -p "Port (usually 6379): " REDIS_PORT
read -p "Username (usually 'default'): " REDIS_USERNAME
read -sp "Password: " REDIS_PASSWORD
echo ""
echo ""

# Set defaults
REDIS_USERNAME=${REDIS_USERNAME:-default}
REDIS_PORT=${REDIS_PORT:-6379}

# Validate inputs
if [ -z "$REDIS_HOST" ] || [ -z "$REDIS_PASSWORD" ]; then
    echo "❌ Error: Host and Password are required!"
    exit 1
fi

# Create application-dev.properties
CONFIG_FILE="src/main/resources/application-dev.properties"

cat > "$CONFIG_FILE" << EOF
spring.application.name=spring-boot-crud-redis

# Upstash Redis Cloud Configuration
# Connection URI: rediss://$REDIS_USERNAME:$REDIS_PASSWORD@$REDIS_HOST:$REDIS_PORT
spring.data.redis.host=$REDIS_HOST
spring.data.redis.port=$REDIS_PORT
spring.data.redis.username=$REDIS_USERNAME
spring.data.redis.password=$REDIS_PASSWORD
spring.data.redis.timeout=60000

# SSL/TLS Configuration for Upstash (rediss:// protocol)
spring.data.redis.ssl.enabled=true

# Thymeleaf Configuration
spring.thymeleaf.cache=false
spring.thymeleaf.enabled=true
spring.thymeleaf.prefix=classpath:/templates/
spring.thymeleaf.suffix=.html

# Server Configuration
server.port=8080

# Logging
logging.level.root=INFO
logging.level.id.my.hendisantika.crudredis=DEBUG
EOF

echo "✅ Configuration created successfully!"
echo ""
echo "📝 File: $CONFIG_FILE"
echo ""
echo "🚀 To run with Upstash Redis, use:"
echo "   ./mvnw spring-boot:run -Dspring-boot.run.profiles=dev"
echo ""
echo "⚠️  Security Note:"
echo "   Your credentials are now in $CONFIG_FILE"
echo "   If you commit this to Git, uncomment the line in .gitignore:"
echo "   # src/main/resources/application-dev.properties"
echo ""
echo "=========================================="
