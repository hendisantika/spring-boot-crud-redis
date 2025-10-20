# SSH Key Authentication Setup Guide

## 🔐 Why SSH Keys Instead of Passwords?

Your deployment now uses **SSH key authentication** instead of passwords, which provides:

- ✅ **Better Security**: Cryptographically stronger than passwords
- ✅ **No Password Exposure**: Keys are never transmitted over the network
- ✅ **Easy Revocation**: Can disable keys without changing passwords
- ✅ **Industry Standard**: Recommended for CI/CD pipelines

## 🚀 Quick Setup (Automated)

Run the automated setup script:

```bash
chmod +x setup-ssh-key.sh
./setup-ssh-key.sh
```

This script will:

1. Generate ED25519 SSH key pair
2. Copy public key to your server
3. Test the connection
4. Display the private key for GitHub Secrets

## 📝 Manual Setup

If you prefer to set up manually:

### Step 1: Generate SSH Key Pair

```bash
ssh-keygen -t ed25519 -C "github-actions-deploy" -f ~/.ssh/deploy_key -N ""
```

**Output:**

- `~/.ssh/deploy_key` - Private key (for GitHub Secrets)
- `~/.ssh/deploy_key.pub` - Public key (for server)

### Step 2: Add Public Key to Server

```bash
# Easy way (requires password: Naruto2025!)
ssh-copy-id -i ~/.ssh/deploy_key.pub destroyer@103.125.181.190

# Manual way (if ssh-copy-id doesn't work)
cat ~/.ssh/deploy_key.pub | ssh destroyer@103.125.181.190 \
  "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 700 ~/.ssh && chmod 600 ~/.ssh/authorized_keys"
```

### Step 3: Test Connection

```bash
ssh -i ~/.ssh/deploy_key destroyer@103.125.181.190
```

If successful, you'll log in **without a password**!

### Step 4: Add Private Key to GitHub Secrets

```bash
# Display private key
cat ~/.ssh/deploy_key
```

Copy the **entire output** including:

```
-----BEGIN OPENSSH PRIVATE KEY-----
... key content ...
-----END OPENSSH PRIVATE KEY-----
```

## 🔑 GitHub Secrets Configuration

Go to: https://github.com/hendisantika/spring-boot-crud-redis/settings/secrets/actions

Add these **7 secrets**:

| Secret Name        | Value                                                        |
|--------------------|--------------------------------------------------------------|
| `SERVER_HOST`      | `103.125.181.190`                                            |
| `SERVER_USERNAME`  | `destroyer`                                                  |
| `SERVER_SSH_KEY`   | Private key content (from `cat ~/.ssh/deploy_key`)           |
| `UPSTASH_ENDPOINT` | `living-muskrat-23212.upstash.io`                            |
| `UPSTASH_PORT`     | `6379`                                                       |
| `UPSTASH_USERNAME` | `default`                                                    |
| `UPSTASH_PASSWORD` | `AVqsAAIjcDE2OWRkMGRhYmM4MDk0OWRlOWM4OWE1MmIzZWE5MzRiNXAxMA` |

## ✅ Verify Setup

### 1. Test SSH Key Authentication

```bash
# Should log in without password
ssh -i ~/.ssh/deploy_key destroyer@103.125.181.190
```

### 2. Check GitHub Secrets

Go to repository → Settings → Secrets and variables → Actions

Verify all 7 secrets are present:

- ✅ SERVER_HOST
- ✅ SERVER_USERNAME
- ✅ SERVER_SSH_KEY
- ✅ UPSTASH_ENDPOINT
- ✅ UPSTASH_PORT
- ✅ UPSTASH_USERNAME
- ✅ UPSTASH_PASSWORD

### 3. Test Deployment

```bash
git add .
git commit -m "Configure SSH key authentication"
git push origin main
```

Watch GitHub Actions workflow at:
https://github.com/hendisantika/spring-boot-crud-redis/actions

## 🔍 Troubleshooting

### SSH Connection Fails

```bash
# Check if public key is on server
ssh destroyer@103.125.181.190 "cat ~/.ssh/authorized_keys"

# Check permissions
ssh destroyer@103.125.181.190 "ls -la ~/.ssh/"

# Should show:
# drwx------  .ssh
# -rw-------  authorized_keys
```

### GitHub Actions Fails with "Permission denied"

1. Verify `SERVER_SSH_KEY` includes BEGIN and END lines
2. Check for extra spaces or newlines in the secret
3. Ensure the private key matches the public key on the server

### Key Format Issues

```bash
# Check key type
head -n 1 ~/.ssh/deploy_key
# Should show: -----BEGIN OPENSSH PRIVATE KEY-----

# If you see RSA or DSA, regenerate with ED25519
ssh-keygen -t ed25519 -C "github-actions-deploy" -f ~/.ssh/deploy_key -N ""
```

## 🛡️ Security Best Practices

### ✅ Do

- Keep private key secure (never commit to Git)
- Use strong key types (ED25519 or RSA 4096)
- Regularly rotate keys
- Use separate keys for different purposes

### ❌ Don't

- Share private keys
- Commit keys to repository
- Use the same key everywhere
- Use weak encryption (DSA, RSA 1024)

## 📊 Deployment Flow with SSH Keys

```
1. GitHub Actions triggered
   ↓
2. Build application (Maven)
   ↓
3. SCP transfer using SSH key
   - Authenticates with SERVER_SSH_KEY
   - Transfers JAR and service files
   ↓
4. SSH into server using SSH key
   - Creates .env from secrets
   - Configures systemd service
   - Starts application
   ↓
5. Application running!
   http://103.125.181.190:8080
```

## 📚 Related Documentation

- **GITHUB_SECRETS.md** - Complete secrets configuration guide
- **DEPLOYMENT_SUMMARY.md** - Quick deployment reference
- **DEPLOYMENT.md** - Full deployment documentation
- **setup-ssh-key.sh** - Automated setup script

## 🎯 What Changed from Password to SSH Key?

### Before (Password Authentication)

```yaml
uses: appleboy/scp-action@v0.1.7
with:
  password: ${{ secrets.SERVER_PASSWORD }}
```

### After (SSH Key Authentication)

```yaml
uses: appleboy/scp-action@v0.1.7
with:
  key: ${{ secrets.SERVER_SSH_KEY }}
```

**Result**: More secure, no password exposure, better access control!

---

**Ready to deploy securely!** 🔒🚀
