# GitHub Secrets Configuration

This document describes the GitHub repository secrets required for automated deployment.

## Required Secrets

You need to add the following three secrets to your GitHub repository for the deployment workflow to work.

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

### 3. SERVER_PASSWORD

- **Name**: `SERVER_PASSWORD`
- **Value**: `Naruto2025!`
- **Description**: The SSH password for authentication

## Security Note

⚠️ **Important**: Never commit secrets to your repository. Always use GitHub Secrets for sensitive information like
passwords and API keys.

## Verification

After adding all three secrets, you should see them listed in the repository secrets page:

```
SERVER_HOST          Updated [date]
SERVER_USERNAME      Updated [date]
SERVER_PASSWORD      Updated [date]
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
- Test SSH connection manually: `ssh destroyer@103.125.181.190`

## Related Files

- `.github/workflows/deploy.yml` - GitHub Actions deployment workflow
- `DEPLOYMENT.md` - Complete deployment guide
- `server-setup.sh` - Server preparation script
- `spring-boot-crud-redis.service` - Systemd service configuration
