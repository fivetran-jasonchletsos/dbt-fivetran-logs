# Setup Complete - Fivetran Analytics dbt Project

**Date**: November 16, 2025  
**Status**: All models successfully built  
**Total Models**: 47 (36 views + 11 tables)

---

## Database Objects Created

### Schema: `FIVETRAN_ANALYTICS_FCT_FIVETRAN_LOGS`

All objects use **UPPERCASE naming** (Snowflake standard):

#### Fact Tables (11 tables)
1. **FCT_FIVETRAN_CONNECTOR_HEALTH** - 76 rows
   - Health metrics for all connectors
   - Success rates, sync counts, duration stats

2. **FCT_FIVETRAN_SYNC_PERFORMANCE** - 145 rows
   - Individual sync performance records
   - Duration, status, rows synced

3. **FCT_FIVETRAN_MONTHLY_ACTIVE_ROWS** - 1,299,780 rows
   - MAR tracking by connector and month
   - Free vs paid rows breakdown

4. **FCT_FIVETRAN_ERROR_MONITORING** - 1 row
   - Error tracking and categorization
   - Error types, timestamps, messages

5. **FCT_FIVETRAN_SCHEMA_CHANGE_HISTORY** - 0 rows
   - Schema change tracking
   - Column/table changes over time

6. **FCT_FIVETRAN_CONNECTOR_RECOMMENDATIONS** - 76 rows
   - Optimization recommendations
   - Health scores and action items

7. **FCT_FIVETRAN_PROBLEMATIC_CONNECTORS** - 76 rows
   - Connectors with issues
   - Failure patterns and trends

8. **FCT_FIVETRAN_SYNC_PERFORMANCE_TRENDS** - 98 rows
   - Performance trends over time
   - Moving averages and comparisons

9. **FCT_FIVETRAN_EXECUTIVE_DASHBOARD** - 1 row
   - High-level summary metrics
   - KPIs for leadership

10. **FCT_FIVETRAN_DAILY_API_USAGE** - 0 rows
    - API call tracking
    - Usage by endpoint and user

11. **FCT_FIVETRAN_USER_ACTIVITY** - 0 rows
    - User action tracking
    - Audit trail for governance

#### Supporting Schemas
- **FIVETRAN_ANALYTICS_STG_FIVETRAN_LOG** - 32 staging views
- **FIVETRAN_ANALYTICS_INT_FIVETRAN_LOG** - 4 intermediate views

---

## Power BI Connection Details

### Connection String
```
Server: YOUR_ACCOUNT.snowflakecomputing.com
Warehouse: YOUR_WAREHOUSE
Database: JASON_CHLETSOS (or your database name)
Schema: FIVETRAN_ANALYTICS_FCT_FIVETRAN_LOGS
```

### Tables to Import
All table names are **UPPERCASE**:
- `FCT_FIVETRAN_CONNECTOR_HEALTH`
- `FCT_FIVETRAN_SYNC_PERFORMANCE`
- `FCT_FIVETRAN_MONTHLY_ACTIVE_ROWS`
- `FCT_FIVETRAN_ERROR_MONITORING`
- `FCT_FIVETRAN_SCHEMA_CHANGE_HISTORY`

### Column Names
All column names are **UPPERCASE** (Snowflake standard):
- `CONNECTION_NAME`
- `CONNECTOR_NAME`
- `DESTINATION_NAME`
- `LAST_SYNC_AT`
- `SUCCESS_RATE_LAST_7D`
- etc.

**Note**: You can rename tables and columns to lowercase in Power BI Power Query Editor if preferred.

---

## Project Structure

```
dbt-fivetran-logs/
├── models/
│   ├── staging/              # 32 staging views
│   │   └── stg_fivetran_log__*.sql
│   ├── intermediate/         # 4 intermediate views
│   │   └── int_fivetran_log__*.sql
│   └── marts/               # 11 fact tables
│       ├── usage/
│       ├── performance/
│       ├── monitoring/
│       └── governance/
├── powerbi/
│   ├── QUICK_START.md       # 30-minute setup guide
│   ├── POWERBI_GUIDE.md     # Complete dashboard templates
│   ├── METRICS_CATALOG.md   # All DAX measures
│   └── fivetran_measures.dax # Ready-to-import measures
└── dbt_project.yml          # Project configuration
```

---

## Key Configuration

### dbt_project.yml
```yaml
models:
  dbt_fivetran_logs:
    staging:
      +materialized: view
      +schema: stg_fivetran_log
    
    intermediate:
      +materialized: view
      +schema: int_fivetran_log
    
    marts:
      +materialized: table
      +schema: fct_fivetran_logs
```

**Result**: All models use standard Snowflake UPPERCASE naming (no quoting)

---

## Next Steps

### 1. Connect Power BI (30 minutes)
Follow the guide: `powerbi/QUICK_START.md`

**Quick Steps**:
1. Open Power BI Desktop
2. Connect to Snowflake
3. Navigate to `FIVETRAN_ANALYTICS_FCT_FIVETRAN_LOGS` schema
4. Select the 5 main tables (all UPPERCASE)
5. Load or transform data
6. Create relationships
7. Import DAX measures
8. Build your first dashboard

### 2. Customize in Power BI
- Rename tables/columns to lowercase if preferred (in Power Query Editor)
- Apply your company's branding colors
- Add custom measures and calculations
- Create additional dashboard pages

### 3. Schedule Refresh
- Publish to Power BI Service
- Set up scheduled refresh (daily recommended)
- Configure data source credentials

### 4. Share with Team
- Create workspaces in Power BI Service
- Share dashboards with stakeholders
- Set up data alerts on key metrics

---

## Documentation

### Power BI Guides
- **[QUICK_START.md](powerbi/QUICK_START.md)** - Get started in 30 minutes
- **[POWERBI_GUIDE.md](POWERBI_GUIDE.md)** - Complete dashboard templates
- **[METRICS_CATALOG.md](powerbi/METRICS_CATALOG.md)** - All 60+ DAX measures

### dbt Documentation
- Run `dbt docs generate` to create interactive documentation
- Run `dbt docs serve` to view in browser

---

## Verification Checklist

- [x] All 47 dbt models built successfully
- [x] Schema `FIVETRAN_ANALYTICS_FCT_FIVETRAN_LOGS` created
- [x] 11 fact tables populated with data
- [x] All tables use UPPERCASE naming (Snowflake standard)
- [x] Power BI documentation updated
- [x] Connection details documented
- [x] Quick start guide ready

---

## Sample Queries

### Check Table Row Counts
```sql
SELECT 
    'FCT_FIVETRAN_CONNECTOR_HEALTH' as table_name,
    COUNT(*) as row_count
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

## Troubleshooting

### Tables Not Found
- Verify schema name is `FIVETRAN_ANALYTICS_FCT_FIVETRAN_LOGS` (UPPERCASE)
- Check you have SELECT permissions
- Ensure dbt models ran successfully

### Column Names Don't Match
- All column names are UPPERCASE in Snowflake
- Reference columns as `CONNECTION_NAME` not `connection_name`
- Or rename in Power BI Power Query Editor

### Performance Issues
- Tables are materialized (not views) for better performance
- Consider adding indexes if needed
- Use DirectQuery in Power BI for real-time data
- Use Import mode for faster dashboard performance

---

## Support

**Contact**: jason.chletsos@fivetran.com  
**Documentation**: See `powerbi/` folder for all guides  
**GitHub**: Open an issue in the repository

---

## Summary

Your Fivetran analytics dbt project is fully configured and ready for Power BI!

**Build Time**: ~12 seconds  
**Total Models**: 47  
**Status**: Production Ready

**Next**: Open `powerbi/QUICK_START.md` and build your first dashboard in 30 minutes!
