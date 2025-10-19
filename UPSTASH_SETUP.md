# Upstash Redis Cloud Setup Guide

This guide explains how to configure the application to use Upstash Redis Cloud for the **dev** profile.

## Step 1: Get Your Upstash Redis Credentials

1. Go to your Upstash Redis instance at: https://console.upstash.com

2. In the **Details** tab, look for the **Jedis** connection example:
   ```
   rediss://default:PASSWORD@ENDPOINT:6379
   ```

3. From this URI, extract:
    - **Endpoint**: The hostname (e.g., `your-instance-12345.upstash.io`)
    - **Port**: Usually `6379`
    - **Username**: Usually `default`
    - **Password**: The long alphanumeric string between `:` and `@`

## Step 2: Update application-dev.properties

Open `src/main/resources/application-dev.properties` and replace the placeholders:

```properties
# Upstash Redis Cloud Configuration
spring.data.redis.host=YOUR_UPSTASH_ENDPOINT
spring.data.redis.port=YOUR_UPSTASH_PORT
spring.data.redis.username=default
spring.data.redis.password=YOUR_UPSTASH_PASSWORD
spring.data.redis.ssl.enabled=true
```

### Example Configuration:

From the Upstash Jedis connection example:

```java
// URI: rediss://default:PASSWORD@ENDPOINT:6379
URI.create("rediss://default:YOUR_PASSWORD@your-instance-12345.upstash.io:6379")
```

Translate to properties:

```properties
# Upstash Redis Cloud Configuration
spring.data.redis.host=your-instance-12345.upstash.io
spring.data.redis.port=6379
spring.data.redis.username=default
spring.data.redis.password=YOUR_UPSTASH_PASSWORD_HERE
spring.data.redis.ssl.enabled=true
```

**Important Notes:**

- ✅ Use `rediss://` format from Upstash (SSL/TLS enabled)
- ✅ Extract the **hostname only** (don't include `rediss://` or protocol)
- ✅ Include the **username** (usually `default` for Upstash)
- ✅ The password is a long alphanumeric string
- ❌ Do NOT include `https://` in the hostname
- ❌ Do NOT include `rediss://` in the hostname

## Step 3: Run with Dev Profile

Run the application using the **dev** profile:

### Using Maven:

```bash
./mvnw spring-boot:run -Dspring-boot.run.profiles=dev
```

### Using Java:

```bash
java -jar target/crud-redis-0.0.1-SNAPSHOT.jar --spring.profiles.active=dev
```

### In IntelliJ IDEA:

1. Edit Run Configuration
2. Add to **VM Options** or **Program Arguments**: `--spring.profiles.active=dev`
3. Run the application

## Step 4: Verify Connection

Check the console logs on startup. You should see:

```
Initializing sample products...
Created product: Apple MacBook Pro 16" (ID: xxx-xxx-xxx)
...
```

If you see connection errors, verify:

- ✅ Endpoint is correct (no `rediss://` prefix)
- ✅ Port is correct (usually 6379)
- ✅ Password is copied correctly (no extra spaces)
- ✅ SSL is enabled in properties

## Alternative: Using Environment Variables

Instead of hardcoding credentials in `application-dev.properties`, you can use environment variables:

```properties
spring.data.redis.host=${REDIS_HOST}
spring.data.redis.port=${REDIS_PORT}
spring.data.redis.password=${REDIS_PASSWORD}
```

Then set environment variables:

### Linux/Mac:

```bash
export REDIS_HOST=regional-possum-12345.upstash.io
export REDIS_PORT=6379
export REDIS_PASSWORD=AYNzAAIncDE1NzQ4ZmE0MGNjOWI0MjkxOTMxYWU0MzEwNGQ0N2ZiNXAxMA
```

### Windows (PowerShell):

```powershell
$env:REDIS_HOST="regional-possum-12345.upstash.io"
$env:REDIS_PORT="6379"
$env:REDIS_PASSWORD="AYNzAAIncDE1NzQ4ZmE0MGNjOWI0MjkxOTMxYWU0MzEwNGQ0N2ZiNXAxMA"
```

## Upstash Redis Features

Upstash provides:

- ✅ **Serverless**: Pay only for what you use
- ✅ **Global**: Low-latency access worldwide
- ✅ **Durable**: Data persistence with daily backups
- ✅ **TLS/SSL**: Encrypted connections
- ✅ **REST API**: Access via HTTP when needed
- ✅ **Free Tier**: 10,000 commands per day

## Troubleshooting

### Connection Timeout

```
Caused by: redis.clients.jedis.exceptions.JedisConnectionException: Connect timeout
```

**Solution:** Verify your firewall/network allows outbound connections to Upstash.

### Authentication Failed

```
WRONGPASS invalid username-password pair
```

**Solution:** Double-check the password from Upstash console. Click "reveal" to copy it.

### SSL/TLS Error

```
javax.net.ssl.SSLHandshakeException
```

**Solution:** Ensure `spring.data.redis.ssl.enabled=true` is set.

### Unknown Host

```
java.net.UnknownHostException
```

**Solution:** Check the endpoint hostname is correct (no `rediss://` prefix).

## Switching Between Local and Cloud Redis

### Local Development (default profile):

```bash
./mvnw spring-boot:run
```

Uses Docker Redis (localhost:6379)

### Cloud Development (dev profile):

```bash
./mvnw spring-boot:run -Dspring-boot.run.profiles=dev
```

Uses Upstash Redis Cloud

## Security Best Practices

1. **Never commit credentials** to Git
    - Add `application-dev.properties` to `.gitignore` if it contains real credentials
    - Use environment variables in production

2. **Use different instances** for dev/staging/production
    - Create separate Upstash databases for each environment

3. **Rotate passwords** regularly
    - Upstash allows you to regenerate passwords

4. **Monitor usage** in Upstash console
    - Check for unusual activity
    - Set up alerts for high usage

---

**Happy Coding with Upstash Redis Cloud!** 🚀
