# Complete Deployment Guide

This is the master guide for deploying your Spring Boot CRUD Redis application with full production setup.

## 🎯 What You'll Get

✅ **Spring Boot Application** running on server
✅ **Upstash Cloud Redis** for data storage
✅ **GitHub Actions** for automated deployment
✅ **SSH Key Authentication** for secure access
✅ **Nginx Reverse Proxy** with HTTPS
✅ **SSL/TLS Certificate** from Let's Encrypt
✅ **Systemd Service** for auto-start
✅ **Custom Domain** https://redis-demo.jvm.my.id

## 📋 Complete Setup Checklist

### Phase 1: Initial Server Setup

- [ ] **Server accessible**: `ssh destroyer@103.125.181.190`
- [ ] **Generate SSH keys**: Run `./setup-ssh-key.sh`
- [ ] **Add public key to server**: `ssh-copy-id -i ~/.ssh/deploy_key.pub destroyer@103.125.181.190`
- [ ] **Test SSH connection**: `ssh -i ~/.ssh/deploy_key destroyer@103.125.181.190`

### Phase 2: Configure GitHub Secrets

Go to: https://github.com/hendisantika/spring-boot-crud-redis/settings/secrets/actions

Add these 7 secrets:

- [ ] `SERVER_HOST` = `103.125.181.190`
- [ ] `SERVER_USERNAME` = `destroyer`
- [ ] `SERVER_SSH_KEY` = Your private key (from `cat ~/.ssh/deploy_key`)
- [ ] `UPSTASH_ENDPOINT` = `living-muskrat-23212.upstash.io`
- [ ] `UPSTASH_PORT` = `6379`
- [ ] `UPSTASH_USERNAME` = `default`
- [ ] `UPSTASH_PASSWORD` = `AVqsAAIjcDE2OWRkMGRhYmM4MDk0OWRlOWM4OWE1MmIzZWE5MzRiNXAxMA`

### Phase 3: DNS Configuration

- [ ] Add A record: `redis-demo.jvm.my.id` → `103.125.181.190`
- [ ] Verify DNS: `nslookup redis-demo.jvm.my.id`
- [ ] Wait for propagation (5 min - 48 hours, usually < 1 hour)

### Phase 4: Deploy Application

```bash
# Deploy via GitHub Actions
git add .
git commit -m "Initial deployment setup"
git push origin main

# Or manually run server-setup.sh on server
ssh -i ~/.ssh/deploy_key destroyer@103.125.181.190
cd /home/destroyer/spring-boot-crud-redis
./server-setup.sh
```

### Phase 5: Setup Nginx (After DNS is configured)

```bash
# SSH into server
ssh -i ~/.ssh/deploy_key destroyer@103.125.181.190

# Run nginx setup
cd /home/destroyer/spring-boot-crud-redis
./setup-nginx.sh
```

### Phase 6: Verify Everything

- [ ] Application running: `sudo systemctl status spring-boot-crud-redis`
- [ ] Nginx running: `sudo systemctl status nginx`
- [ ] SSL certificate obtained: `sudo certbot certificates`
- [ ] Test HTTP redirect: `curl -I http://redis-demo.jvm.my.id`
- [ ] Test HTTPS: Open https://redis-demo.jvm.my.id
- [ ] Check SSL rating: https://www.ssllabs.com/ssltest/analyze.html?d=redis-demo.jvm.my.id

## 🚀 Quick Command Reference

### Server Management

```bash
# SSH into server
ssh -i ~/.ssh/deploy_key destroyer@103.125.181.190

# Check application status
sudo systemctl status spring-boot-crud-redis

# View application logs
sudo journalctl -u spring-boot-crud-redis -f

# Restart application
sudo systemctl restart spring-boot-crud-redis
```

### Nginx Management

```bash
# Check Nginx status
sudo systemctl status nginx

# Test Nginx config
sudo nginx -t

# Reload Nginx
sudo systemctl reload nginx

# View access logs
sudo tail -f /var/log/nginx/redis-demo.jvm.my.id.access.log

# View error logs
sudo tail -f /var/log/nginx/redis-demo.jvm.my.id.error.log
```

### SSL Certificate Management

```bash
# Check certificates
sudo certbot certificates

# Test renewal
sudo certbot renew --dry-run

# Force renewal
sudo certbot renew --force-renewal
```

### Deployment

```bash
# Deploy via GitHub Actions
git add .
git commit -m "Your message"
git push origin main

# Watch deployment
# Go to: https://github.com/hendisantika/spring-boot-crud-redis/actions
```

## 📊 Architecture Overview

```
┌─────────────┐
│   Client    │
└──────┬──────┘
       │ HTTPS
       │
┌──────▼──────────────────┐
│   Nginx (Port 443)      │
│   redis-demo.jvm.my.id  │
│   - SSL Termination     │
│   - Reverse Proxy       │
│   - GZIP Compression    │
│   - Security Headers    │
└──────┬──────────────────┘
       │ HTTP
       │
┌──────▼──────────────────┐
│  Spring Boot (Port 8080)│
│  - Profile: dev         │
│  - Systemd Service      │
└──────┬──────────────────┘
       │ TLS
       │
┌──────▼──────────────────┐
│  Upstash Cloud Redis    │
│  living-muskrat-23212   │
│  - Port: 6379 (TLS)     │
│  - Managed Service      │
└─────────────────────────┘
```

## 🔐 Security Features

### Application Level

- ✅ Spring Security ready
- ✅ Input validation
- ✅ CSRF protection capability
- ✅ TLS connection to Redis

### Infrastructure Level

- ✅ SSH key authentication (no passwords)
- ✅ Firewall configured (UFW)
- ✅ HTTPS only (HTTP redirects)
- ✅ Modern TLS protocols (1.2, 1.3)
- ✅ Security headers (XSS, clickjacking protection)
- ✅ HSTS enabled

### Secrets Management

- ✅ GitHub Secrets for credentials
- ✅ Environment variables for Upstash
- ✅ .env file with restricted permissions (600)
- ✅ Private keys never committed to Git

## 🎯 URLs & Access Points

| Service             | URL                                                                 | Status Check               |
|---------------------|---------------------------------------------------------------------|----------------------------|
| **Production App**  | https://redis-demo.jvm.my.id                                        | Public                     |
| **Direct Access**   | http://103.125.181.190:8080                                         | Public (use Nginx instead) |
| **GitHub Repo**     | https://github.com/hendisantika/spring-boot-crud-redis              | Public                     |
| **GitHub Actions**  | https://github.com/hendisantika/spring-boot-crud-redis/actions      | Monitor deployments        |
| **Upstash Console** | https://console.upstash.com                                         | Manage Redis               |
| **SSL Test**        | https://www.ssllabs.com/ssltest/analyze.html?d=redis-demo.jvm.my.id | Check SSL rating           |

## 🛠️ Troubleshooting Guide

### Issue: Application won't start

```bash
# Check logs
sudo journalctl -u spring-boot-crud-redis -n 100

# Common causes:
# 1. Redis connection failed - Check .env file
# 2. Port 8080 in use - Check: sudo lsof -i :8080
# 3. Permission issues - Check: ls -la /home/destroyer/spring-boot-crud-redis
```

### Issue: Nginx shows 502 Bad Gateway

```bash
# Check if app is running
sudo systemctl status spring-boot-crud-redis

# Check if app is listening
sudo netstat -tlnp | grep :8080

# Restart app if needed
sudo systemctl restart spring-boot-crud-redis
```

### Issue: SSL certificate failed

```bash
# Ensure DNS is configured
nslookup redis-demo.jvm.my.id

# Ensure port 80 is accessible
curl http://redis-demo.jvm.my.id

# Check certbot logs
sudo tail -f /var/log/letsencrypt/letsencrypt.log

# Retry manually
sudo certbot --nginx -d redis-demo.jvm.my.id --email hendisantika@yahoo.co.id
```

### Issue: GitHub Actions deployment fails

1. Check Actions logs: https://github.com/hendisantika/spring-boot-crud-redis/actions
2. Verify all 7 secrets are configured
3. Test SSH manually: `ssh -i ~/.ssh/deploy_key destroyer@103.125.181.190`
4. Check server disk space: `df -h`

## 📚 Documentation Index

| Document                   | Purpose                            |
|----------------------------|------------------------------------|
| **DEPLOYMENT_SUMMARY.md**  | Quick reference for deployment     |
| **GITHUB_SECRETS.md**      | How to configure GitHub Secrets    |
| **SSH_KEY_SETUP_GUIDE.md** | SSH key authentication setup       |
| **NGINX_SETUP.md**         | Complete Nginx configuration guide |
| **NGINX_QUICK_START.md**   | Quick Nginx setup (3 steps)        |
| **UPSTASH_DEPLOYMENT.md**  | How Upstash credentials work       |
| **DEPLOYMENT.md**          | Detailed deployment documentation  |

## 🔄 Update & Maintenance

### Deploy Application Updates

```bash
# Make changes to code
git add .
git commit -m "Your changes"
git push origin main

# GitHub Actions will automatically:
# 1. Build application
# 2. Deploy to server
# 3. Restart service
# 4. Update Nginx config if changed
```

### Update Nginx Configuration

```bash
# 1. Edit nginx/redis-demo.jvm.my.id.conf
# 2. Commit and push
git add nginx/redis-demo.jvm.my.id.conf
git commit -m "Update nginx config"
git push origin main

# GitHub Actions will deploy automatically
```

### Renew SSL Certificate

**Automatic renewal** is configured via certbot timer.

Manual renewal:

```bash
sudo certbot renew
sudo systemctl reload nginx
```

## 🎉 Success Criteria

Your deployment is successful when:

✅ Can access https://redis-demo.jvm.my.id
✅ HTTP redirects to HTTPS
✅ SSL certificate is valid (A rating on SSL Labs)
✅ Application responds correctly
✅ Can create/read/update/delete products
✅ GitHub Actions deploy without errors
✅ Application auto-starts on server reboot

## 📞 Support & Resources

- **Repository**: https://github.com/hendisantika/spring-boot-crud-redis
- **Issues**: https://github.com/hendisantika/spring-boot-crud-redis/issues
- **Spring Boot Docs**: https://docs.spring.io/spring-boot/
- **Nginx Docs**: https://nginx.org/en/docs/
- **Let's Encrypt**: https://letsencrypt.org/docs/
- **Upstash**: https://docs.upstash.com/

---

## 🚀 Final Steps

1. ✅ Complete all checklist items above
2. ✅ Test the application at https://redis-demo.jvm.my.id
3. ✅ Monitor first deployment via GitHub Actions
4. ✅ Check logs for any errors
5. ✅ Verify SSL certificate with SSL Labs

**Your application is now fully deployed and production-ready!** 🎊
