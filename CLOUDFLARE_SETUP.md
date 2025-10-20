# Cloudflare + Nginx Setup Guide

This guide shows how to configure Cloudflare with Nginx for your Spring Boot application.

## 🌐 Architecture

```
Client
  ↓
HTTPS (Cloudflare SSL)
  ↓
Cloudflare Edge Network
  ↓
HTTP/HTTPS (depending on SSL mode)
  ↓
Your Server (103.125.181.190)
Nginx → Spring Boot (port 8080)
```

## ✅ Benefits of Using Cloudflare

- ✅ **Free SSL/TLS Certificate** - No Let's Encrypt needed
- ✅ **Global CDN** - Faster content delivery worldwide
- ✅ **DDoS Protection** - Automatic protection
- ✅ **Web Application Firewall (WAF)** - Security rules
- ✅ **Auto Minification** - HTML/CSS/JS compression
- ✅ **Brotli Compression** - Better than GZIP
- ✅ **HTTP/2 & HTTP/3** - Modern protocols
- ✅ **Analytics** - Traffic insights

## 🚀 Quick Setup (2 Steps)

### Step 1: Configure Cloudflare

1. **Add DNS Record**
    - Go to: Cloudflare Dashboard → DNS → Records
    - Click: **Add record**
    - Type: `A`
    - Name: `redis-demo.jvm.my.id` (or just `redis-demo` if jvm.my.id is your domain)
    - IPv4 address: `103.125.181.190`
    - Proxy status: **Proxied** (orange cloud ☁️) ✓
    - TTL: `Auto`
    - Click: **Save**

2. **Configure SSL/TLS**
    - Go to: Cloudflare Dashboard → SSL/TLS → Overview
    - Select: **Full** (recommended)

### Step 2: Setup Nginx on Server

```bash
# SSH into server
ssh -i ~/.ssh/deploy_key destroyer@103.125.181.190

# Run nginx setup
cd /home/destroyer/spring-boot-crud-redis
chmod +x setup-nginx.sh
./setup-nginx.sh
```

That's it! Your site will be available at `https://redis-demo.jvm.my.id`

## 🔐 Cloudflare SSL/TLS Modes

Cloudflare offers different SSL/TLS modes:

### 1. **Flexible** (Not Recommended)

```
Client ←(HTTPS)→ Cloudflare ←(HTTP)→ Origin Server
```

- ✅ Easy setup
- ❌ Connection between Cloudflare and your server is NOT encrypted
- ❌ Less secure

**Use case**: Quick testing only

### 2. **Full** (Recommended) ✓

```
Client ←(HTTPS)→ Cloudflare ←(HTTP/Self-signed HTTPS)→ Origin Server
```

- ✅ Easy setup (works with our HTTP-only nginx)
- ✅ End-to-end encryption
- ✅ Accepts self-signed certificates
- ✅ No certificate management needed

**Use case**: Production (what we're using)**

### 3. **Full (strict)** (Most Secure)

```
Client ←(HTTPS)→ Cloudflare ←(HTTPS with valid cert)→ Origin Server
```

- ✅ Maximum security
- ✅ Requires valid SSL certificate on origin
- ❌ Requires Cloudflare Origin Certificate or Let's Encrypt

**Use case**: High-security applications

### 4. **Off**

```
Client ←(HTTP)→ Cloudflare ←(HTTP)→ Origin Server
```

- ❌ No encryption
- ❌ Not recommended

## 📋 Complete Cloudflare Configuration

### 1. DNS Settings

Navigate to: **DNS → Records**

| Type | Name                 | Content         | Proxy Status | TTL  |
|------|----------------------|-----------------|--------------|------|
| A    | redis-demo.jvm.my.id | 103.125.181.190 | Proxied ☁️   | Auto |

**Important**: Ensure proxy status is **Proxied** (orange cloud)

### 2. SSL/TLS Settings

Navigate to: **SSL/TLS → Overview**

- **Encryption mode**: Full
- **Edge Certificates**:
    - Always Use HTTPS: On
    - Minimum TLS Version: TLS 1.2
    - Opportunistic Encryption: On
    - TLS 1.3: On
    - Automatic HTTPS Rewrites: On

### 3. Speed Optimizations (Optional)

Navigate to: **Speed → Optimization**

Recommended settings:

- **Auto Minify**: Enable HTML, CSS, JavaScript
- **Brotli**: On
- **Early Hints**: On
- **Rocket Loader**: Off (may break some JS)

Navigate to: **Caching → Configuration**

- **Browser Cache TTL**: Respect Existing Headers
- **Caching Level**: Standard

### 4. Security Settings (Optional)

Navigate to: **Security → Settings**

- **Security Level**: Medium
- **Challenge Passage**: 30 minutes
- **Browser Integrity Check**: On

Navigate to: **Security → WAF**

- **Managed Rules**: Configure as needed

### 5. Network Settings

Navigate to: **Network**

- **HTTP/2**: On
- **HTTP/3 (with QUIC)**: On
- **0-RTT Connection Resumption**: On
- **WebSockets**: On
- **gRPC**: On (if needed)

## 🔧 Nginx Configuration for Cloudflare

Our Nginx configuration includes:

### Real IP Restoration

```nginx
# Get real visitor IP from Cloudflare
set_real_ip_from 173.245.48.0/20;
# ... (more Cloudflare IP ranges)
real_ip_header CF-Connecting-IP;
```

This ensures your application sees the actual visitor IP, not Cloudflare's IP.

### Security Headers

```nginx
add_header X-Frame-Options "SAMEORIGIN" always;
add_header X-Content-Type-Options "nosniff" always;
add_header X-XSS-Protection "1; mode=block" always;
```

Note: HSTS is added by Cloudflare, not Nginx.

## ✅ Verification Checklist

After setup, verify:

- [ ] DNS resolves to Cloudflare IPs: `nslookup redis-demo.jvm.my.id`
- [ ] Site is accessible: `https://redis-demo.jvm.my.id`
- [ ] SSL certificate is valid (check browser padlock)
- [ ] HTTP redirects to HTTPS (test: `http://redis-demo.jvm.my.id`)
- [ ] Application works correctly
- [ ] Real IP is logged (check nginx logs)

## 🧪 Testing

### 1. Check DNS Resolution

```bash
nslookup redis-demo.jvm.my.id
# Should return Cloudflare IPs (not 103.125.181.190)
```

### 2. Test SSL

```bash
curl -I https://redis-demo.jvm.my.id
# Should return HTTP/2 200
```

### 3. Check Real IP

```bash
# On server, check nginx logs
sudo tail -f /var/log/nginx/redis-demo.jvm.my.id.access.log

# You should see real visitor IPs, not Cloudflare IPs
```

### 4. Test Performance

Visit: https://www.webpagetest.org/
Enter: `https://redis-demo.jvm.my.id`

### 5. Check SSL

Visit: https://www.ssllabs.com/ssltest/
Enter: `redis-demo.jvm.my.id`

Expected: **A or A+** rating (from Cloudflare)

## 🐛 Troubleshooting

### Issue: 521 Error (Web server is down)

**Cause**: Nginx/Spring Boot is not running

**Solution**:

```bash
# Check Nginx
sudo systemctl status nginx

# Check Spring Boot
sudo systemctl status spring-boot-crud-redis

# Restart if needed
sudo systemctl restart nginx
sudo systemctl restart spring-boot-crud-redis
```

### Issue: 522 Error (Connection timed out)

**Cause**: Firewall blocking port 80

**Solution**:

```bash
# Open port 80
sudo ufw allow 80/tcp
sudo ufw status
```

### Issue: 525 Error (SSL handshake failed)

**Cause**: Wrong SSL/TLS mode

**Solution**: Change Cloudflare SSL/TLS mode to **Full** (not Full Strict)

### Issue: Redirect loop

**Cause**: Nginx trying to redirect HTTPS → HTTP

**Solution**: Our config doesn't redirect, so this shouldn't happen. If it does:

- Check Cloudflare SSL mode is **Full**
- Ensure "Always Use HTTPS" is enabled in Cloudflare

### Issue: Logs show Cloudflare IPs, not real visitor IPs

**Cause**: Real IP configuration not working

**Solution**:

```bash
# Check nginx config
sudo nginx -t

# Reload nginx
sudo systemctl reload nginx

# Verify CF-Connecting-IP header is present
curl -H "CF-Connecting-IP: 1.2.3.4" http://localhost
```

## 📊 Cloudflare Analytics

View your traffic analytics:

1. Go to Cloudflare Dashboard
2. Click on your domain
3. Navigate to **Analytics & Logs** → **Traffic**

You can see:

- Requests per second
- Bandwidth usage
- Unique visitors
- Top countries
- Cached vs. uncached requests

## 🎯 Performance Comparison

| Metric              | Without Cloudflare     | With Cloudflare |
|---------------------|------------------------|-----------------|
| **SSL Setup**       | Manual (Let's Encrypt) | Automatic       |
| **Global Latency**  | High (single server)   | Low (CDN)       |
| **DDoS Protection** | None                   | Built-in        |
| **Bandwidth**       | Limited                | Unlimited (CDN) |
| **Cache**           | Origin only            | Edge + Origin   |
| **Compression**     | GZIP                   | Brotli + GZIP   |

## 🔄 Purge Cloudflare Cache

If you update static files:

1. Go to Cloudflare Dashboard
2. Navigate to **Caching** → **Configuration**
3. Click **Purge Everything** or **Custom Purge**

Or via API:

```bash
curl -X POST "https://api.cloudflare.com/client/v4/zones/{zone_id}/purge_cache" \
  -H "Authorization: Bearer {api_token}" \
  -H "Content-Type: application/json" \
  --data '{"purge_everything":true}'
```

## 📚 Additional Resources

- **Cloudflare Docs**: https://developers.cloudflare.com/
- **SSL/TLS Modes**: https://developers.cloudflare.com/ssl/origin-configuration/ssl-modes/
- **Speed Optimization**: https://developers.cloudflare.com/speed/
- **Security**: https://developers.cloudflare.com/waf/

## 🎁 Cloudflare Free Plan Features

With the free plan, you get:

- ✅ Unlimited bandwidth
- ✅ Global CDN
- ✅ Free SSL certificate
- ✅ DDoS protection
- ✅ Web Application Firewall (basic)
- ✅ Page Rules (3 rules)
- ✅ Analytics
- ✅ Auto Minification
- ✅ Brotli compression

## 🎯 Summary

✅ **Easy Setup**: No certificate management needed
✅ **Better Performance**: Global CDN and caching
✅ **Enhanced Security**: DDoS protection and WAF
✅ **Cost Effective**: Free for most use cases
✅ **Automatic Updates**: Cloudflare manages SSL certificates

Your application is now protected and accelerated by Cloudflare! 🚀

---

**Access your application at**: https://redis-demo.jvm.my.id
