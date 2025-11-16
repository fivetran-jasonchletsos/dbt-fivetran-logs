# Setup Guide - dbt-fivetran-logs

This guide will walk you through setting up this dbt project from scratch after cloning the repository.

## Prerequisites Checklist

Before you begin, ensure you have:

- [ ] **Fivetran Account** with the Log connector enabled
- [ ] **Snowflake Account** with appropriate permissions
- [ ] **Python 3.12+** installed
- [ ] **Git** installed
- [ ] Access to generate Snowflake key pairs

## Step-by-Step Setup

### 1. Clone the Repository

```bash
git clone <repository-url>
cd dbt-fivetran-logs
```

### 2. Set Up Python Environment (Recommended)

```bash
# Create a virtual environment
python -m venv venv

# Activate it
# On macOS/Linux:
source venv/bin/activate
# On Windows:
# venv\Scripts\activate

# Install dbt-snowflake
pip install dbt-snowflake
```

### 3. Generate Snowflake Key Pair

#### Option A: Generate New Key Pair

```bash
# Generate private key (PKCS#8 format, no encryption)
openssl genrsa 2048 | openssl pkcs8 -topk8 -inform PEM -out rsa_key.p8 -nocrypt

# Generate public key from private key
openssl rsa -in rsa_key.p8 -pubout -out rsa_key.pub

# Display the public key (you'll need this for Snowflake)
cat rsa_key.pub
```

#### Option B: Use Existing Key Pair

If you already have a key pair, make sure it's in PKCS#8 format. If not, convert it:

```bash
openssl pkcs8 -topk8 -inform PEM -in your_existing_key.pem -out rsa_key.p8 -nocrypt
```

### 4. Configure Snowflake User

Log into Snowflake and run the following SQL to assign the public key to your user:

```sql
-- First, get your public key content (remove BEGIN/END lines and newlines)
-- Then run:
ALTER USER <your_email> SET RSA_PUBLIC_KEY='<public_key_content>';

-- Verify it was set
DESC USER <your_email>;
```

**Important**: When setting the public key:
1. Remove the `-----BEGIN PUBLIC KEY-----` header
2. Remove the `-----END PUBLIC KEY-----` footer
3. Concatenate all remaining lines into a single string (no spaces or newlines)

Example:
```
If your public key is:
-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA...
...more lines...
-----END PUBLIC KEY-----

Use only:
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA...more lines...
```

### 5. Configure Environment Variables

```bash
# Copy the example file
cp .nao.env.example .nao.env

# Edit .nao.env
nano .nao.env  # or use your preferred editor
```

Add your private key content to `.nao.env`:

```bash
SNOWFLAKE_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----
MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC...
[Paste your full private key here - include all lines]
...
-----END PRIVATE KEY-----"

# If your key has a passphrase, add:
# SNOWFLAKE_PRIVATE_KEY_PASSPHRASE="your_passphrase"
```

**Security Note**: The `.nao.env` file is already in `.gitignore` and will not be committed to version control.

### 6. Update dbt Profile

Edit `.dbt/profiles.yml` to match your Snowflake environment:

```yaml
default:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: <your-account-locator>     # e.g., abc12345.us-east-1
      user: <your-email>                  # e.g., john.doe@company.com
      role: <your-role>                   # e.g., ACCOUNTADMIN or ANALYST
      database: <your-database>           # e.g., FIVETRAN_DB
      warehouse: <your-warehouse>         # e.g., COMPUTE_WH
      schema: fivetran_analytics          # Schema where models will be created
      threads: 4
      client_session_keep_alive: False
      query_tag: dbt-fivetran-logs
      private_key_content: "{{ env_var('SNOWFLAKE_PRIVATE_KEY') }}"
```

### 7. Update Source Configuration

Edit `models/staging/src_fivetran_log.yml` to match your Fivetran Log schema:

```yaml
sources:
  - name: fivetran_log
    database: <YOUR_DATABASE>              # Update this
    schema: <YOUR_FIVETRAN_LOG_SCHEMA>     # Update this (e.g., FIVETRAN_LOG)
    # ... rest of the configuration
```

### 8. Test Connection

```bash
dbt debug
```

Expected output:
```
Configuration:
  profiles.yml file [OK found and valid]
  dbt_project.yml file [OK found and valid]

Required dependencies:
 - git [OK found]

Connection:
  account: abc12345.us-east-1
  user: your.email@company.com
  database: YOUR_DATABASE
  warehouse: YOUR_WAREHOUSE
  role: YOUR_ROLE
  schema: fivetran_analytics
  Connection test: [OK connection ok]

All checks passed!
```

### 9. Install dbt Packages (if any)

```bash
dbt deps
```

### 10. Build the Project

Start with a test run on staging models:

```bash
# Build staging models only
dbt run --select staging

# If successful, build everything
dbt build
```

This will:
1. Run all staging models
2. Run all intermediate models
3. Run all mart models
4. Run all tests

### 11. Generate Documentation

```bash
dbt docs generate
dbt docs serve
```

This will open a browser with interactive documentation and lineage graphs.

## Troubleshooting

### Issue: "Could not find profile named 'default'"

**Solution**: Make sure you're in the project directory and `.dbt/profiles.yml` exists.

### Issue: "Invalid private key"

**Solutions**:
1. Ensure your private key is in PKCS#8 format
2. Check that the entire key is in `.nao.env` including BEGIN/END lines
3. Verify there are no extra spaces or characters
4. Make sure the key is enclosed in double quotes

### Issue: "User authentication failed"

**Solutions**:
1. Verify the public key was correctly assigned to your Snowflake user
2. Check that you removed the BEGIN/END lines when setting the public key in Snowflake
3. Ensure you're using the correct user email

### Issue: "Database/Schema not found"

**Solutions**:
1. Verify the database and schema names in `src_fivetran_log.yml`
2. Ensure your Snowflake user has access to the Fivetran Log schema
3. Check that the Fivetran Log connector is enabled and syncing

### Issue: "Compilation Error"

**Solution**: Run `dbt compile` to see detailed error messages about which models are failing.

## Verifying Your Setup

Run these queries in Snowflake to verify your Fivetran Log data:

```sql
-- Check if you have access to Fivetran Log tables
SHOW TABLES IN <YOUR_DATABASE>.<YOUR_FIVETRAN_LOG_SCHEMA>;

-- Check row counts
SELECT 'connection' as table_name, COUNT(*) as row_count 
FROM <YOUR_DATABASE>.<YOUR_FIVETRAN_LOG_SCHEMA>.CONNECTION
UNION ALL
SELECT 'log', COUNT(*) 
FROM <YOUR_DATABASE>.<YOUR_FIVETRAN_LOG_SCHEMA>.LOG
UNION ALL
SELECT 'incremental_mar', COUNT(*) 
FROM <YOUR_DATABASE>.<YOUR_FIVETRAN_LOG_SCHEMA>.INCREMENTAL_MAR;
```

## Next Steps

Once setup is complete:

1. **Explore the models**: Check `models/` directory structure
2. **Review analyses**: See `analyses/fivetran_analytics_queries.sql` for sample queries
3. **Run tests**: `dbt test` to ensure data quality
4. **Schedule runs**: Set up a scheduler (dbt Cloud, Airflow, cron, etc.)
5. **Create dashboards**: Connect your BI tool to the mart models

## Getting Help

- Check the main [README.md](README.md) for project overview
- Review [dbt documentation](https://docs.getdbt.com/)
- Check [Fivetran Log ERD](https://fivetran.com/connector-erd/fivetran_log)
- Contact: jason.chletsos@fivetran.com

## Security Reminders

- ✅ Never commit `.nao.env` to version control
- ✅ Never commit private keys (`.pem`, `.p8` files)
- ✅ Rotate keys periodically
- ✅ Use separate keys for dev/prod environments
- ✅ Use appropriate Snowflake roles with least privilege

---

**Happy Analytics! 📊**
