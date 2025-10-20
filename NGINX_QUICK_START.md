# Nginx + Cloudflare Quick Start Guide

## 🌐 Using Cloudflare for SSL/TLS

This setup uses **Cloudflare** for SSL/TLS (not Let's Encrypt), which provides:

- ✅ Free SSL certificate (automatically managed)
- ✅ Global CDN for faster loading
- ✅ DDoS protection
- ✅ Web Application Firewall

## 🚀 Quick Setup (2 Steps)

### Step 1: Configure Cloudflare

**In Cloudflare Dashboard:**

1. **Add DNS Record**:
    - Type: `A`
    - Name: `redis-demo.jvm.my.id`
    - IPv4: `103.125.181.190`
    - Proxy: **Proxied** (orange cloud ☁️) ✓

2. **Set SSL Mode**:
    - Go to: SSL/TLS → Overview
    - Select: **Full**

### Step 2: Run Setup Script on Server

SSH into server and run:

```bash
ssh -i ~/.ssh/deploy_key destroyer@103.125.181.190
cd /home/destroyer/spring-boot-crud-redis
chmod +x setup-nginx.sh
./setup-nginx.sh
```

### Step 3: Test

Open in browser:

```
https://redis-demo.jvm.my.id
```

**Note**: Wait a few minutes for Cloudflare to provision SSL

## ✅ Verification Checklist

- [ ] DNS configured in Cloudflare (proxied mode)
- [ ] SSL/TLS mode set to "Full"
- [ ] Spring Boot app is running: `sudo systemctl status spring-boot-crud-redis`
- [ ] Nginx is running: `sudo systemctl status nginx`
- [ ] HTTPS works: Open https://redis-demo.jvm.my.id
- [ ] HTTP redirects to HTTPS (Cloudflare handles this)

## 🔧 Common Commands

```bash
# Nginx
sudo systemctl status nginx          # Check status
sudo systemctl reload nginx          # Reload config
sudo nginx -t                        # Test config

# Logs
sudo tail -f /var/log/nginx/redis-demo.jvm.my.id.access.log
sudo tail -f /var/log/nginx/redis-demo.jvm.my.id.error.log

# Cloudflare
# SSL is managed automatically by Cloudflare
# Check Cloudflare Dashboard for SSL status
```

## 🐛 Quick Troubleshooting

| Issue                            | Solution                                            |
|----------------------------------|-----------------------------------------------------|
| 521 Error (Web server down)      | `sudo systemctl start nginx spring-boot-crud-redis` |
| 522 Error (Connection timeout)   | `sudo ufw allow 80/tcp`                             |
| 525 Error (SSL handshake failed) | Set Cloudflare SSL mode to "Full"                   |
| Cloudflare IPs in logs           | Nginx config includes real_ip settings              |

## 📍 Important URLs

- **Your App**: https://redis-demo.jvm.my.id
- **SSL Test**: https://www.ssllabs.com/ssltest/analyze.html?d=redis-demo.jvm.my.id
- **GitHub Actions**: https://github.com/hendisantika/spring-boot-crud-redis/actions

## 🎯 What You Get

✅ **HTTPS**: SSL/TLS encryption (Cloudflare)
✅ **HTTP/2 & HTTP/3**: Modern protocols
✅ **Global CDN**: Fast loading worldwide
✅ **DDoS Protection**: Automatic protection
✅ **Security headers**: XSS, clickjacking protection
✅ **Brotli + GZIP**: Better compression
✅ **Auto minification**: HTML/CSS/JS

## 📚 Full Documentation

- **CLOUDFLARE_SETUP.md** - Complete Cloudflare guide
- **NGINX_SETUP.md** - Nginx configuration details

---

**Done!** Your app is at https://redis-demo.jvm.my.id 🎉
