# Private Key Setup - Quick Reference

## Why Use Private Key Instead of File Path?

 **More Secure**: Key stored in environment variable, not in filesystem  
 **Better for CI/CD**: Easy to inject secrets in deployment pipelines  
 **Portable**: Works across different environments without file path issues  
 **Version Control Safe**: Environment variables never committed to git

## Converting Your Existing Private Key

If you already have a private key file (e.g., `/path/to/your/rsa_key.pem`), here's how to convert it:

### Method 1: Using the Helper Script

```bash
./scripts/convert_key_to_env.sh /path/to/your/rsa_key.pem
```

This will output the formatted key ready to paste into `.nao.env`.

### Method 2: Manual Copy

```bash
# Simply display your key
cat /path/to/your/rsa_key.pem

# Copy the entire output (including BEGIN/END lines)
# Paste into .nao.env like this:
```

```bash
SNOWFLAKE_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----
MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC...
[all the lines of your key]
...
-----END PRIVATE KEY-----"
```

## What Changed in Your Configuration

### Before (File Path Method)
```yaml
# .dbt/profiles.yml
private_key_path: /Users/jason.chletsos/Downloads/rsa_key.pem
```

### After (Environment Variable Method)
```yaml
# .dbt/profiles.yml
private_key_content: "{{ env_var('SNOWFLAKE_PRIVATE_KEY') }}"
```

```bash
# .nao.env
SNOWFLAKE_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----
...your key content...
-----END PRIVATE KEY-----"
```

## Verifying It Works

```bash
# Test the connection
dbt debug

# You should see:
# Connection test: [OK connection ok]
```

## Troubleshooting

### Error: "Could not deserialize key data"

**Cause**: Key format issue  
**Solution**: Ensure your key is in PKCS#8 format. Convert if needed:

```bash
openssl pkcs8 -topk8 -inform PEM -in rsa_key.pem -out rsa_key.p8 -nocrypt
```

Then use `rsa_key.p8` as your private key.

### Error: "Environment variable 'SNOWFLAKE_PRIVATE_KEY' not found"

**Cause**: `.nao.env` file not found or not loaded  
**Solutions**:
1. Ensure `.nao.env` exists in project root
2. Check that `SNOWFLAKE_PRIVATE_KEY` is set in `.nao.env`
3. Restart your terminal/IDE

### Error: "Invalid private key"

**Cause**: Key content not properly formatted in `.nao.env`  
**Solution**: 
1. Ensure the key is enclosed in double quotes
2. Include the BEGIN and END lines
3. No extra spaces or characters

## Security Best Practices

### DO:
- Store private key in `.nao.env` (already in `.gitignore`)
- Use different keys for dev/prod environments
- Rotate keys periodically (every 90 days)
- Set appropriate file permissions: `chmod 600 .nao.env`
- Use Snowflake roles with least privilege

### DON'T:
- Commit `.nao.env` to git (it's already in `.gitignore`)
- Share your private key via email/Slack
- Use the same key across multiple environments
- Store keys in plain text files outside of `.nao.env`
- Give your Snowflake user more permissions than needed

## For CI/CD Pipelines

In GitHub Actions, GitLab CI, or other CI/CD tools, set the private key as a secret:

### GitHub Actions
```yaml
# .github/workflows/dbt.yml
env:
  SNOWFLAKE_PRIVATE_KEY: ${{ secrets.SNOWFLAKE_PRIVATE_KEY }}
```

### GitLab CI
```yaml
# .gitlab-ci.yml
variables:
  SNOWFLAKE_PRIVATE_KEY: $SNOWFLAKE_PRIVATE_KEY
```

Then add the key content to your repository secrets.

## Need Help?

- Check [SETUP_GUIDE.md](SETUP_GUIDE.md) for full setup instructions
- Review [Snowflake Key Pair Authentication Docs](https://docs.snowflake.com/en/user-guide/key-pair-auth)
- Contact: jason.chletsos@fivetran.com

---

**Remember**: Your private key is like a password - keep it secret, keep it safe! 🔐
