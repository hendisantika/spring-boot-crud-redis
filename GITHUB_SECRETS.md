# GitHub Secrets Configuration

This document describes the GitHub repository secrets required for automated deployment.

## Required Secrets

You need to add the following **seven** secrets to your GitHub repository for the deployment workflow to work.

⚠️ **Important**: This setup uses SSH key authentication (more secure) instead of password authentication.

### How to Add Secrets

1. Go to your GitHub repository: https://github.com/hendisantika/spring-boot-crud-redis
2. Click on **Settings** tab
3. In the left sidebar, navigate to **Security** → **Secrets and variables** → **Actions**
4. Click the **New repository secret** button
5. Add each of the following secrets:

## Secret Details

### 1. SERVER_HOST

- **Name**: `SERVER_HOST`
- **Value**: `103.125.181.190`
- **Description**: The IP address of your deployment server

### 2. SERVER_USERNAME

- **Name**: `SERVER_USERNAME`
- **Value**: `destroyer`
- **Description**: The SSH username used to connect to the server

### 3. SERVER_SSH_KEY

- **Name**: `SERVER_SSH_KEY`
- **Value**: Your private SSH key content (see setup instructions below)
- **Description**: SSH private key for authentication (more secure than password)

### 4. UPSTASH_ENDPOINT

- **Name**: `UPSTASH_ENDPOINT`
- **Value**: `UPSTASH_ENDPOINT`
- **Description**: Upstash Redis cloud endpoint

### 5. UPSTASH_PORT

- **Name**: `UPSTASH_PORT`
- **Value**: `6379`
- **Description**: Upstash Redis port

### 6. UPSTASH_USERNAME

- **Name**: `UPSTASH_USERNAME`
- **Value**: `default`
- **Description**: Upstash Redis username

### 7. UPSTASH_PASSWORD

- **Name**: `UPSTASH_PASSWORD`
- **Value**: `UPSTASH_PASSWORD`
- **Description**: Upstash Redis password

## SSH Key Setup Instructions

Before adding the `SERVER_SSH_KEY` secret, you need to generate and configure SSH keys:

### Step 1: Generate SSH Key Pair (on your local machine)

```bash
# Generate a new ED25519 SSH key (recommended)
ssh-keygen -t ed25519 -C "github-actions-deploy" -f ~/.ssh/deploy_key -N ""

# Or use RSA if ED25519 is not supported
ssh-keygen -t rsa -b 4096 -C "github-actions-deploy" -f ~/.ssh/deploy_key -N ""
```

This creates two files:

- `~/.ssh/deploy_key` - **Private key** (add to GitHub Secrets)
- `~/.ssh/deploy_key.pub` - **Public key** (add to server)

### Step 2: Add Public Key to Server

```bash
# Copy the public key to the server
ssh-copy-id -i ~/.ssh/deploy_key.pub destroyer@103.125.181.190

# Or manually:
cat ~/.ssh/deploy_key.pub | ssh destroyer@103.125.181.190 "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 700 ~/.ssh && chmod 600 ~/.ssh/authorized_keys"
```

### Step 3: Test SSH Key Authentication

```bash
# Test the SSH connection with the private key
ssh -i ~/.ssh/deploy_key destroyer@103.125.181.190

# If successful, you should be able to log in without a password
```

### Step 4: Add Private Key to GitHub Secrets

```bash
# Display the private key (copy this entire output)
cat ~/.ssh/deploy_key
```

Copy the entire output including the header and footer:

```
-----BEGIN OPENSSH PRIVATE KEY-----
...key content...
-----END OPENSSH PRIVATE KEY-----
```

Then add it as `SERVER_SSH_KEY` secret in GitHub.

## Security Note

⚠️ **Important**:

- Never commit secrets or private keys to your repository
- Always use GitHub Secrets for sensitive information
- SSH key authentication is more secure than password authentication
- Keep your private key safe and never share it

## Verification

After adding all seven secrets, you should see them listed in the repository secrets page:

```
SERVER_HOST          Updated [date]
SERVER_USERNAME      Updated [date]
SERVER_SSH_KEY       Updated [date]
UPSTASH_ENDPOINT     Updated [date]
UPSTASH_PORT         Updated [date]
UPSTASH_USERNAME     Updated [date]
UPSTASH_PASSWORD     Updated [date]
```

## Testing the Deployment

Once the secrets are configured:

1. Make a small change to your code
2. Commit and push to the `main` branch
3. Go to the **Actions** tab in GitHub
4. Watch the "Deploy to Server" workflow run
5. Verify successful deployment

## Alternative: SSH Key Authentication (Recommended for Production)

For better security, consider using SSH key authentication instead of passwords:

1. Generate an SSH key pair:
   ```bash
   ssh-keygen -t ed25519 -C "github-actions-deploy" -f deploy_key
   ```

2. Add the public key to the server:
   ```bash
   ssh-copy-id -i deploy_key.pub deployer@103.125.181.190
   ```

3. Add the private key as a GitHub secret:
    - **Name**: `SERVER_SSH_KEY`
    - **Value**: Contents of `deploy_key` file

4. Update the GitHub Actions workflow to use the SSH key instead of password

## Troubleshooting

### Secrets Not Working

- Ensure secret names match exactly (case-sensitive)
- Verify there are no extra spaces in the secret values
- Check that the secrets are added to the repository (not organization-level)

### Deployment Fails

- Check the Actions logs for detailed error messages
- Verify the server is accessible: `ping 103.125.181.190`
- Test SSH connection with key: `ssh -i ~/.ssh/deploy_key destroyer@103.125.181.190`
- Ensure the public key is in `~/.ssh/authorized_keys` on the server
- Check SSH key format is correct (should include BEGIN and END lines)

## Benefits of SSH Key Authentication

✅ **More Secure**: Keys are cryptographically stronger than passwords
✅ **No Password Exposure**: Private key never leaves your machine/GitHub Secrets
✅ **Better Access Control**: Can easily revoke keys without changing passwords
✅ **Industry Standard**: Recommended for automated deployments

## Related Files

- `.github/workflows/deploy.yml` - GitHub Actions deployment workflow
- `DEPLOYMENT.md` - Complete deployment guide
- `server-setup.sh` - Server preparation script
- `spring-boot-crud-redis.service` - Systemd service configuration
