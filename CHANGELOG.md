# Changelog

All notable changes to this project will be documented in this file.

## [2025-11-15] - Project Rename to dbt-fivetran-logs

### Changed
- 🔄 **Project Name**: Renamed from `dbt-nao-testing` to `dbt-fivetran-logs`
  - Updated `dbt_project.yml`: `name: 'dbt_fivetran_logs'`
  - Updated model configurations to use new project name
  - Updated query tag to `dbt-fivetran-logs`
- 🔄 **Documentation**: Updated all README files to reflect new project name
- 🔄 **Removed Personal Information**: Cleaned up setup guides to use placeholder values
- ✅ **Added**: `RENAME_PROJECT.md` with step-by-step instructions for completing the rename

### Note
Schema names remain unchanged:
- `stg_fivetran_log` (staging)
- `int_fivetran_log` (intermediate)  
- `fivetran_analytics` (marts)

---

## [2025-11-15] - Fivetran Log ERD Compliance & Private Key Setup

### Added
- ✅ **Fivetran Log ERD Compliance**: Updated source definitions to include all tables from the official [Fivetran Log ERD](https://fivetran.com/connector-erd/fivetran_log)
  - Added `account` table
  - Added `audit_trail` table for governance
  - Added schema metadata tables (`source_schema`, `source_table`, `source_column`, `destination_schema`, `destination_table`, `destination_column`)
  - Added change event tables for tracking schema evolution
  - Added lineage tables (`schema_lineage`, `table_lineage`, `column_lineage`)
  - Added access control tables (`team`, `team_membership`, `role`, `role_permission`, `role_connector_type`, `resource_membership`)
  - Added `connector_sdk_log` for custom connector monitoring

- ✅ **New Staging Models**:
  - `stg_fivetran_log__account.sql` - Account information
  - `stg_fivetran_log__audit_trail.sql` - Audit trail events
  - `stg_fivetran_log__destination_column_change_event.sql` - Schema change tracking

- ✅ **Environment Variable Configuration**:
  - Converted from file-based private key (`private_key_path`) to environment variable (`private_key_content`)
  - Created `.nao.env` for secure credential storage
  - Created `.nao.env.example` as a template for new users

- ✅ **Comprehensive Documentation**:
  - **README.md** - Main project documentation with quick links
  - **PROJECT_SUMMARY.md** - Detailed overview of analytics capabilities
  - **SETUP_GUIDE.md** - Step-by-step setup instructions for new users
  - **PRIVATE_KEY_SETUP.md** - Quick reference for private key configuration
  - **CHANGELOG.md** - This file

- ✅ **Helper Scripts**:
  - `scripts/convert_key_to_env.sh` - Utility to convert private key files to environment variable format

### Changed
- 🔄 **profiles.yml**: Updated to use environment variable for private key instead of file path
  - Before: `private_key_path: /path/to/key.pem`
  - After: `private_key_content: "{{ env_var('SNOWFLAKE_PRIVATE_KEY') }}"`

- 🔄 **src_fivetran_log.yml**: Expanded source definition to include all Fivetran Log ERD tables
  - Added 20+ new table definitions
  - Organized tables by category (Core, Usage & Billing, Schema & Lineage, Change Events, Lineage, Access Control, Audit & Monitoring)
  - Added comprehensive descriptions for each table

- 🔄 **stg_fivetran_log.yml**: Added documentation for new staging models
  - `stg_fivetran_log__account`
  - `stg_fivetran_log__audit_trail`
  - `stg_fivetran_log__destination_column_change_event`

### Security Improvements
- 🔐 Updated `.gitignore` to exclude sensitive files:
  - `.nao.env` (environment variables)
  - `.env` (alternative environment file)
  - `*.pem` (private key files)
  - `*.key` (key files)
  - `.user.yml` (user-specific configuration)

- 🔐 Private key now stored in environment variable instead of filesystem
- 🔐 Better CI/CD compatibility with secret injection
- 🔐 No hardcoded credentials in version control

### Documentation Highlights

#### What This Project Analyzes
1. **Connector Health & Monitoring** - Real-time health scores and sync analysis
2. **Usage & Billing Optimization** - MAR tracking and cost optimization
3. **Performance Analytics** - Sync duration and API usage patterns
4. **Error & Issue Management** - Error classification and recurring issue detection
5. **Schema Change Tracking** - Column-level change detection and lineage
6. **Governance & Audit** - User activity and access control monitoring
7. **Optimization Recommendations** - Actionable improvement suggestions

#### Key Analytics Models
- `fct_fivetran_executive_dashboard` - Executive KPIs
- `fct_fivetran_connector_health` - Connector health metrics
- `fct_fivetran_monthly_active_rows` - MAR analysis
- `fct_fivetran_sync_performance` - Performance deep-dive
- `fct_fivetran_error_monitoring` - Error tracking
- `fct_fivetran_problematic_connectors` - Issue identification
- `fct_fivetran_schema_change_history` - Schema evolution
- `fct_fivetran_user_activity` - Governance audit
- `fct_fivetran_connector_recommendations` - Optimization guidance

#### Analysis Queries
- `analyses/fivetran_analytics_queries.sql` (7.5 KB) - 10 categories of ready-to-use queries
- `analyses/fivetran_data_check.sql` (7.3 KB) - Diagnostic queries for troubleshooting
- `analyses/table_row_counts.sql` (4.1 KB) - Data volume analysis

### Migration Guide

If you're upgrading from the file-based private key method:

1. **Copy your private key content**:
   ```bash
   cat /path/to/your/rsa_key.pem
   ```

2. **Create `.nao.env` file**:
   ```bash
   cp .nao.env.example .nao.env
   ```

3. **Add your private key to `.nao.env`**:
   ```bash
   SNOWFLAKE_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----
   [Your full private key content]
   -----END PRIVATE KEY-----"
   ```

4. **Test the connection**:
   ```bash
   dbt debug
   ```

5. **Remove the old private key file** (optional but recommended for security)

### Breaking Changes
- ⚠️ **profiles.yml format changed**: If you pull these changes, you must create a `.nao.env` file with your private key
- ⚠️ **Source definition expanded**: New tables added to `src_fivetran_log.yml` - may require `dbt deps` or `dbt clean`

### For New Users
Simply follow the [SETUP_GUIDE.md](SETUP_GUIDE.md) for complete setup instructions.

### For Existing Users
1. Pull the latest changes
2. Create `.nao.env` from `.nao.env.example`
3. Add your private key to `.nao.env`
4. Run `dbt debug` to verify connection
5. Run `dbt build` to rebuild with new source definitions

---

## Previous Versions

### [Initial Release]
- Basic Fivetran Log analytics project
- Staging, intermediate, and mart layers
- Core analytics models for usage, performance, monitoring, and governance
- File-based private key authentication

---

**For questions or support**: jason.chletsos@fivetran.com
