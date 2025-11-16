# Quick Start Guide

Get up and running with dbt-fivetran-logs in 10 minutes.

## ⚡ Prerequisites

- Snowflake account with Fivetran log data
- dbt Core 1.8.0+ installed
- Snowflake private key generated (see [PRIVATE_KEY_SETUP.md](PRIVATE_KEY_SETUP.md))

## 🚀 5-Minute Setup

### 1. Clone and Navigate

```bash
git clone <repository-url>
cd dbt-fivetran-logs
```

### 2. Configure Environment

```bash
# Copy example environment file
cp .nao.env.example .nao.env

# Edit .nao.env and paste your private key
nano .nao.env  # or use your preferred editor
```

Your `.nao.env` should look like:
```
SNOWFLAKE_PRIVATE_KEY=-----BEGIN PRIVATE KEY-----
MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC...
-----END PRIVATE KEY-----
```

### 3. Update Connection Details

Edit `profiles.yml` with your Snowflake details:

```yaml
default:
  outputs:
    dev:
      type: snowflake
      account: YOUR_ACCOUNT      # e.g., xy12345.us-east-1
      user: YOUR_USER            # e.g., JASON_CHLETSOS
      role: YOUR_ROLE            # e.g., ACCOUNTADMIN
      database: YOUR_DATABASE    # e.g., JASON_CHLETSOS
      warehouse: YOUR_WAREHOUSE  # e.g., COMPUTE_WH
      schema: fivetran_analytics_stg_fivetran_log
      private_key_path: "{{ env_var('SNOWFLAKE_PRIVATE_KEY') }}"
      threads: 4
  target: dev
```

### 4. Test Connection

```bash
dbt debug
```

Expected output:
```
✓ Connection test: [OK connection ok]
```

### 5. Build Everything

```bash
dbt build
```

This will:
- Create 32 staging models (views)
- Create 3 intermediate models (views)
- Create 11 mart models (tables)
- Run 53 data quality tests

Expected: **100 PASS, 0 ERRORS** ✅

## 📊 Verify Your Setup

### Check Model Counts

```bash
dbt ls --resource-type model
```

Should show 47 models.

### Run a Sample Query

Connect to Snowflake and run:

```sql
-- Check connector health
SELECT 
    connection_name,
    connector_name,
    success_rate_last_7d,
    failed_syncs_last_7d,
    last_sync_status
FROM fivetran_analytics.fct_fivetran_connector_health
ORDER BY success_rate_last_7d;
```

## 🎯 What's Next?

### Explore the Analytics

1. **Connector Health Dashboard**
   ```sql
   SELECT * FROM fivetran_analytics.fct_fivetran_connector_health;
   ```

2. **MAR Tracking**
   ```sql
   SELECT * FROM fivetran_analytics.fct_fivetran_monthly_active_rows
   WHERE month_date = DATE_TRUNC('month', CURRENT_DATE());
   ```

3. **Schema Changes**
   ```sql
   SELECT * FROM fivetran_analytics.fct_fivetran_schema_change_history
   WHERE change_detected_at >= DATEADD(day, -7, CURRENT_DATE());
   ```

### Use Pre-Built Queries

Check out `analyses/fivetran_analytics_queries.sql` for 10+ ready-to-use queries:

```bash
# Open in your SQL editor
cat analyses/fivetran_analytics_queries.sql
```

### Set Up Scheduled Runs

Add to your orchestration tool (Airflow, Prefect, etc.):

```bash
# Daily refresh
dbt build --select marts
```

## 🔧 Common Issues

### Issue: "Private key path not found"

**Solution**: Make sure `.nao.env` exists and contains your private key.

```bash
# Check if file exists
ls -la .nao.env

# Verify content (don't share output!)
cat .nao.env
```

### Issue: "Database does not exist"

**Solution**: Update `database` in `profiles.yml` to match your Snowflake database name.

### Issue: "Source 'fivetran_log' not found"

**Solution**: Update the source configuration in `models/staging/src_fivetran_log.yml`:

```yaml
sources:
  - name: fivetran_log
    database: YOUR_DATABASE        # Update this
    schema: YOUR_FIVETRAN_SCHEMA   # Update this (e.g., JASON_CHLETSOS_FIVETRAN_LOG)
```

### Issue: Tests failing

**Solution**: Some tests may fail if you don't have data in all tables. This is normal for new Fivetran accounts.

```bash
# Run models without tests
dbt run
```

## 📚 Learn More

- **[MODEL_REFERENCE.md](MODEL_REFERENCE.md)** - Complete model documentation
- **[SETUP_GUIDE.md](SETUP_GUIDE.md)** - Detailed setup instructions
- **[CONTRIBUTING.md](CONTRIBUTING.md)** - Development guidelines
- **[PROJECT_SUMMARY.md](PROJECT_SUMMARY.md)** - Full project overview

## 💬 Get Help

- **Email**: jason.chletsos@fivetran.com
- **GitHub Issues**: Open an issue in the repository
- **Documentation**: Check the docs listed above

## 🎉 Success Checklist

- [ ] Repository cloned
- [ ] `.nao.env` configured with private key
- [ ] `profiles.yml` updated with Snowflake details
- [ ] `dbt debug` passes
- [ ] `dbt build` completes successfully
- [ ] Sample queries return data
- [ ] Explored the analytics models

---

**Congratulations!** You're now ready to analyze your Fivetran logs! 🚀
