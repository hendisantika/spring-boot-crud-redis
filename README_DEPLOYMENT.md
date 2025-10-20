# 🚀 Automated Deployment with Verification

## ✨ What Happens When You Push Code

Every time you push to the `main` branch, GitHub Actions automatically:

### 1️⃣ Build (Maven)

```
Building with Maven...
✓ Compiled 9 source files
✓ Created JAR: crud-redis-0.0.1-SNAPSHOT.jar
✓ Build SUCCESS (1.8s)
```

### 2️⃣ Transfer (SCP)

```
Transferring files to server...
✓ crud-redis-0.0.1-SNAPSHOT.jar
✓ spring-boot-crud-redis.service
✓ nginx/redis-demo.jvm.my.id.conf
```

### 3️⃣ Deploy Application

```
Deploying application...
✓ Created .env with Upstash credentials
✓ Stopped existing application
✓ Updated systemd service
✓ Started spring-boot-crud-redis
✓ Application is running (port 8080)
```

### 4️⃣ Setup Nginx (NEW! 🎉)

```
Setting up Nginx...
✓ Nginx installed
✓ Updated configuration
✓ Tested configuration (nginx -t)
✓ Reloaded Nginx
✓ Configured firewall (port 80)
✓ Nginx is serving requests
```

### 5️⃣ Verify Domain (NEW! 🎉)

```
Verifying domain...
✓ Spring Boot backend responding (localhost:8080)
✓ Nginx proxy working (localhost:80)
✓ Server accessible via IP (103.125.181.190)
✓ HTTP domain working (redis-demo.jvm.my.id)
✓ HTTPS domain working (https://redis-demo.jvm.my.id)

✅ Deployment Verification Complete!
```

## 🎯 Zero-Touch Deployment

### Before (Manual)

```bash
# 1. Build locally
mvn clean package

# 2. SCP to server
scp target/*.jar server:/home/deployer/

# 3. SSH into server
ssh server

# 4. Stop application
sudo systemctl stop app

# 5. Copy files
sudo cp ...

# 6. Start application
sudo systemctl start app

# 7. Setup Nginx
sudo cp nginx.conf ...
sudo nginx -t
sudo systemctl reload nginx

# 8. Test manually
curl http://localhost:8080
curl http://localhost
curl http://103.125.181.190
...
```

**Time**: ~15 minutes
**Error-prone**: Yes
**Repeatable**: No

### After (Automated) ✅

```bash
git push origin main
```

**Time**: ~3 minutes
**Error-prone**: No
**Repeatable**: Yes
**Verified**: Yes

## 📊 Deployment Dashboard

View your deployment in real-time:
https://github.com/hendisantika/spring-boot-crud-redis/actions

```
┌────────────────────────────────────────────┐
│ ✓ Build with Maven                   15s  │
│ ✓ Deploy JAR and Config               8s  │
│ ✓ Create .env and deploy app         12s  │
│ ✓ Setup and verify Nginx             18s  │
│ ✓ Verify domain is serving requests  10s  │
│                                            │
│ Total: 1m 3s                         ✓    │
└────────────────────────────────────────────┘
```

## ✅ Verification Checklist

After each deployment, the workflow automatically verifies:

- [x] **Build**: Maven build successful
- [x] **Deploy**: JAR transferred to server
- [x] **Application**: Spring Boot running
- [x] **Backend**: localhost:8080 responding
- [x] **Nginx**: localhost:80 responding
- [x] **IP Access**: 103.125.181.190 responding
- [x] **HTTP Domain**: redis-demo.jvm.my.id responding
- [x] **HTTPS Domain**: https://redis-demo.jvm.my.id responding

All checks must pass for deployment to succeed!

## 🔍 Monitoring Deployment

### Real-time Logs

Watch the deployment in GitHub Actions:

1. Go to https://github.com/hendisantika/spring-boot-crud-redis/actions
2. Click on the latest workflow run
3. Expand each step to see logs

### Command Line

```bash
# Install GitHub CLI
brew install gh  # or: https://cli.github.com/

# Watch deployment in terminal
gh run watch

# View latest run
gh run view

# List recent runs
gh run list
```

### Slack/Discord Notifications (Optional)

Add notifications to your workflow:

```yaml
- name: Notify on success
  if: success()
  run: |
    curl -X POST -H 'Content-type: application/json' \
      --data '{"text":"✅ Deployment successful!"}' \
      ${{ secrets.SLACK_WEBHOOK_URL }}
```

## 🛠️ What Gets Deployed

### Application Files

```
/home/destroyer/spring-boot-crud-redis/
├── target/
│   └── crud-redis-0.0.1-SNAPSHOT.jar
├── spring-boot-crud-redis.service
├── nginx/
│   └── redis-demo.jvm.my.id.conf
└── .env (created from GitHub Secrets)
```

### System Configuration

```
/etc/systemd/system/
└── spring-boot-crud-redis.service

/etc/nginx/
├── sites-available/
│   └── redis-demo.jvm.my.id.conf
└── sites-enabled/
    └── redis-demo.jvm.my.id.conf → ../sites-available/...
```

## 🎭 Deployment Scenarios

### Scenario 1: First Time Deployment

```
✓ Nginx gets installed
✓ Configuration applied
✓ Firewall configured
✓ Application started
✓ All tests pass
✓ Domain verified
```

### Scenario 2: Code Update

```
✓ New JAR transferred
✓ Application restarted
✓ Nginx config updated (if changed)
✓ All tests pass
✓ Domain verified
```

### Scenario 3: Configuration Change

```
✓ New config transferred
✓ Nginx reloaded
✓ Application restarted (if needed)
✓ All tests pass
✓ Domain verified
```

## 🔄 Rollback Strategy

If deployment fails, rollback is easy:

```bash
# Option 1: Revert the commit
git revert HEAD
git push origin main
# GitHub Actions will deploy the previous version

# Option 2: Redeploy previous version
git reset --hard HEAD~1
git push --force origin main
# GitHub Actions will deploy the older version
```

## 📈 Deployment Metrics

Track these metrics in GitHub Actions:

| Metric       | Target  | Current |
|--------------|---------|---------|
| Build Time   | < 2 min | ~30s    |
| Deploy Time  | < 2 min | ~1m     |
| Total Time   | < 5 min | ~1m 30s |
| Success Rate | > 95%   | Monitor |
| Verification | 100%    | 8 tests |

## 🎯 Best Practices

### ✅ Do

- ✅ Push small, incremental changes
- ✅ Test locally before pushing
- ✅ Monitor GitHub Actions after push
- ✅ Check verification tests pass
- ✅ Test domain after deployment

### ❌ Don't

- ❌ Push directly to main without review
- ❌ Deploy during high-traffic hours
- ❌ Ignore failed tests
- ❌ Skip verification step
- ❌ Push large, untested changes

## 🚨 Failure Handling

### If Build Fails

```
✗ Build with Maven failed
→ Check compilation errors in logs
→ Fix code and push again
```

### If Deploy Fails

```
✗ Deploy failed
→ Check SSH connectivity
→ Verify server is accessible
→ Check disk space on server
```

### If Verification Fails

```
✗ Verification test failed
→ Check which test failed
→ SSH into server to debug
→ Check application/nginx logs
→ Fix issue and redeploy
```

## 📞 Quick Commands

```bash
# View deployment status
gh run view

# SSH into server
ssh -i ~/.ssh/deploy_key destroyer@103.125.181.190

# Check application
sudo systemctl status spring-boot-crud-redis

# Check Nginx
sudo systemctl status nginx

# View app logs
sudo journalctl -u spring-boot-crud-redis -f

# View nginx logs
sudo tail -f /var/log/nginx/redis-demo.jvm.my.id.access.log

# Test locally
curl http://localhost:8080
curl https://redis-demo.jvm.my.id
```

## 🎉 Success Indicators

You know deployment succeeded when:

✅ GitHub Actions shows green checkmark
✅ All 5 steps completed successfully
✅ All 8 verification tests passed
✅ Application accessible at https://redis-demo.jvm.my.id
✅ No errors in application logs
✅ Nginx serving requests
✅ All features working correctly

## 📚 Learn More

- **DEPLOYMENT_VERIFICATION.md** - Detailed verification process
- **DEPLOYMENT_SUMMARY.md** - Quick deployment reference
- **CLOUDFLARE_SETUP.md** - Cloudflare configuration
- **.github/workflows/deploy.yml** - Full workflow source

---

## 🚀 Ready to Deploy?

```bash
git add .
git commit -m "Your changes"
git push origin main
```

Watch the magic happen! ✨

**Your application**: https://redis-demo.jvm.my.id
**GitHub Actions**: https://github.com/hendisantika/spring-boot-crud-redis/actions
