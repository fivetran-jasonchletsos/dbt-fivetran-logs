# Fivetran Logs Analytics

A production-ready dbt project that transforms Fivetran's Connector Platform logs into actionable analytics. While Fivetran provides a comprehensive [log connector](https://fivetran.com/connector-erd/fivetran_log) with raw data, this project delivers pre-built fact tables optimized for immediate business intelligence and operational monitoring.

## Overview

This project extends Fivetran's log data model by creating purpose-built analytics tables in the `fct_fivetran_logs` schema. Instead of querying complex raw log tables, users can directly access curated fact tables designed for common analytics use cases.

## Analytics Capabilities

### Performance Analytics
Monitor and optimize connector performance across your Fivetran infrastructure.

**Available Models:**
- `fct_fivetran_sync_performance` - Detailed metrics for every sync run including duration, rows synced, and status
- `fct_fivetran_connector_health` - Aggregated health metrics with 7-day success rates and failure counts
- `fct_fivetran_sync_performance_trends` - Historical performance trends to identify degradation patterns

### Usage Analytics
Track consumption metrics for cost management and capacity planning.

**Available Models:**
- `fct_fivetran_monthly_active_rows` - MAR breakdown by connection, schema, and table with free vs paid classification
- `fct_fivetran_monthly_credits` - Credit consumption by destination including transformation costs and estimated spend
- `fct_fivetran_daily_api_usage` - Daily API call volumes by connector for rate limit monitoring
- `fct_fivetran_executive_dashboard` - High-level KPIs for executive reporting

### Monitoring & Alerting
Identify and respond to operational issues proactively.

**Available Models:**
- `fct_fivetran_error_monitoring` - Comprehensive error tracking with categorization and frequency analysis
- `fct_fivetran_problematic_connectors` - Automated identification of underperforming or failing connectors

### Governance & Compliance
Maintain visibility into schema changes and user activity.

**Available Models:**
- `fct_fivetran_schema_change_history` - Complete audit trail of schema modifications across all connectors
- `fct_fivetran_user_activity` - User action logs for compliance and security monitoring

### Recommendations
Data-driven insights for optimization opportunities.

**Available Models:**
- `fct_fivetran_connector_recommendations` - Actionable recommendations for connector configuration and performance improvements

## Project Structure

```
models/
├── staging/          # Source data staging with minimal transformations
├── intermediate/     # Reusable business logic and aggregations
└── marts/           # Production-ready fact tables
    ├── performance/
    ├── usage/
    ├── monitoring/
    ├── governance/
    └── recommendations/
```

## Quick Start

### Prerequisites
- dbt Core 1.9.0 or higher
- Snowflake account with Fivetran log connector configured
- Python 3.8 or higher

### Installation

1. Clone the repository:
```bash
git clone <repo-url>
cd dbt-fivetran-logs
```

2. Configure Snowflake authentication:
```bash
cp .nao.env.example .nao.env
```

Edit `.nao.env` and add your Snowflake private key. See [PRIVATE_KEY_SETUP.md](PRIVATE_KEY_SETUP.md) for detailed instructions on generating and configuring private key authentication.

3. Update dbt profile:

Edit `profiles.yml` with your Snowflake account details:
```yaml
default:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: <your_account>
      user: <your_user>
      role: <your_role>
      database: <your_database>
      warehouse: <your_warehouse>
      schema: fct_fivetran_logs
      private_key_path: "{{ env_var('SNOWFLAKE_PRIVATE_KEY_PATH') }}"
      private_key_passphrase: "{{ env_var('SNOWFLAKE_PRIVATE_KEY_PASSPHRASE') }}"
```

4. Install dependencies and build models:
```bash
dbt deps
dbt build
```

## Usage

### Build All Models
```bash
dbt build
```

### Build Specific Analytics Area
```bash
dbt build --select tag:performance
dbt build --select tag:usage
dbt build --select tag:monitoring
dbt build --select tag:governance
```

### Build Individual Model
```bash
dbt build --select fct_fivetran_connector_health
```

### Run Tests
```bash
dbt test
```

## Integration with BI Tools

All fact tables in the `fct_fivetran_logs` schema are optimized for direct consumption by business intelligence tools:

- **Tableau / Power BI**: Connect directly to fact tables for dashboard creation
- **Looker**: Use models as explores for self-service analytics
- **Mode / Hex**: Query fact tables directly for ad-hoc analysis
- **Alerting Tools**: Set up monitors on error and performance metrics

## Data Freshness

Models are materialized as tables and should be refreshed on a schedule that matches your monitoring requirements:

- **Real-time monitoring**: Run every 15-30 minutes
- **Daily reporting**: Run once per day
- **Monthly cost analysis**: Run at month-end

Configure scheduling in your orchestration tool (Airflow, Prefect, dbt Cloud, etc.).

## Contributing

When adding new analytics models:

1. Place staging models in `models/staging/`
2. Create intermediate transformations in `models/intermediate/`
3. Build fact tables in the appropriate `models/marts/` subdirectory
4. Add comprehensive documentation in YAML files
5. Include data quality tests

## Support

For issues related to:
- **Fivetran log connector**: Contact Fivetran support
- **This dbt project**: Open an issue in this repository
- **dbt Core**: Refer to [dbt documentation](https://docs.getdbt.com/)

## License

[Add your license information here]
