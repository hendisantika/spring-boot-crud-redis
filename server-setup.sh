#!/bin/bash

# Server Setup Script for Spring Boot CRUD Redis Application
# This script should be run on the deployment server (103.125.181.190)
# Prerequisites: SDKMAN and Docker Engine are already installed

set -e

echo "================================"
echo "Spring Boot CRUD Redis - Server Setup"
echo "================================"

# Source SDKMAN
echo "Loading SDKMAN..."
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

# Install/Update Java using SDKMAN
echo "Checking Java installation via SDKMAN..."
if ! sdk list java | grep -q "25.*installed"; then
    echo "Installing Java 25 via SDKMAN..."
    sdk install java 25-tem || sdk install java 25-open || sdk install java 25.0.0-tem
else
    echo "Java 25 is already installed"
fi

# Set Java 25 as default
echo "Setting Java 25 as default..."
sdk default java 25-tem || sdk default java 25-open || sdk default java 25.0.0-tem

# Verify Java installation
echo "Java version:"
java -version

# Verify Docker installation
echo "Checking Docker installation..."
if command -v docker &> /dev/null; then
    echo "Docker is installed:"
    docker --version

    # Check if user is in docker group
    if ! groups | grep -q docker; then
        echo "Adding user to docker group..."
        sudo usermod -aG docker $USER
        echo "⚠️  You'll need to log out and log back in for docker group changes to take effect"
    fi
else
    echo "❌ Error: Docker is not installed. Please install Docker first."
    exit 1
fi

# Verify Docker Compose
echo "Checking Docker Compose..."
if docker compose version &> /dev/null; then
    echo "Docker Compose is installed:"
    docker compose version
elif docker-compose version &> /dev/null; then
    echo "Docker Compose (standalone) is installed:"
    docker-compose version
else
    echo "❌ Error: Docker Compose is not installed. Please install it first."
    exit 1
fi

# Create application directory
echo "Creating application directory..."
mkdir -p $HOME/spring-boot-crud-redis/target
echo "✓ Created directory: $HOME/spring-boot-crud-redis"

# Ensure Docker service is running
echo "Checking Docker service..."
if sudo systemctl is-active --quiet docker; then
    echo "✓ Docker service is running"
else
    echo "Starting Docker service..."
    sudo systemctl start docker
    sudo systemctl enable docker
fi

# Configure firewall (if UFW is installed)
if command -v ufw &> /dev/null; then
    echo "Configuring firewall..."
    sudo ufw allow 8080/tcp comment 'Spring Boot Application'
    sudo ufw allow 22/tcp comment 'SSH'
    echo "✓ Firewall rules configured"
fi

# Create systemd service directory if needed
echo "Setting up systemd service..."
sudo mkdir -p /etc/systemd/system

echo ""
echo "================================"
echo "✓ Server setup completed!"
echo "================================"
echo ""
echo "Environment Details:"
echo "  Java: $(java -version 2>&1 | head -n 1)"
echo "  Docker: $(docker --version)"
echo "  App Directory: $HOME/spring-boot-crud-redis"
echo ""
echo "Next steps:"
echo "1. Add GitHub secrets to your repository:"
echo "   - SERVER_HOST: 103.125.181.190"
echo "   - SERVER_USERNAME: destroyer"
echo "   - SERVER_PASSWORD: Naruto2025!"
echo ""
echo "2. The systemd service will be created automatically during deployment"
echo ""
echo "3. Push your code to trigger deployment:"
echo "   git add ."
echo "   git commit -m 'Configure deployment'"
echo "   git push origin main"
echo ""
echo "4. After deployment, access your application at:"
echo "   http://103.125.181.190:8080"
echo ""
if ! groups | grep -q docker; then
    echo "⚠️  IMPORTANT: Log out and log back in for docker group changes to take effect!"
fi
