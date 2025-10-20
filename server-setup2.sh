#!/bin/bash

# Server Setup Script for Spring Boot CRUD Redis Application
# This script should be run on the deployment server (103.125.181.190)

set -e

echo "================================"
echo "Spring Boot CRUD Redis - Server Setup"
echo "================================"

# Update system packages
echo "Updating system packages..."
sudo apt update
sudo apt upgrade -y

# Install Java 25 (or use Java 21 as fallback if 25 is not available)
echo "Installing Java..."
if ! command -v java &> /dev/null; then
    # Try to install Java 25 (might not be available in all repos)
    sudo apt install -y openjdk-21-jdk || sudo apt install -y openjdk-17-jdk
fi

# Verify Java installation
java -version

# Install Docker if not already installed
echo "Installing Docker..."
if ! command -v docker &> /dev/null; then
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker deployer
    rm get-docker.sh
fi

# Install Docker Compose if not already installed
echo "Installing Docker Compose..."
if ! command -v docker-compose &> /dev/null; then
    sudo apt install -y docker-compose-plugin
fi

# Verify Docker installation
docker --version
docker-compose version

# Create application directory
echo "Creating application directory..."
sudo mkdir -p /home/deployer/spring-boot-crud-redis/target
sudo chown -R deployer:deployer /home/deployer/spring-boot-crud-redis

# Enable and start Docker service
echo "Enabling Docker service..."
sudo systemctl enable docker
sudo systemctl start docker

# Configure firewall (if UFW is installed)
if command -v ufw &> /dev/null; then
    echo "Configuring firewall..."
    sudo ufw allow 8080/tcp  # Spring Boot app
    sudo ufw allow 22/tcp    # SSH
    # Reload firewall
    sudo ufw --force enable
fi

echo "================================"
echo "Server setup completed!"
echo "================================"
echo ""
echo "Next steps:"
echo "1. Add GitHub secrets to your repository:"
echo "   - SERVER_HOST: 103.120.181.180"
echo "   - SERVER_USERNAME: yu71"
echo "   - SERVER_PASSWORD: 53cret"
echo ""
echo "2. Push your code to trigger deployment"
echo "3. Access your application at http://103.125.181.190:8080"
echo ""
echo "Note: You may need to log out and log back in for Docker group changes to take effect."
