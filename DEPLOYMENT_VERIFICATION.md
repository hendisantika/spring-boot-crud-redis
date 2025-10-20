# Deployment Verification Guide

This document explains the automated deployment verification process that runs with every GitHub Actions deployment.

## 🔄 Deployment Workflow

The GitHub Actions workflow now includes 3 automated steps:

### Step 1: Deploy Application

```
✓ Create .env file with Upstash credentials
✓ Stop existing application
✓ Update systemd service
✓ Start Spring Boot application
✓ Verify application status
✓ Show recent logs
```

### Step 2: Setup and Verify Nginx

```
✓ Install Nginx (if not present)
✓ Update Nginx configuration
✓ Enable site configuration
✓ Remove default site
✓ Test Nginx configuration
✓ Reload Nginx
✓ Configure firewall (port 80)
✓ Verify Nginx status
```

### Step 3: Verify Domain is Serving Requests

```
✓ Test Spring Boot backend (localhost:8080)
✓ Test Nginx proxy (localhost:80)
✓ Test server via IP (103.125.181.190)
✓ Test HTTP domain (redis-demo.jvm.my.id)
✓ Test HTTPS domain (https://redis-demo.jvm.my.id)
```

## ✅ Verification Tests

### Test 1: Spring Boot Backend

```bash
curl http://localhost:8080
```

**Expected**: HTTP 200
**Verifies**: Spring Boot application is running

### Test 2: Nginx Proxy

```bash
curl http://localhost:80
```

**Expected**: HTTP 200
**Verifies**: Nginx is proxying to Spring Boot

### Test 3: Server IP Access

```bash
curl http://103.125.181.190
```

**Expected**: HTTP 200
**Verifies**: Server is accessible externally

### Test 4: HTTP Domain

```bash
curl http://redis-demo.jvm.my.id
```

**Expected**: HTTP 200 (if Cloudflare DNS is configured)
**Verifies**: DNS is working

### Test 5: HTTPS Domain

```bash
curl https://redis-demo.jvm.my.id
```

**Expected**: HTTP 200 (if Cloudflare is fully configured)
**Verifies**: Full stack including SSL is working

## 📊 Deployment Stages

```
┌─────────────────────────────────────────────┐
│ 1. Build Application (Maven)               │
│    - Compile code                           │
│    - Create JAR file                        │
└──────────────────┬──────────────────────────┘
                   ↓
┌─────────────────────────────────────────────┐
│ 2. Transfer Files (SCP)                     │
│    - JAR file                               │
│    - Systemd service                        │
│    - Nginx configuration                    │
└──────────────────┬──────────────────────────┘
                   ↓
┌─────────────────────────────────────────────┐
│ 3. Deploy Application                       │
│    - Create .env file                       │
│    - Update systemd service                 │
│    - Start application                      │
│    ✓ Verify: Spring Boot running           │
└──────────────────┬──────────────────────────┘
                   ↓
┌─────────────────────────────────────────────┐
│ 4. Setup Nginx                              │
│    - Install Nginx (if needed)              │
│    - Update configuration                   │
│    - Reload Nginx                           │
│    ✓ Verify: Nginx running                 │
└──────────────────┬──────────────────────────┘
                   ↓
┌─────────────────────────────────────────────┐
│ 5. Verify Domain                            │
│    ✓ Test backend (localhost:8080)         │
│    ✓ Test proxy (localhost:80)             │
│    ✓ Test IP (103.125.181.190)             │
│    ✓ Test domain (redis-demo.jvm.my.id)    │
│    ✓ Test HTTPS (if Cloudflare configured) │
└─────────────────────────────────────────────┘
```

## 🎯 Success Criteria

Deployment is considered successful when:

✅ **Build**: Maven successfully creates JAR
✅ **Transfer**: All files transferred to server
✅ **Application**: Spring Boot is running
✅ **Nginx**: Nginx is serving requests
✅ **Backend Test**: localhost:8080 responds with HTTP 200
✅ **Proxy Test**: localhost:80 responds with HTTP 200
✅ **IP Test**: Server IP responds with HTTP 200

**Optional** (requires Cloudflare setup):
⚠️ **Domain Test**: HTTP domain responds
⚠️ **HTTPS Test**: HTTPS domain responds

## 📈 GitHub Actions Output

When deployment runs, you'll see output like this:

```
✓ Build with Maven
  BUILD SUCCESS

✓ Deploy JAR, Service, and Nginx Config to Server
  Uploaded: crud-redis-0.0.1-SNAPSHOT.jar
  Uploaded: spring-boot-crud-redis.service
  Uploaded: nginx/redis-demo.jvm.my.id.conf

✓ Create .env and deploy application
  Created .env file
  Stopped spring-boot-crud-redis
  Updated systemd service
  Started spring-boot-crud-redis
  ● spring-boot-crud-redis.service - Active: active (running)

✓ Setup and verify Nginx
  Nginx configuration OK
  Reloaded Nginx
  ● nginx.service - Active: active (running)

✓ Verify domain is serving requests
  1. Testing Spring Boot backend... ✓
  2. Testing Nginx... ✓
  3. Testing via server IP... ✓
  4. Testing domain... ✓ or ⚠
  5. Testing HTTPS domain... ✓ or ⚠

  ✓ Deployment Verification Complete
```

## 🔍 Monitoring Deployment

### Via GitHub Actions Web UI

1. Go to: https://github.com/hendisantika/spring-boot-crud-redis/actions
2. Click on the latest workflow run
3. Expand each step to see detailed logs
4. Check for ✓ green checkmarks

### Via Command Line

```bash
# Watch the deployment
gh run watch

# View latest run
gh run view

# List recent runs
gh run list
```

## 🐛 Troubleshooting Failed Deployments

### If "Spring Boot Backend Test" Fails

```bash
# SSH into server
ssh -i ~/.ssh/deploy_key destroyer@103.125.181.190

# Check application status
sudo systemctl status spring-boot-crud-redis

# View logs
sudo journalctl -u spring-boot-crud-redis -n 50

# Common causes:
# - .env file missing/incorrect
# - Port 8080 in use
# - Redis connection failed
```

### If "Nginx Test" Fails

```bash
# Check Nginx status
sudo systemctl status nginx

# Test configuration
sudo nginx -t

# View error logs
sudo tail -f /var/log/nginx/redis-demo.jvm.my.id.error.log

# Common causes:
# - Configuration syntax error
# - Port 80 in use
# - Permissions issue
```

### If "Server IP Test" Fails

```bash
# Check firewall
sudo ufw status

# Allow port 80
sudo ufw allow 80/tcp

# Test locally
curl http://localhost

# Common causes:
# - Firewall blocking port 80
# - Nginx not running
```

### If "Domain Test" Fails (Warning Only)

This is OK if you haven't configured Cloudflare yet.

**To fix:**

1. Configure Cloudflare DNS: `redis-demo.jvm.my.id` → `103.125.181.190`
2. Enable Proxy (orange cloud)
3. Wait for DNS propagation (5-60 minutes)

### If "HTTPS Test" Fails (Warning Only)

This is OK during initial setup.

**To fix:**

1. Ensure Cloudflare DNS is configured
2. Set SSL/TLS mode to "Full" in Cloudflare
3. Wait a few minutes for SSL provisioning

## 📝 Manual Verification

If you want to verify manually after deployment:

```bash
# SSH into server
ssh -i ~/.ssh/deploy_key destroyer@103.125.181.190

# Run verification script
cd /home/destroyer/spring-boot-crud-redis

# Test backend
curl -I http://localhost:8080

# Test Nginx
curl -I http://localhost

# Test IP
curl -I http://103.125.181.190

# Test domain (if Cloudflare configured)
curl -I http://redis-demo.jvm.my.id

# Test HTTPS (if Cloudflare configured)
curl -I https://redis-demo.jvm.my.id
```

## 🔄 Deployment Frequency

- **Automatic**: Every push to `main` branch
- **Manual**: Via GitHub Actions "Run workflow" button
- **Recommended**: Deploy during low-traffic hours for production

## 📊 Deployment Metrics

Track your deployments:

| Metric            | Target  | How to Check           |
|-------------------|---------|------------------------|
| **Build Time**    | < 2 min | GitHub Actions logs    |
| **Deploy Time**   | < 1 min | GitHub Actions logs    |
| **Total Time**    | < 5 min | GitHub Actions summary |
| **Success Rate**  | > 95%   | GitHub Actions history |
| **Rollback Time** | < 2 min | Manual revert + deploy |

## ✅ Post-Deployment Checklist

After successful deployment:

- [ ] Check GitHub Actions run completed successfully
- [ ] Verify application is accessible via IP
- [ ] Test main features (create/read/update/delete)
- [ ] Check application logs for errors
- [ ] Verify Nginx is proxying correctly
- [ ] Test domain (if Cloudflare configured)
- [ ] Check Upstash Redis connection
- [ ] Monitor for a few minutes

## 🎯 Continuous Verification

The deployment verification runs automatically with every deployment, ensuring:

✅ **Consistency**: Same tests every time
✅ **Early Detection**: Catch issues immediately
✅ **Confidence**: Know deployment worked before leaving
✅ **Documentation**: Clear logs of what was tested
✅ **Debugging**: Easy to identify which component failed

## 📚 Related Documentation

- **DEPLOYMENT_SUMMARY.md** - Quick deployment reference
- **CLOUDFLARE_SETUP.md** - Cloudflare configuration
- **NGINX_QUICK_START.md** - Nginx setup guide
- **.github/workflows/deploy.yml** - Full workflow definition

---

**Your deployment now includes automatic verification!** 🎉

Every push to `main` will:

1. ✅ Build and deploy
2. ✅ Setup Nginx
3. ✅ Verify everything works
