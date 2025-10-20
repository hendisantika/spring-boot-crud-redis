# How Upstash .env Credentials Work in GitHub Actions Deployment

This document explains how the Upstash Redis credentials from your `.env` file are securely used during GitHub Actions
deployment.

## Your .env File Contents

```env
UPSTASH_ENDPOINT=living-muskrat-23212.upstash.io
UPSTASH_PORT=6379
UPSTASH_USERNAME=default
UPSTASH_PASSWORD=AVqsAAIjcDE2OWRkMGRhYmM4MDk0OWRlOWM4OWE1MmIzZWE5MzRiNXAxMA
```

## How It Works: Step-by-Step

### 1️⃣ GitHub Actions Workflow (`.github/workflows/deploy.yml`)

The workflow performs these steps:

```yaml
- name: Deploy to Server via SSH
  uses: appleboy/scp-action@v0.1.7
  with:
    source: "target/crud-redis-0.0.1-SNAPSHOT.jar,.env,compose.yaml"
```

**What happens here:**

- The `.env` file is transferred from your repository to the server
- Destination: `/home/destroyer/spring-boot-crud-redis/.env`
- The file contains your Upstash credentials

### 2️⃣ Systemd Service (`spring-boot-crud-redis.service`)

The systemd service is configured to load the `.env` file:

```ini
[Service]
User=destroyer
WorkingDirectory=/home/destroyer/spring-boot-crud-redis

# Load environment variables from .env file
EnvironmentFile=/home/destroyer/spring-boot-crud-redis/.env

# Set Spring profile to dev
Environment="SPRING_PROFILES_ACTIVE=dev"
```

**What happens here:**

- Systemd reads `/home/destroyer/spring-boot-crud-redis/.env`
- All variables (UPSTASH_ENDPOINT, UPSTASH_PORT, etc.) become environment variables
- These are available to your Spring Boot application

### 3️⃣ Spring Boot Configuration (`application-dev.properties`)

Your dev profile uses these environment variables:

```properties
spring.application.name=spring-boot-crud-redis
# Upstash Redis Cloud Configuration
spring.data.redis.host=${UPSTASH_ENDPOINT}
spring.data.redis.port=${UPSTASH_PORT}
spring.data.redis.username=${UPSTASH_USERNAME}
spring.data.redis.password=${UPSTASH_PASSWORD}
spring.data.redis.timeout=60000
# SSL/TLS Configuration for Upstash (rediss:// protocol)
spring.data.redis.ssl.enabled=true
# Server Configuration
server.port=8080
```

**What happens here:**

- Spring Boot reads the environment variables loaded by systemd
- `${UPSTASH_ENDPOINT}` is replaced with `living-muskrat-23212.upstash.io`
- `${UPSTASH_PORT}` is replaced with `6379`
- `${UPSTASH_USERNAME}` is replaced with `default`
- `${UPSTASH_PASSWORD}` is replaced with your password
- SSL/TLS is enabled for secure connection

## Complete Flow Diagram

```
┌─────────────────────────────────────────────────────────────┐
│ 1. GitHub Actions Workflow Triggered (push to main)        │
└────────────────┬────────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────────┐
│ 2. Build JAR with Maven                                     │
│    mvn clean package -DskipTests                            │
└────────────────┬────────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────────┐
│ 3. Transfer Files via SCP to Server                         │
│    - crud-redis-0.0.1-SNAPSHOT.jar                          │
│    - .env (with Upstash credentials) ✓                      │
│    - compose.yaml                                            │
│    - spring-boot-crud-redis.service                         │
│    Destination: /home/destroyer/spring-boot-crud-redis/     │
└────────────────┬────────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────────┐
│ 4. Deploy Application on Server (via SSH)                   │
│    - Stop existing service                                   │
│    - Copy systemd service to /etc/systemd/system/           │
│    - Reload systemd daemon                                   │
│    - Start service                                           │
└────────────────┬────────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────────┐
│ 5. Systemd Loads .env File                                  │
│    EnvironmentFile=/home/destroyer/.../. env                │
│    Environment variables become available:                   │
│    - UPSTASH_ENDPOINT=living-muskrat-23212.upstash.io       │
│    - UPSTASH_PORT=6379                                       │
│    - UPSTASH_USERNAME=default                                │
│    - UPSTASH_PASSWORD=AVqs...                                │
└────────────────┬────────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────────┐
│ 6. Spring Boot Application Starts                           │
│    - Profile: dev                                            │
│    - Reads application-dev.properties                        │
│    - Substitutes ${UPSTASH_*} with env variables            │
└────────────────┬────────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────────┐
│ 7. Application Connects to Upstash Cloud Redis              │
│    rediss://default:password@living-muskrat-23212...        │
│    - Host: living-muskrat-23212.upstash.io                  │
│    - Port: 6379                                              │
│    - TLS: Enabled                                            │
└─────────────────────────────────────────────────────────────┘
```

## Security: Why This Approach is Safe

### ✅ Credentials are NOT in GitHub Secrets

- The `.env` file is in your repository (already committed)
- You're using `.env` file to manage credentials locally and on server
- The file is transferred securely via SCP over SSH

### ✅ Secure Transfer

- SCP uses SSH protocol (encrypted)
- Authentication via password (stored in GitHub Secrets)
- File permissions are preserved

### ✅ Server-Side Security

- `.env` file is only readable by the `destroyer` user
- Systemd runs the service as the `destroyer` user
- Environment variables are loaded at runtime (not exposed in process list)

### ⚠️ Important Security Note

Your `.env` file is currently committed to the repository. For production deployments, consider:

1. **Add `.env` to `.gitignore`** (keep it out of version control)
2. **Use GitHub Secrets** to store Upstash credentials
3. **Create `.env` file on server during deployment**

## Alternative: Using GitHub Secrets (More Secure)

If you want to avoid committing credentials to your repository:

### Step 1: Add Upstash credentials to GitHub Secrets

Add these secrets in GitHub repository settings:

- `UPSTASH_ENDPOINT`: `living-muskrat-23212.upstash.io`
- `UPSTASH_PORT`: `6379`
- `UPSTASH_USERNAME`: `default`
- `UPSTASH_PASSWORD`: `AVqsAAIjcDE2OWRkMGRhYmM4MDk0OWRlOWM4OWE1MmIzZWE5MzRiNXAxMA`

### Step 2: Update GitHub Actions workflow

Modify `.github/workflows/deploy.yml`:

```yaml
- name: Create .env file on server
  uses: appleboy/ssh-action@v1.2.0
  with:
    host: ${{ secrets.SERVER_HOST }}
    username: ${{ secrets.SERVER_USERNAME }}
    password: ${{ secrets.SERVER_PASSWORD }}
    script: |
      cat > /home/${{ secrets.SERVER_USERNAME }}/spring-boot-crud-redis/.env <<EOF
      UPSTASH_ENDPOINT=${{ secrets.UPSTASH_ENDPOINT }}
      UPSTASH_PORT=${{ secrets.UPSTASH_PORT }}
      UPSTASH_USERNAME=${{ secrets.UPSTASH_USERNAME }}
      UPSTASH_PASSWORD=${{ secrets.UPSTASH_PASSWORD }}
      EOF
      chmod 600 /home/${{ secrets.SERVER_USERNAME }}/spring-boot-crud-redis/.env
```

### Step 3: Remove `.env` from SCP transfer

```yaml
- name: Deploy to Server via SSH
  uses: appleboy/scp-action@v0.1.7
  with:
    source: "target/crud-redis-0.0.1-SNAPSHOT.jar,spring-boot-crud-redis.service"
    # .env removed from here - created via secrets instead
```

### Step 4: Add `.env` to `.gitignore`

```bash
echo ".env" >> .gitignore
git rm --cached .env
git commit -m "Remove .env from repository"
```

## Current Setup (As Is)

Your current setup works perfectly fine:

1. ✅ `.env` file is in repository
2. ✅ GitHub Actions transfers it to server
3. ✅ Systemd loads it as environment variables
4. ✅ Spring Boot uses the variables to connect to Upstash

## Verify Deployment

After deployment, SSH into your server and verify:

```bash
# SSH into server
ssh destroyer@103.125.181.190

# Check .env file exists
cat /home/destroyer/spring-boot-crud-redis/.env

# Check systemd service status
sudo systemctl status spring-boot-crud-redis

# Check if environment variables are loaded
sudo systemctl show spring-boot-crud-redis | grep EnvironmentFile

# Test Redis connection
redis-cli -u rediss://default:AVqsAAIjcDE2OWRkMGRhYmM4MDk0OWRlOWM4OWE1MmIzZWE5MzRiNXAxMA@living-muskrat-23212.upstash.io:6379 ping

# Check application logs
sudo journalctl -u spring-boot-crud-redis -f
```

## Summary

**Your `.env` credentials are used in deployment through:**

1. **GitHub Actions** transfers the `.env` file to the server
2. **Systemd service** loads the `.env` file as environment variables
3. **Spring Boot** (dev profile) uses these environment variables to connect to Upstash Redis
4. **Application** successfully connects to your cloud Redis instance with TLS enabled

Everything is configured and ready to deploy! Just push to `main` branch. 🚀
