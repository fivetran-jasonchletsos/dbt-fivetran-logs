# dbt-fivetran-logs - Project Summary

## 📋 Project Overview

This dbt project analyzes Fivetran log data to provide comprehensive insights into connector health, usage patterns, performance metrics, and governance. It transforms raw Fivetran metadata into actionable analytics for data platform teams.

## 🎯 What This Project Analyzes

### 1. **Connector Health & Monitoring**
- Real-time health scores for all Fivetran connectors
- Success rates and failure patterns
- Sync frequency and duration analysis
- Identification of problematic connectors requiring attention

### 2. **Usage & Billing Optimization**
- Monthly Active Rows (MAR) tracking by connector, schema, and table
- Free vs. paid MAR breakdown
- Usage trends over time
- Cost optimization opportunities

### 3. **Performance Analytics**
- Sync duration trends and anomalies
- API call patterns and rate limiting
- Rows synced per connector
- Performance benchmarking across connectors

### 4. **Error & Issue Management**
- Error classification and frequency analysis
- Recurring error detection
- Root cause identification
- Error impact assessment

### 5. **Schema Change Tracking**
- Column-level change detection (adds, drops, type changes)
- Table and schema evolution history
- Change impact analysis
- Lineage tracking (source → destination)

### 6. **Governance & Audit**
- User activity tracking
- Access control monitoring
- Configuration change history
- Compliance reporting

### 7. **Optimization Recommendations**
- Connector-specific improvement suggestions
- Priority-based action items
- Best practice compliance checks
- Resource optimization opportunities

## 📊 Key Analytics Models

### Executive Dashboard (`fct_fivetran_executive_dashboard`)
High-level KPIs for leadership:
- Total connectors and health percentage
- Total active rows (free vs. paid)
- Error counts and trends
- Overall platform health score

### Connector Health (`fct_fivetran_connector_health`)
Detailed health metrics per connector:
- Last sync status and timestamp
- 7-day success rate
- Average sync duration
- Failed sync counts

### Monthly Active Rows (`fct_fivetran_monthly_active_rows`)
Billing and usage insights:
- MAR by connector, schema, and table
- Month-over-month trends
- Free vs. paid breakdown
- Top consumers identification

### Sync Performance (`fct_fivetran_sync_performance`)
Performance deep-dive:
- Individual sync metrics
- Duration analysis
- Rows synced tracking
- Performance trends

### Error Monitoring (`fct_fivetran_error_monitoring`)
Error tracking and analysis:
- Error type classification
- Recurring error detection
- Error frequency and patterns
- Affected connectors

### Problematic Connectors (`fct_fivetran_problematic_connectors`)
Proactive issue identification:
- Problem severity scoring
- Error rate calculations
- Actionable recommendations
- Priority ranking

### Schema Change History (`fct_fivetran_schema_change_history`)
Schema evolution tracking:
- Column-level changes
- Data type modifications
- Change timestamps
- Impact assessment

### User Activity (`fct_fivetran_user_activity`)
Governance and audit:
- User action tracking
- Resource access patterns
- Configuration changes
- Compliance monitoring

### Connector Recommendations (`fct_fivetran_connector_recommendations`)
Optimization guidance:
- Performance improvement suggestions
- Configuration optimization
- Best practice recommendations
- Priority-based action items

## 📁 Analysis Queries Included

The `analyses/` folder contains ready-to-use SQL queries:

### `fivetran_analytics_queries.sql` (7.5 KB)
Comprehensive query library covering:
1. Executive dashboard queries
2. Connector health analysis
3. Monthly Active Rows (MAR) analysis
4. Sync performance deep-dives
5. Error monitoring and trending
6. Problematic connector identification
7. API usage analysis
8. Schema change tracking
9. User activity auditing
10. Optimization recommendations

### `fivetran_data_check.sql` (7.3 KB)
Diagnostic queries for troubleshooting:
1. Source data validation
2. Staging view checks
3. Intermediate view verification
4. Sync performance data checks
5. Connector health component analysis
6. Monthly Active Rows validation
7. Log data error checks
8. Schema change event verification
9. User activity validation
10. Date range diagnostics

### `table_row_counts.sql` (4.1 KB)
Data volume analysis:
- Row counts for all source tables
- Staging view row counts
- Intermediate view row counts
- Fact table row counts
- Data freshness checks

## 🏗️ Architecture Compliance

This project **fully complies** with the [Fivetran Log ERD](https://fivetran.com/connector-erd/fivetran_log):

### ✅ Core Tables
- `account` - Account information
- `connection` - Connection configurations
- `connector_type` - Connector metadata
- `destination` - Destination configurations
- `log` - Event logs
- `user` - User information

### ✅ Usage & Billing
- `incremental_mar` - Monthly Active Rows tracking

### ✅ Transformations
- `transformation_runs` - dbt transformation metrics

### ✅ Schema Metadata
- `source_schema`, `source_table`, `source_column`
- `destination_schema`, `destination_table`, `destination_column`
- `source_foreign_key` - Relationship tracking

### ✅ Change Events
- `source_schema_change_event`
- `source_table_change_event`
- `source_column_change_event`
- `destination_schema_change_event`
- `destination_table_change_event`
- `destination_column_change_event`

### ✅ Lineage
- `schema_lineage` - Schema-level lineage
- `table_lineage` - Table-level lineage
- `column_lineage` - Column-level lineage

### ✅ Access Control
- `team` - Team management
- `team_membership` - User-team relationships
- `role` - Role definitions
- `role_permission` - Permission assignments
- `role_connector_type` - Connector access control
- `resource_membership` - Resource access

### ✅ Audit & Monitoring
- `audit_trail` - User activity audit
- `connector_sdk_log` - Custom connector logs

## 🔑 Key Features Implemented

### 1. **Environment Variable Configuration**
- ✅ Private key stored in `.nao.env` (not in code)
- ✅ Secure authentication via Snowflake key pairs
- ✅ CI/CD ready configuration
- ✅ Version control safe (`.gitignore` configured)

### 2. **Comprehensive Documentation**
- ✅ Main README with project overview
- ✅ SETUP_GUIDE.md for step-by-step setup
- ✅ PRIVATE_KEY_SETUP.md for authentication
- ✅ PROJECT_SUMMARY.md (this file)
- ✅ Inline code documentation

### 3. **Data Quality**
- ✅ dbt tests on key columns
- ✅ Not null and unique constraints
- ✅ Referential integrity checks
- ✅ Data freshness monitoring

### 4. **Modular Design**
- ✅ Staging layer for data standardization
- ✅ Intermediate layer for business logic
- ✅ Marts layer for analytics
- ✅ Reusable components

### 5. **Performance Optimized**
- ✅ Views for staging (no storage cost)
- ✅ Tables for marts (query performance)
- ✅ Appropriate materialization strategies
- ✅ Efficient joins and aggregations

## 🚀 Quick Start

```bash
# 1. Clone and setup
git clone <repo-url>
cd dbt-fivetran-logs

# 2. Configure private key
cp .nao.env.example .nao.env
# Edit .nao.env and add your private key

# 3. Update connection details
# Edit .dbt/profiles.yml with your Snowflake info

# 4. Test connection
dbt debug

# 5. Build everything
dbt build

# 6. Run sample queries
# Open analyses/fivetran_analytics_queries.sql
```

## 📈 Sample Insights You Can Get

### "Which connectors are unhealthy?"
```sql
SELECT connection_name, connector_name, success_rate_last_7d
FROM fivetran_analytics.fct_fivetran_connector_health
WHERE success_rate_last_7d < 0.95
ORDER BY success_rate_last_7d;
```

### "What's driving my MAR costs?"
```sql
SELECT connection_name, schema_name, table_name, 
       SUM(paid_active_rows) as paid_rows
FROM fivetran_analytics.fct_fivetran_monthly_active_rows
WHERE month_date = DATE_TRUNC('month', CURRENT_DATE())
GROUP BY 1, 2, 3
ORDER BY 4 DESC
LIMIT 20;
```

### "What errors are recurring?"
```sql
SELECT error_type, COUNT(*) as occurrences,
       COUNT(DISTINCT connection_name) as affected_connectors
FROM fivetran_analytics.fct_fivetran_error_monitoring
WHERE is_recurring_error = TRUE
GROUP BY 1
ORDER BY 2 DESC;
```

### "What schema changes happened recently?"
```sql
SELECT change_detected_at, connection_name, 
       schema_name, table_name, column_name,
       change_type, previous_data_type, new_data_type
FROM fivetran_analytics.fct_fivetran_schema_change_history
WHERE change_detected_at >= DATEADD(day, -7, CURRENT_DATE())
ORDER BY change_detected_at DESC;
```

## 🎓 Use Cases

### For Data Engineers
- Monitor connector health and performance
- Troubleshoot sync failures proactively
- Optimize sync schedules
- Track schema changes and lineage

### For Data Platform Teams
- Understand platform usage patterns
- Optimize costs through MAR analysis
- Ensure data quality and freshness
- Plan capacity and resources

### For Analytics Leaders
- Executive dashboard for platform health
- ROI analysis for data pipelines
- Governance and compliance reporting
- Strategic planning insights

### For Finance/Operations
- MAR cost tracking and forecasting
- Usage-based billing analysis
- Budget optimization opportunities
- Chargeback reporting

## 🔒 Security Features

- ✅ Private key authentication (more secure than passwords)
- ✅ Environment variables for secrets
- ✅ `.gitignore` configured for sensitive files
- ✅ No hardcoded credentials
- ✅ Role-based access control support

## 📚 Additional Resources

- [Fivetran Log Connector Documentation](https://fivetran.com/docs/logs/fivetran-log)
- [Fivetran Log ERD](https://fivetran.com/connector-erd/fivetran_log)
- [dbt Documentation](https://docs.getdbt.com/)
- [Snowflake Key Pair Authentication](https://docs.snowflake.com/en/user-guide/key-pair-auth)

## 🤝 Support

For questions or issues:
- Check [SETUP_GUIDE.md](SETUP_GUIDE.md) for setup help
- Review [PRIVATE_KEY_SETUP.md](PRIVATE_KEY_SETUP.md) for authentication
- Contact: jason.chletsos@fivetran.com

---

**Built with ❤️ using dbt, Snowflake, and Fivetran**
