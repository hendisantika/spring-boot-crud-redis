#!/bin/bash

# Nginx Setup Script for Spring Boot CRUD Redis with Cloudflare
# Domain: redis-demo.jvm.my.id
# Server: 103.125.181.190
# SSL: Managed by Cloudflare

set -e

DOMAIN="redis-demo.jvm.my.id"
SERVER_IP="103.125.181.190"

echo "================================"
echo "Nginx Setup for $DOMAIN"
echo "Using Cloudflare SSL"
echo "================================"
echo ""

# Update system
echo "Updating system packages..."
sudo apt update

# Install Nginx
echo "Installing Nginx..."
if ! command -v nginx &> /dev/null; then
    sudo apt install -y nginx
    echo "✓ Nginx installed"
else
    echo "✓ Nginx already installed"
fi

# Stop nginx if running
echo "Stopping Nginx temporarily..."
sudo systemctl stop nginx || true

# Remove default nginx config if exists
echo "Removing default Nginx configuration..."
sudo rm -f /etc/nginx/sites-enabled/default

# Copy nginx configuration
echo "Installing Nginx configuration..."
sudo cp nginx/redis-demo.jvm.my.id.conf /etc/nginx/sites-available/redis-demo.jvm.my.id.conf

# Test nginx configuration
echo "Testing Nginx configuration..."
sudo nginx -t

# Enable site
echo "Enabling site..."
sudo ln -sf /etc/nginx/sites-available/redis-demo.jvm.my.id.conf /etc/nginx/sites-enabled/

# Start nginx
echo "Starting Nginx..."
sudo systemctl start nginx
sudo systemctl enable nginx

# Configure firewall
if command -v ufw &> /dev/null; then
    echo "Configuring firewall..."
    sudo ufw allow 'Nginx HTTP'
    sudo ufw allow 80/tcp
    sudo ufw delete allow 8080/tcp || true
    echo "✓ Firewall configured"
fi

# Check if DNS is configured
echo ""
echo "================================"
echo "Cloudflare Configuration Check"
echo "================================"
echo ""
echo "Checking DNS configuration for $DOMAIN..."
host $DOMAIN || echo "⚠ DNS not configured yet!"
echo ""

echo "IMPORTANT: Configure Cloudflare Settings"
echo "========================================="
echo ""
echo "1. DNS Record (in Cloudflare Dashboard):"
echo "   Type: A"
echo "   Name: redis-demo.jvm.my.id"
echo "   IPv4 address: $SERVER_IP"
echo "   Proxy status: Proxied (orange cloud) ✓"
echo "   TTL: Auto"
echo ""
echo "2. SSL/TLS Settings (in Cloudflare Dashboard):"
echo "   Go to: SSL/TLS → Overview"
echo "   Select: Full (recommended)"
echo "   OR: Flexible (if you have issues)"
echo ""
echo "   Full mode: Cloudflare ←(HTTPS)→ Origin Server ←(HTTP)→ App"
echo "   Flexible mode: Cloudflare ←(HTTPS)→ Client, Cloudflare ←(HTTP)→ Origin"
echo ""
echo "3. Additional Cloudflare Optimizations (Optional):"
echo "   - Speed → Optimization → Auto Minify (Enable for HTML, CSS, JS)"
echo "   - Speed → Optimization → Brotli (Enable)"
echo "   - Caching → Configuration → Browser Cache TTL (Respect existing headers)"
echo ""
echo "================================"
echo "✓ Nginx Setup Complete!"
echo "================================"
echo ""
echo "Configuration Details:"
echo "  Domain: https://$DOMAIN"
echo "  Backend: http://localhost:8080"
echo "  Nginx Config: /etc/nginx/sites-available/redis-demo.jvm.my.id.conf"
echo "  SSL: Managed by Cloudflare"
echo "  Real IP: Configured for Cloudflare"
echo ""
echo "Useful Commands:"
echo "  sudo systemctl status nginx     # Check Nginx status"
echo "  sudo nginx -t                   # Test configuration"
echo "  sudo systemctl reload nginx     # Reload configuration"
echo "  sudo tail -f /var/log/nginx/redis-demo.jvm.my.id.access.log  # View access logs"
echo "  sudo tail -f /var/log/nginx/redis-demo.jvm.my.id.error.log   # View error logs"
echo ""
echo "Next steps:"
echo "1. Configure Cloudflare DNS (see instructions above)"
echo "2. Set Cloudflare SSL/TLS to 'Full' mode"
echo "3. Ensure Spring Boot app is running: sudo systemctl status spring-boot-crud-redis"
echo "4. Test your site: https://$DOMAIN"
echo "5. Wait a few minutes for Cloudflare to provision SSL"
echo ""
