# Fivetran Analytics dbt Project - Documentation Summary

## Overview

This document provides a comprehensive summary of the Fivetran Analytics dbt project setup and configuration. All documentation has been updated to use professional language with UPPERCASE naming conventions for Snowflake database objects.

---

## Project Status

**Date**: November 16, 2025  
**dbt Version**: 1.9.0  
**Database**: Snowflake  
**Total Models**: 47 (36 views + 11 tables)  
**Build Status**: All models successfully built and tested  
**Build Time**: Approximately 12 seconds

---

## Database Configuration

### Naming Convention
All database objects use UPPERCASE naming as per Snowflake standards:
- **Schema**: `FIVETRAN_ANALYTICS_FCT_FIVETRAN_LOGS`
- **Tables**: `FCT_FIVETRAN_CONNECTOR_HEALTH`, `FCT_FIVETRAN_SYNC_PERFORMANCE`, etc.
- **Columns**: `CONNECTION_NAME`, `SYNC_STATUS`, `TOTAL_ACTIVE_ROWS`, etc.

### Schema Structure
The project creates three schemas:
1. **FIVETRAN_ANALYTICS_STG_FIVETRAN_LOG** - 32 staging views
2. **FIVETRAN_ANALYTICS_INT_FIVETRAN_LOG** - 4 intermediate views
3. **FIVETRAN_ANALYTICS_FCT_FIVETRAN_LOGS** - 11 fact tables

---

## Fact Tables

### 1. FCT_FIVETRAN_CONNECTOR_HEALTH (76 rows)
**Purpose**: Health metrics for all Fivetran connectors  
**Key Metrics**:
- Success rates (last 7 days)
- Total sync counts
- Average sync duration
- Last sync timestamps

### 2. FCT_FIVETRAN_SYNC_PERFORMANCE (145 rows)
**Purpose**: Individual sync performance records  
**Key Metrics**:
- Sync duration
- Sync status (SUCCESS/FAILURE)
- Rows synced per operation
- Sync start and end times

### 3. FCT_FIVETRAN_MONTHLY_ACTIVE_ROWS (1,299,780 rows)
**Purpose**: Monthly Active Rows (MAR) tracking  
**Key Metrics**:
- Total active rows
- Paid vs free rows breakdown
- Month-over-month trends
- Connector-level MAR

### 4. FCT_FIVETRAN_ERROR_MONITORING (1 row)
**Purpose**: Error tracking and categorization  
**Key Metrics**:
- Error types and messages
- Error timestamps
- Recurring error flags
- Resolution time tracking

### 5. FCT_FIVETRAN_SCHEMA_CHANGE_HISTORY (0 rows)
**Purpose**: Schema change tracking  
**Key Metrics**:
- Change types (ADD, DROP, ALTER)
- Affected tables and columns
- Change timestamps
- Impact assessment

### 6. FCT_FIVETRAN_CONNECTOR_RECOMMENDATIONS (76 rows)
**Purpose**: Optimization recommendations  
**Key Metrics**:
- Health scores
- Recommended actions
- Priority levels
- Implementation guidance

### 7. FCT_FIVETRAN_PROBLEMATIC_CONNECTORS (76 rows)
**Purpose**: Connectors with issues  
**Key Metrics**:
- Failure patterns
- Error frequency
- Performance degradation
- Risk assessment

### 8. FCT_FIVETRAN_SYNC_PERFORMANCE_TRENDS (98 rows)
**Purpose**: Performance trends over time  
**Key Metrics**:
- Moving averages
- Period-over-period comparisons
- Trend indicators
- Anomaly detection

### 9. FCT_FIVETRAN_EXECUTIVE_DASHBOARD (1 row)
**Purpose**: High-level summary metrics  
**Key Metrics**:
- Total connectors
- Overall health percentage
- Total MAR
- Critical issues count

### 10. FCT_FIVETRAN_DAILY_API_USAGE (0 rows)
**Purpose**: API call tracking  
**Key Metrics**:
- API calls by endpoint
- Usage by user
- Rate limit monitoring
- Cost attribution

### 11. FCT_FIVETRAN_USER_ACTIVITY (0 rows)
**Purpose**: User action tracking  
**Key Metrics**:
- User actions and events
- Administrative changes
- Audit trail
- Governance compliance

---

## Power BI Integration

### Connection Details
**Server**: `your_account.snowflakecomputing.com`  
**Database**: `JASON_CHLETSOS` (or your database name)  
**Schema**: `FIVETRAN_ANALYTICS_FCT_FIVETRAN_LOGS`  
**Authentication**: Snowflake credentials or Microsoft Account (SSO)

### Required Tables for Power BI
The following five tables are recommended for initial Power BI setup:
1. `FCT_FIVETRAN_CONNECTOR_HEALTH`
2. `FCT_FIVETRAN_SYNC_PERFORMANCE`
3. `FCT_FIVETRAN_MONTHLY_ACTIVE_ROWS`
4. `FCT_FIVETRAN_ERROR_MONITORING`
5. `FCT_FIVETRAN_SCHEMA_CHANGE_HISTORY`

### Data Relationships
**Primary Key**: `CONNECTION_NAME` (used across all fact tables)  
**Date Dimension**: Create a separate DateTable for time-based analysis  
**Cardinality**: One-to-Many from dimension to fact tables

---

## Documentation Files

### Core Documentation
1. **SETUP_COMPLETE.md** - Complete setup summary and verification
2. **DOCUMENTATION_SUMMARY.md** - This file, professional overview
3. **README.md** - Project introduction and getting started

### Power BI Documentation
1. **powerbi/QUICK_START.md** - 30-minute quick start guide
2. **POWERBI_GUIDE.md** - Complete dashboard templates
3. **powerbi/METRICS_CATALOG.md** - All 60+ DAX measures with descriptions
4. **powerbi/fivetran_measures.dax** - Ready-to-import DAX measures
5. **powerbi/INDEX.md** - Documentation index

### Technical Documentation
1. **dbt_project.yml** - dbt project configuration
2. **models/** - SQL model definitions
3. **tests/** - Data quality tests

---

## Key Features

### Data Quality
- All models include data quality tests
- Primary key uniqueness validation
- Not-null constraints on critical fields
- Referential integrity checks

### Performance Optimization
- Fact tables materialized as tables (not views)
- Staging and intermediate layers as views
- Optimized for Snowflake compute
- Incremental model support where applicable

### Governance
- Comprehensive documentation for all models
- Column-level descriptions
- Data lineage tracking
- Audit trail capabilities

---

## DAX Measures

The project includes 60+ pre-built DAX measures across 7 categories:

### 1. Connector Health Metrics
- Total Connectors
- Healthy Connectors
- Health Percentage
- Connectors at Risk

### 2. Sync Performance Metrics
- Average/Median/P95 Sync Duration
- Total/Successful/Failed Syncs
- Success Rate
- Rows Synced
- Rows Per Minute

### 3. Cost and Usage Metrics
- Total/Paid/Free MAR
- MAR Growth (MoM, YoY)
- Average MAR per Connector
- Estimated Monthly Cost

### 4. Error and Quality Metrics
- Total/Recurring Errors
- Error Rate
- Unique Error Types
- Connectors with Errors
- Mean Time to Resolution (MTTR)

### 5. Schema Change Metrics
- Total Schema Changes
- Breaking/Non-Breaking Changes
- Tables Affected
- Connections with Changes

### 6. User Activity Metrics
- Total User Actions
- Active Users
- Admin Actions
- High-Risk Actions

### 7. Time Intelligence Measures
- Last 7/30 Days metrics
- Yesterday vs Today comparisons
- Period-over-period analysis

---

## Sample SQL Queries

### Check Table Row Counts
```sql
SELECT 
    'FCT_FIVETRAN_CONNECTOR_HEALTH' AS TABLE_NAME,
    COUNT(*) AS ROW_COUNT
FROM FIVETRAN_ANALYTICS_FCT_FIVETRAN_LOGS.FCT_FIVETRAN_CONNECTOR_HEALTH

UNION ALL

SELECT 
    'FCT_FIVETRAN_SYNC_PERFORMANCE',
    COUNT(*)
FROM FIVETRAN_ANALYTICS_FCT_FIVETRAN_LOGS.FCT_FIVETRAN_SYNC_PERFORMANCE

UNION ALL

SELECT 
    'FCT_FIVETRAN_MONTHLY_ACTIVE_ROWS',
    COUNT(*)
FROM FIVETRAN_ANALYTICS_FCT_FIVETRAN_LOGS.FCT_FIVETRAN_MONTHLY_ACTIVE_ROWS;
```

### Preview Connector Health
```sql
SELECT 
    CONNECTION_NAME,
    CONNECTOR_NAME,
    LAST_SYNC_AT,
    SUCCESS_RATE_LAST_7D,
    TOTAL_SYNCS,
    SUCCESSFUL_SYNCS,
    FAILED_SYNCS
FROM FIVETRAN_ANALYTICS_FCT_FIVETRAN_LOGS.FCT_FIVETRAN_CONNECTOR_HEALTH
ORDER BY SUCCESS_RATE_LAST_7D ASC
LIMIT 10;
```

### Check Recent Errors
```sql
SELECT 
    CONNECTION_NAME,
    ERROR_TYPE,
    ERROR_TIMESTAMP,
    ERROR_MESSAGE
FROM FIVETRAN_ANALYTICS_FCT_FIVETRAN_LOGS.FCT_FIVETRAN_ERROR_MONITORING
ORDER BY ERROR_TIMESTAMP DESC
LIMIT 10;
```

---

## Implementation Steps

### 1. dbt Setup (Completed)
- Installed dbt dependencies
- Configured profiles.yml
- Updated dbt_project.yml with schema names
- Ran all 47 models successfully

### 2. Power BI Setup (Next Steps)
- Connect Power BI Desktop to Snowflake
- Import the 5 core fact tables
- Create DateTable dimension
- Establish table relationships
- Import DAX measures from fivetran_measures.dax
- Build dashboard visualizations

### 3. Ongoing Maintenance
- Schedule dbt runs (daily recommended)
- Monitor data quality tests
- Update documentation as models evolve
- Refresh Power BI datasets regularly

---

## Troubleshooting

### Common Issues and Solutions

#### Tables Not Found
**Issue**: Cannot find tables in Snowflake  
**Solution**:
- Verify schema name is `FIVETRAN_ANALYTICS_FCT_FIVETRAN_LOGS` (UPPERCASE)
- Check user has SELECT permissions
- Ensure dbt models ran successfully
- Confirm you're in the correct database

#### Column Names Don't Match
**Issue**: Column references fail in queries  
**Solution**:
- All column names are UPPERCASE in Snowflake
- Reference as `CONNECTION_NAME` not `connection_name`
- Or rename in Power BI Power Query Editor to lowercase

#### Performance Issues
**Issue**: Queries or dashboards are slow  
**Solution**:
- Tables are materialized for better performance
- Consider adding indexes on frequently filtered columns
- Use DirectQuery in Power BI for real-time data
- Use Import mode for faster dashboard performance
- Aggregate large tables before importing to Power BI

#### DAX Measures Not Working
**Issue**: Measures return errors or unexpected results  
**Solution**:
- Verify table and column names match your schema
- Check for division by zero errors
- Ensure relationships are properly configured
- Test with different filter contexts
- Validate date columns are properly formatted

---

## Best Practices

### dbt Development
1. Always run `dbt test` after model changes
2. Document all new models and columns
3. Use consistent naming conventions
4. Implement incremental models for large tables
5. Tag models appropriately for selective runs

### Power BI Development
1. Import only necessary columns to reduce data model size
2. Use variables in complex DAX calculations
3. Avoid nested CALCULATE when possible
4. Create a separate DateTable for time intelligence
5. Implement Row-Level Security if needed

### Data Governance
1. Document all business logic in model descriptions
2. Maintain data lineage documentation
3. Implement appropriate access controls
4. Monitor data quality metrics regularly
5. Keep stakeholders informed of schema changes

---

## Support and Contact

**Technical Contact**: jason.chletsos@fivetran.com  
**Documentation Location**: `/Users/jason.chletsos/Documents/GitHub/dbt-fivetran-logs`  
**Repository**: dbt-fivetran-logs

### Additional Resources
- dbt Documentation: Run `dbt docs generate` and `dbt docs serve`
- Power BI Quick Start: See `powerbi/QUICK_START.md`
- Complete Guide: See `POWERBI_GUIDE.md`
- Metrics Reference: See `powerbi/METRICS_CATALOG.md`

---

## Version History

**Version 1.0** - November 16, 2025
- Initial setup complete
- All 47 models built and tested
- Documentation updated to professional standards
- UPPERCASE naming convention implemented
- Power BI integration guides created
- 60+ DAX measures documented

---

## Appendix: Column Reference

### FCT_FIVETRAN_CONNECTOR_HEALTH
- CONNECTION_NAME
- CONNECTOR_NAME
- DESTINATION_NAME
- LAST_SYNC_AT
- LAST_SUCCESSFUL_SYNC_AT
- LAST_ERROR_SYNC_AT
- LAST_SYNC_STATUS
- TOTAL_SYNCS
- SUCCESSFUL_SYNCS
- FAILED_SYNCS
- AVG_SYNC_DURATION_SECONDS
- MAX_SYNC_DURATION_SECONDS
- TOTAL_SYNCS_LAST_7D
- SUCCESSFUL_SYNCS_LAST_7D
- FAILED_SYNCS_LAST_7D
- SUCCESS_RATE_LAST_7D

### FCT_FIVETRAN_SYNC_PERFORMANCE
- CONNECTION_NAME
- SYNC_ID
- SYNC_START_TIME
- SYNC_END_TIME
- SYNC_DURATION_MINUTES
- SYNC_STATUS
- ROWS_SYNCED
- ROWS_UPDATED
- ROWS_DELETED
- MESSAGE_TEXT

### FCT_FIVETRAN_MONTHLY_ACTIVE_ROWS
- CONNECTION_NAME
- CONNECTOR_NAME
- DESTINATION_NAME
- MEASURED_MONTH
- TOTAL_ACTIVE_ROWS
- PAID_ACTIVE_ROWS
- FREE_ACTIVE_ROWS
- SCHEMA_NAME
- TABLE_NAME

---

**Document Last Updated**: November 16, 2025  
**Prepared By**: Jason Chletsos  
**Status**: Production Ready
