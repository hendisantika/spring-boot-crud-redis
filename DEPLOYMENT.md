# Deployment Guide

This guide explains how to deploy the Spring Boot CRUD Redis application to your server using GitHub Actions.

## Server Details

- **Server IP**: 103.125.181.190
- **Username**: destroyer
- **Password**: Naruto2025!
- **Application Port**: 8080
- **Spring Profile**: dev (uses Upstash Cloud Redis)
- **Redis**: Upstash Cloud (no local Docker Redis needed)

## Prerequisites

Before deployment, ensure you have:

1. Access to the GitHub repository settings
2. SSH access to the server (103.125.181.190)
3. Root or sudo privileges on the server
4. **Server already has**:
    - SDKMAN installed
    - Docker Engine installed

## Step 1: Server Setup

First, you need to prepare the server. SSH into your server and run the setup script:

```bash
# SSH into the server
ssh destroyer@103.125.181.190

# Download and run the setup script (or manually copy it to the server)
# If you have the repository cloned on the server:
chmod +x server-setup.sh
./server-setup.sh

# Or run commands manually from the script
```

The setup script will:

- Use SDKMAN to install/configure Java 25
- Verify Docker and Docker Compose installation
- Create application directory at `/home/destroyer/spring-boot-crud-redis`
- Configure firewall rules (if UFW is installed)
- Ensure Docker service is running
- Add user to docker group (if needed)

**Note**: After running the setup script, you may need to log out and log back in for Docker group permissions to take
effect.

## Step 2: Configure GitHub Secrets

Add the following secrets to your GitHub repository:

1. Go to your GitHub repository
2. Navigate to **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Add these three secrets:

| Secret Name       | Value             | Description                     |
|-------------------|-------------------|---------------------------------|
| `SERVER_HOST`     | `103.125.181.190` | Your server IP address          |
| `SERVER_USERNAME` | `destroyer`       | SSH username for deployment     |
| `SERVER_PASSWORD` | `Naruto2025!`     | SSH password for authentication |

### How to Add Secrets:

1. **SERVER_HOST**:
    - Name: `SERVER_HOST`
    - Value: `103.125.181.190`
    - Click **Add secret**

2. **SERVER_USERNAME**:
    - Name: `SERVER_USERNAME`
    - Value: `destroyer`
    - Click **Add secret**

3. **SERVER_PASSWORD**:
    - Name: `SERVER_PASSWORD`
    - Value: `Naruto2025!`
    - Click **Add secret**

## Step 3: Deploy

The deployment is automated via GitHub Actions. There are two ways to trigger a deployment:

### Automatic Deployment (Recommended)

Simply push your changes to the `main` branch:

```bash
git add .
git commit -m "Your commit message"
git push origin main
```

The GitHub Actions workflow will automatically:

1. Build the application using Maven
2. Create a JAR file
3. Transfer files (.jar, .env, compose.yaml) to the server via SCP
4. Deploy and start the application using systemd with dev profile
5. Application will connect to Upstash Cloud Redis (no local Redis needed)

### Manual Deployment

You can also trigger deployment manually:

1. Go to your GitHub repository
2. Click on **Actions** tab
3. Select **Deploy to Server** workflow
4. Click **Run workflow**
5. Select the `main` branch
6. Click **Run workflow**

## Step 4: Monitor Deployment

### Check GitHub Actions

1. Go to **Actions** tab in your GitHub repository
2. Click on the latest workflow run
3. Monitor the deployment progress in real-time
4. Check for any errors in the logs

### Check Application Status on Server

SSH into your server and run:

```bash
# Check application status
sudo systemctl status spring-boot-crud-redis

# Check application logs
sudo journalctl -u spring-boot-crud-redis -f

# Check if the application is running
curl http://localhost:8080

# Check Docker containers (Redis)
docker ps
```

## Step 5: Access Your Application

Once deployed, access your application at:

```
http://103.125.181.190:8080
```

You should see the product management interface.

## Application Management

### Start the Application

```bash
sudo systemctl start spring-boot-crud-redis
```

### Stop the Application

```bash
sudo systemctl stop spring-boot-crud-redis
```

### Restart the Application

```bash
sudo systemctl restart spring-boot-crud-redis
```

### View Application Logs

```bash
# View recent logs
sudo journalctl -u spring-boot-crud-redis -n 100

# Follow logs in real-time
sudo journalctl -u spring-boot-crud-redis -f

# View logs with timestamp
sudo journalctl -u spring-boot-crud-redis --since "1 hour ago"
```

### Check Application Status

```bash
sudo systemctl status spring-boot-crud-redis
```

## Redis Management

This deployment uses **Upstash Cloud Redis**, so there's no need to manage local Redis containers.

### Upstash Redis Details

- **Host**: living-muskrat-23212.upstash.io
- **Port**: 6379
- **SSL/TLS**: Enabled (rediss:// protocol)
- **Credentials**: Stored in `.env` file on the server

### Access Upstash Redis

You can manage your Redis instance through:

1. **Upstash Console**: https://console.upstash.com
2. **RedisInsight** (connect to cloud instance):
    - Host: living-muskrat-23212.upstash.io
    - Port: 6379
    - Username: default
    - Password: (from .env file)
    - TLS: Enabled

### Connect via Redis CLI (Optional)

If you need to access Redis CLI:

```bash
# Install redis-cli if not available
sudo apt install redis-tools

# Connect to Upstash Redis
redis-cli -u rediss://default:password@living-muskrat-23212.upstash.io:6379
```

## Troubleshooting

### Application Won't Start

Check the logs:

```bash
sudo journalctl -u spring-boot-crud-redis -n 50
```

Common issues:

- **Port 8080 in use**: Check if another service is using port 8080
- **Redis connection failed**: Verify .env file has correct Upstash credentials
- **Permission issues**: Ensure destroyer user has proper permissions
- **SSL/TLS errors**: Ensure Upstash Redis TLS is properly configured

### Firewall Issues

If you can't access the application from outside:

```bash
# Check firewall status
sudo ufw status

# Allow port 8080
sudo ufw allow 8080/tcp

# Reload firewall
sudo ufw reload
```

### Redis Connection Issues

```bash
# Check .env file has correct credentials
cat /home/destroyer/spring-boot-crud-redis/.env

# Verify Upstash Redis credentials match
# UPSTASH_ENDPOINT should be: living-muskrat-23212.upstash.io
# UPSTASH_PORT should be: 6379
# UPSTASH_USERNAME should be: default
# UPSTASH_PASSWORD should be: AVqsAAIjcDE2OWRkMGRhYmM4MDk0OWRlOWM4OWE1MmIzZWE5MzRiNXAxMA

# Test connection to Upstash Redis
redis-cli -u rediss://default:AVqsAAIjcDE2OWRkMGRhYmM4MDk0OWRlOWM4OWE1MmIzZWE5MzRiNXAxMA@living-muskrat-23212.upstash.io:6379 ping

# Check application logs for Redis errors
sudo journalctl -u spring-boot-crud-redis -f | grep -i redis
```

### Deployment Failed in GitHub Actions

1. Check the Actions logs in GitHub
2. Verify all secrets are correctly set
3. Ensure the server is accessible via SSH
4. Check if the deployer user has sudo privileges

## Manual Deployment (Fallback)

If GitHub Actions deployment fails, you can deploy manually:

```bash
# On your local machine, build the application
mvn clean package -DskipTests

# Copy the JAR file to the server
scp target/crud-redis-0.0.1-SNAPSHOT.jar deployer@103.125.181.190:/home/deployer/spring-boot-crud-redis/target/

# Copy compose.yaml
scp compose.yaml deployer@103.125.181.190:/home/deployer/spring-boot-crud-redis/

# SSH into the server
ssh deployer@103.125.181.190

# Start Redis
cd /home/deployer/spring-boot-crud-redis
docker-compose up -d

# Restart the application
sudo systemctl restart spring-boot-crud-redis

# Check status
sudo systemctl status spring-boot-crud-redis
```

## Security Recommendations

For production deployment, consider:

1. **Use SSH Keys Instead of Password**:
   ```bash
   # Generate SSH key on your local machine
   ssh-keygen -t ed25519 -C "deployment-key"

   # Copy public key to server
   ssh-copy-id destroyer@103.125.181.190

   # Update GitHub Actions to use SSH key instead of password
   ```

2. **Configure Redis Password**:
    - Add password authentication to Redis in `compose.yaml`
    - Update `application.properties` with Redis password

3. **Enable HTTPS**:
    - Set up Nginx as reverse proxy
    - Configure SSL/TLS certificates (Let's Encrypt)

4. **Set Up Monitoring**:
    - Configure application monitoring (Prometheus, Grafana)
    - Set up log aggregation
    - Configure alerts for downtime

5. **Regular Backups**:
    - Back up Redis data regularly
    - Implement automated backup scripts

## File Structure on Server

```
/home/destroyer/spring-boot-crud-redis/
├── target/
│   └── crud-redis-0.0.1-SNAPSHOT.jar
├── compose.yaml
├── .env
└── spring-boot-crud-redis.service (copied to /etc/systemd/system/)
```

## Environment Variables

The systemd service is configured with:

- `JAVA_OPTS`: `-Xmx512m -Xms256m` (adjust based on your server resources)
- `SPRING_PROFILES_ACTIVE`: `dev` (uses Upstash Cloud Redis)
- **Upstash Credentials**: Loaded from `/home/destroyer/spring-boot-crud-redis/.env`

You can modify these in `/etc/systemd/system/spring-boot-crud-redis.service`

## Updating the Application

To update the application after making changes:

1. Push changes to the `main` branch
2. GitHub Actions will automatically deploy
3. The workflow will:
    - Stop the running application
    - Deploy the new JAR file
    - Restart the application

Or manually:

```bash
# Rebuild and redeploy
git push origin main
```

## Support

If you encounter issues:

1. Check the GitHub Actions logs
2. Check application logs: `sudo journalctl -u spring-boot-crud-redis -f`
3. Check Docker logs: `docker logs spring-boot-redis`
4. Verify network connectivity: `ping 103.125.181.190`
5. Check firewall rules: `sudo ufw status`

---

**Happy Deploying!** 🚀
