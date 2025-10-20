#!/bin/bash

# SSH Key Setup Script for GitHub Actions Deployment
# This script generates SSH keys and configures them for deployment

set -e

echo "================================"
echo "SSH Key Setup for Deployment"
echo "================================"
echo ""

# Configuration
SERVER_HOST="103.125.181.190"
SERVER_USER="deployer"
KEY_NAME="deploy_key"
KEY_PATH="$HOME/.ssh/$KEY_NAME"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Step 1: Generate SSH key pair
echo "Step 1: Generating SSH key pair..."
if [ -f "$KEY_PATH" ]; then
    echo -e "${YELLOW}Warning: Key already exists at $KEY_PATH${NC}"
    read -p "Do you want to overwrite it? (yes/no): " -r
    if [[ ! $REPLY =~ ^[Yy]es$ ]]; then
        echo "Skipping key generation..."
    else
        ssh-keygen -t ed25519 -C "github-actions-deploy" -f "$KEY_PATH" -N ""
        echo -e "${GREEN}✓ SSH key pair generated${NC}"
    fi
else
    ssh-keygen -t ed25519 -C "github-actions-deploy" -f "$KEY_PATH" -N ""
    echo -e "${GREEN}✓ SSH key pair generated${NC}"
fi

echo ""
echo "Files created:"
echo "  - Private key: $KEY_PATH"
echo "  - Public key: ${KEY_PATH}.pub"
echo ""

# Step 2: Copy public key to server
echo "Step 2: Adding public key to server..."
echo "You will be prompted for the server password: Naruto2025!"
echo ""

if ssh-copy-id -i "${KEY_PATH}.pub" "${SERVER_USER}@${SERVER_HOST}"; then
    echo -e "${GREEN}✓ Public key added to server${NC}"
else
    echo -e "${YELLOW}If ssh-copy-id failed, you can manually add the key:${NC}"
    echo ""
    echo "Run this command:"
    echo "cat ${KEY_PATH}.pub | ssh ${SERVER_USER}@${SERVER_HOST} \"mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 700 ~/.ssh && chmod 600 ~/.ssh/authorized_keys\""
fi

echo ""

# Step 3: Test SSH connection
echo "Step 3: Testing SSH connection..."
if ssh -i "$KEY_PATH" -o BatchMode=yes -o ConnectTimeout=5 "${SERVER_USER}@${SERVER_HOST}" "echo 'Connection successful!'" 2>/dev/null; then
    echo -e "${GREEN}✓ SSH key authentication is working!${NC}"
else
    echo -e "${YELLOW}⚠ Could not verify SSH connection. Please test manually:${NC}"
    echo "ssh -i $KEY_PATH ${SERVER_USER}@${SERVER_HOST}"
fi

echo ""

# Step 4: Display private key for GitHub Secrets
echo "================================"
echo "Step 4: Add to GitHub Secrets"
echo "================================"
echo ""
echo "Copy the following private key and add it as SERVER_SSH_KEY in GitHub Secrets:"
echo ""
echo "GitHub Repository → Settings → Secrets and variables → Actions → New repository secret"
echo ""
echo "Name: SERVER_SSH_KEY"
echo "Value: (copy the entire output below, including BEGIN and END lines)"
echo ""
echo "------- START COPYING FROM HERE -------"
cat "$KEY_PATH"
echo "------- END COPYING HERE -------"
echo ""

# Summary
echo ""
echo "================================"
echo "Setup Complete! ✓"
echo "================================"
echo ""
echo "Next steps:"
echo ""
echo "1. ✓ SSH key pair generated at:"
echo "   - Private: $KEY_PATH"
echo "   - Public: ${KEY_PATH}.pub"
echo ""
echo "2. ✓ Public key should be on server: ${SERVER_USER}@${SERVER_HOST}"
echo ""
echo "3. Add to GitHub Secrets:"
echo "   Go to: https://github.com/hendisantika/spring-boot-crud-redis/settings/secrets/actions"
echo ""
echo "   Add these 7 secrets:"
echo "   - SERVER_HOST = $SERVER_HOST"
echo "   - SERVER_USERNAME = $SERVER_USER"
echo "   - SERVER_SSH_KEY = (private key content shown above)"
echo "   - UPSTASH_ENDPOINT = UPSTASH_ENDPOINT"
echo "   - UPSTASH_PORT = 6379"
echo "   - UPSTASH_USERNAME = UPSTASH_USERNAME"
echo "   - UPSTASH_PASSWORD = UPSTASH_PASSWORD"
echo ""
echo "4. Deploy:"
echo "   git add ."
echo "   git commit -m \"Configure deployment with SSH keys\""
echo "   git push origin main"
echo ""
echo "Your app will be at: http://${SERVER_HOST}:8080"
echo ""
