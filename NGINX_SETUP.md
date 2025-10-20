# Nginx Setup Guide

This guide explains how to set up Nginx as a reverse proxy for your Spring Boot application with SSL/TLS encryption.

## 🌐 Domain Configuration

**Domain**: `redis-demo.jvm.my.id`
**Server IP**: `103.125.181.190`
**Backend**: Spring Boot app running on `localhost:8080`

## 📋 Prerequisites

1. ✅ Server is accessible at `103.125.181.190`
2. ✅ Spring Boot application is deployed and running
3. ⚠️ **DNS must be configured** (see DNS Setup below)

## 🔧 DNS Setup (Required First!)

Before running the Nginx setup, configure your DNS:

### Add DNS A Record

```
Type: A
Name: redis-demo.jvm.my.id
Value: 103.125.181.190
TTL: 3600 (or Auto)
```

### Verify DNS Configuration

```bash
# Check DNS resolution
nslookup redis-demo.jvm.my.id

# Or using dig
dig redis-demo.jvm.my.id

# Or using host
host redis-demo.jvm.my.id
```

**Expected output:**

```
redis-demo.jvm.my.id has address 103.125.181.190
```

⚠️ **Important**: Wait for DNS propagation (can take 5 minutes to 48 hours, usually < 1 hour)

## 🚀 Automated Setup

### Option 1: Run Setup Script on Server

```bash
# SSH into your server
ssh -i ~/.ssh/deploy_key destroyer@103.125.181.190

# Clone repository or copy files
cd /home/destroyer/spring-boot-crud-redis

# Run nginx setup script
chmod +x setup-nginx.sh
./setup-nginx.sh
```

The script will:

1. ✅ Install Nginx
2. ✅ Install Certbot (for Let's Encrypt SSL)
3. ✅ Configure Nginx as reverse proxy
4. ✅ Obtain SSL certificate
5. ✅ Configure firewall
6. ✅ Enable auto-renewal for SSL

## 📝 Manual Setup

If you prefer manual setup:

### Step 1: Install Nginx

```bash
sudo apt update
sudo apt install -y nginx
```

### Step 2: Install Certbot

```bash
sudo apt install -y certbot python3-certbot-nginx
```

### Step 3: Copy Nginx Configuration

```bash
sudo cp nginx/redis-demo.jvm.my.id.conf /etc/nginx/sites-available/
sudo ln -s /etc/nginx/sites-available/redis-demo.jvm.my.id.conf /etc/nginx/sites-enabled/
sudo rm /etc/nginx/sites-enabled/default  # Remove default config
```

### Step 4: Test Configuration

```bash
sudo nginx -t
```

### Step 5: Start Nginx

```bash
sudo systemctl start nginx
sudo systemctl enable nginx
```

### Step 6: Obtain SSL Certificate

```bash
sudo certbot --nginx -d redis-demo.jvm.my.id --email hendisantika@yahoo.co.id --agree-tos --non-interactive --redirect
```

### Step 7: Configure Firewall

```bash
sudo ufw allow 'Nginx Full'
sudo ufw status
```

## 🔐 SSL/TLS Configuration

### Certificate Details

- **Provider**: Let's Encrypt
- **Auto-renewal**: Enabled (via certbot.timer)
- **Protocols**: TLSv1.2, TLSv1.3
- **Certificate Location**: `/etc/letsencrypt/live/redis-demo.jvm.my.id/`

### Manual Certificate Renewal

```bash
# Test renewal
sudo certbot renew --dry-run

# Force renewal
sudo certbot renew --force-renewal
```

### Check Certificate Expiry

```bash
sudo certbot certificates
```

## 🏗️ Nginx Configuration Overview

The Nginx configuration (`nginx/redis-demo.jvm.my.id.conf`) includes:

### HTTP → HTTPS Redirect

```nginx
server {
    listen 80;
    server_name redis-demo.jvm.my.id;
    return 301 https://$server_name$request_uri;
}
```

### HTTPS Server with Reverse Proxy

```nginx
server {
    listen 443 ssl http2;
    server_name redis-demo.jvm.my.id;

    # Proxy to Spring Boot
    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

### Features Enabled

- ✅ **HTTP/2**: For better performance
- ✅ **GZIP Compression**: Reduces bandwidth
- ✅ **Static File Caching**: 1-year cache for assets
- ✅ **Security Headers**: XSS, clickjacking protection
- ✅ **SSL Stapling**: Improved SSL performance
- ✅ **WebSocket Support**: For future features

## 🔍 Testing & Verification

### 1. Test HTTP Redirect

```bash
curl -I http://redis-demo.jvm.my.id
# Should return: HTTP/1.1 301 Moved Permanently
# Location: https://redis-demo.jvm.my.id/
```

### 2. Test HTTPS

```bash
curl -I https://redis-demo.jvm.my.id
# Should return: HTTP/2 200
```

### 3. Check SSL Certificate

```bash
openssl s_client -connect redis-demo.jvm.my.id:443 -servername redis-demo.jvm.my.id < /dev/null
```

### 4. Test Application

```bash
# Open in browser
https://redis-demo.jvm.my.id
```

### 5. SSL Labs Test

Check your SSL rating at:

```
https://www.ssllabs.com/ssltest/analyze.html?d=redis-demo.jvm.my.id
```

Expected rating: **A or A+**

## 📊 Monitoring & Logs

### View Access Logs

```bash
sudo tail -f /var/log/nginx/redis-demo.jvm.my.id.access.log
```

### View Error Logs

```bash
sudo tail -f /var/log/nginx/redis-demo.jvm.my.id.error.log
```

### Check Nginx Status

```bash
sudo systemctl status nginx
```

### Check Application Backend

```bash
sudo systemctl status spring-boot-crud-redis
```

## 🛠️ Useful Commands

```bash
# Reload Nginx configuration
sudo systemctl reload nginx

# Restart Nginx
sudo systemctl restart nginx

# Test Nginx configuration
sudo nginx -t

# View Nginx version
nginx -v

# Check what's listening on port 80/443
sudo netstat -tlnp | grep :80
sudo netstat -tlnp | grep :443

# View SSL certificate details
sudo certbot certificates
```

## 🐛 Troubleshooting

### Issue: DNS not resolving

```bash
# Check DNS propagation
nslookup redis-demo.jvm.my.id
dig redis-demo.jvm.my.id

# Use Google DNS for testing
nslookup redis-demo.jvm.my.id 8.8.8.8
```

**Solution**: Wait for DNS propagation (up to 48 hours, usually < 1 hour)

### Issue: SSL certificate failed

```bash
# Check if port 80 is accessible
curl -I http://redis-demo.jvm.my.id

# Check Nginx is running
sudo systemctl status nginx

# Check certbot logs
sudo tail -f /var/log/letsencrypt/letsencrypt.log
```

**Solution**: Ensure DNS is configured and port 80 is accessible

### Issue: 502 Bad Gateway

```bash
# Check if Spring Boot app is running
sudo systemctl status spring-boot-crud-redis

# Check if app is listening on 8080
sudo netstat -tlnp | grep :8080

# Check application logs
sudo journalctl -u spring-boot-crud-redis -f
```

**Solution**: Ensure Spring Boot application is running on port 8080

### Issue: Port 80/443 already in use

```bash
# Check what's using the ports
sudo lsof -i :80
sudo lsof -i :443

# Kill the process (if needed)
sudo kill <PID>
```

### Issue: Nginx configuration test fails

```bash
# Test configuration with verbose output
sudo nginx -t

# Check syntax
sudo nginx -T | less
```

**Solution**: Review error messages and fix configuration file

### Issue: Permission denied errors

```bash
# Check nginx user
ps aux | grep nginx

# Check file permissions
ls -la /etc/nginx/sites-available/
```

## 🔄 Automatic Deployment

The Nginx configuration is automatically deployed via GitHub Actions:

1. Changes to `nginx/redis-demo.jvm.my.id.conf` are pushed to repository
2. GitHub Actions transfers the config to the server
3. Workflow updates Nginx configuration
4. Nginx is reloaded automatically

**No manual intervention needed!**

## 🔐 Security Features

### Headers Configured

```nginx
X-Frame-Options: SAMEORIGIN
X-Content-Type-Options: nosniff
X-XSS-Protection: 1; mode=block
Referrer-Policy: no-referrer-when-downgrade
Strict-Transport-Security: max-age=31536000
```

### SSL Configuration

- **Protocols**: TLSv1.2, TLSv1.3 only
- **Ciphers**: Modern, secure ciphers
- **HSTS**: Enabled with 1-year max-age
- **SSL Stapling**: Enabled

## 📈 Performance Optimization

### GZIP Compression

Enabled for:

- HTML, CSS, JavaScript
- JSON, XML
- Fonts (TTF, WOFF, SVG)

### Caching

- **Static assets**: 1-year cache
- **Dynamic content**: No cache (proxied to backend)

### HTTP/2

Enabled for multiplexing and header compression

## 🔧 Configuration Files

```
/etc/nginx/
├── nginx.conf                          # Main Nginx config
├── sites-available/
│   └── redis-demo.jvm.my.id.conf      # Your site config
└── sites-enabled/
    └── redis-demo.jvm.my.id.conf      # Symlink to sites-available

/etc/letsencrypt/live/redis-demo.jvm.my.id/
├── fullchain.pem                       # SSL certificate
├── privkey.pem                         # Private key
└── chain.pem                           # Certificate chain

/var/log/nginx/
├── redis-demo.jvm.my.id.access.log    # Access logs
└── redis-demo.jvm.my.id.error.log     # Error logs
```

## 🎯 Summary

✅ **Domain**: https://redis-demo.jvm.my.id
✅ **SSL**: Let's Encrypt with auto-renewal
✅ **Protocol**: HTTP/2
✅ **Compression**: GZIP enabled
✅ **Security**: Modern headers and TLS configuration
✅ **Performance**: Caching and optimization enabled
✅ **Automatic Deployment**: Via GitHub Actions

## 📚 Related Files

- `nginx/redis-demo.jvm.my.id.conf` - Nginx configuration
- `setup-nginx.sh` - Automated setup script
- `.github/workflows/deploy.yml` - GitHub Actions workflow
- `DEPLOYMENT_SUMMARY.md` - Complete deployment guide

---

**Your application is now accessible at:** https://redis-demo.jvm.my.id 🚀
