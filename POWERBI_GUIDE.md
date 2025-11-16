# Power BI Dashboard Guide

Complete guide for building Power BI dashboards with your Fivetran Log analytics.

## 🎯 Quick Start

### Step 1: Connect Power BI to Snowflake

1. Open Power BI Desktop
2. Click **Get Data** → **Snowflake**
3. Enter your connection details:
   - **Server**: `YOUR_ACCOUNT.snowflakecomputing.com`
   - **Warehouse**: `YOUR_WAREHOUSE`
   - **Database**: `JASON_CHLETSOS` (or your database name)
4. Select **DirectQuery** mode for real-time data (or **Import** for faster performance)
5. Authenticate with your Snowflake credentials

### Step 2: Import the Fact Tables

Import these key tables from the `FIVETRAN_ANALYTICS` schema:

**Essential Tables:**
- `fct_fivetran_connector_health`
- `fct_fivetran_monthly_active_rows`
- `fct_fivetran_sync_performance`
- `fct_fivetran_error_monitoring`
- `fct_fivetran_schema_change_history`
- `fct_fivetran_user_activity`

**Optional Tables:**
- `fct_fivetran_daily_api_usage`
- `fct_fivetran_problematic_connectors`
- `fct_fivetran_executive_dashboard`

---

## 📊 Recommended Dashboards

### Dashboard 1: Executive Overview (1 page)

**Purpose**: High-level KPIs for leadership  
**Refresh**: Daily  
**Audience**: Executives, Data Platform Managers

#### KPIs (Card Visuals)
```dax
Total Connectors = DISTINCTCOUNT(fct_fivetran_connector_health[connection_id])

Healthy Connectors = 
CALCULATE(
    DISTINCTCOUNT(fct_fivetran_connector_health[connection_id]),
    fct_fivetran_connector_health[success_rate_last_7d] >= 0.95
)

Health Percentage = 
DIVIDE([Healthy Connectors], [Total Connectors], 0)

Total MAR This Month = 
CALCULATE(
    SUM(fct_fivetran_monthly_active_rows[total_active_rows]),
    fct_fivetran_monthly_active_rows[month_date] = EOMONTH(TODAY(), 0)
)

Active Syncs Today = 
CALCULATE(
    DISTINCTCOUNT(fct_fivetran_sync_performance[sync_id]),
    fct_fivetran_sync_performance[started_at] >= TODAY()
)
```

#### Visuals Layout
```
┌─────────────────────────────────────────────────────────────┐
│  FIVETRAN PLATFORM HEALTH DASHBOARD                         │
├─────────────┬─────────────┬─────────────┬─────────────────┤
│ Total       │ Healthy     │ Health      │ MAR This Month  │
│ Connectors  │ Connectors  │ Rate        │                 │
│    [42]     │    [38]     │   [90%]     │   [1.2M rows]   │
├─────────────┴─────────────┴─────────────┴─────────────────┤
│                                                             │
│  Connector Health Trend (Line Chart)                        │
│  - X-axis: Date                                             │
│  - Y-axis: Success Rate %                                   │
│  - Legend: Connection Name                                  │
│                                                             │
├──────────────────────────────┬──────────────────────────────┤
│                              │                              │
│  MAR by Connector (Bar)      │  Errors Last 7 Days (Table)  │
│  - Top 10 by volume          │  - Connection Name           │
│  - Paid vs Free split        │  - Error Count               │
│                              │  - Last Error                │
│                              │                              │
└──────────────────────────────┴──────────────────────────────┘
```

---

### Dashboard 2: Connector Health Monitoring (1 page)

**Purpose**: Detailed connector performance and troubleshooting  
**Refresh**: Hourly  
**Audience**: Data Engineers, DevOps

#### Key Measures
```dax
Avg Sync Duration (min) = 
AVERAGE(fct_fivetran_sync_performance[sync_duration_minutes])

Failed Syncs Last 7D = 
CALCULATE(
    COUNTROWS(fct_fivetran_sync_performance),
    fct_fivetran_sync_performance[sync_status] = 'FAILURE',
    fct_fivetran_sync_performance[started_at] >= TODAY() - 7
)

Success Rate = 
DIVIDE(
    CALCULATE(
        COUNTROWS(fct_fivetran_sync_performance),
        fct_fivetran_sync_performance[sync_status] = 'SUCCESS'
    ),
    COUNTROWS(fct_fivetran_sync_performance),
    0
)

Rows Synced Today = 
CALCULATE(
    SUM(fct_fivetran_sync_performance[rows_synced]),
    fct_fivetran_sync_performance[started_at] >= TODAY()
)
```

#### Visuals Layout
```
┌─────────────────────────────────────────────────────────────┐
│  CONNECTOR HEALTH MONITORING                                │
├─────────────┬─────────────┬─────────────┬─────────────────┤
│ Avg Sync    │ Failed      │ Success     │ Rows Synced     │
│ Duration    │ Syncs (7D)  │ Rate        │ Today           │
│  [12 min]   │    [5]      │   [98%]     │   [2.5M]        │
├─────────────┴─────────────┴─────────────┴─────────────────┤
│                                                             │
│  Sync Performance Over Time (Area Chart)                    │
│  - X-axis: Hour                                             │
│  - Y-axis: Sync Duration (minutes)                          │
│  - Legend: Connection Name                                  │
│  - Filter: Last 24 hours                                    │
│                                                             │
├──────────────────────────────┬──────────────────────────────┤
│                              │                              │
│  Connector Status (Matrix)   │  Recent Errors (Table)       │
│  - Rows: Connection Name     │  - Timestamp                 │
│  - Columns: Status           │  - Connection                │
│  - Values: Count             │  - Error Message             │
│  - Conditional formatting    │  - Severity                  │
│                              │                              │
└──────────────────────────────┴──────────────────────────────┘
```

---

### Dashboard 3: Cost & Usage Analytics (1 page)

**Purpose**: MAR tracking and cost optimization  
**Refresh**: Daily  
**Audience**: Finance, Data Platform Managers

#### Key Measures
```dax
Total MAR = SUM(fct_fivetran_monthly_active_rows[total_active_rows])

Paid MAR = SUM(fct_fivetran_monthly_active_rows[paid_active_rows])

Free MAR = SUM(fct_fivetran_monthly_active_rows[free_active_rows])

MAR Growth MoM = 
VAR CurrentMonth = [Total MAR]
VAR PreviousMonth = 
    CALCULATE(
        [Total MAR],
        DATEADD(fct_fivetran_monthly_active_rows[month_date], -1, MONTH)
    )
RETURN
    DIVIDE(CurrentMonth - PreviousMonth, PreviousMonth, 0)

Avg MAR per Connector = 
DIVIDE([Total MAR], DISTINCTCOUNT(fct_fivetran_monthly_active_rows[connection_name]))

Top MAR Consumer = 
TOPN(
    1,
    VALUES(fct_fivetran_monthly_active_rows[connection_name]),
    [Total MAR],
    DESC
)
```

#### Visuals Layout
```
┌─────────────────────────────────────────────────────────────┐
│  COST & USAGE ANALYTICS                                     │
├─────────────┬─────────────┬─────────────┬─────────────────┤
│ Total MAR   │ Paid MAR    │ Free MAR    │ MoM Growth      │
│  [1.2M]     │   [800K]    │   [400K]    │    [+12%]       │
├─────────────┴─────────────┴─────────────┴─────────────────┤
│                                                             │
│  MAR Trend (Line + Column Chart)                            │
│  - X-axis: Month                                            │
│  - Y-axis (left): MAR Volume                                │
│  - Y-axis (right): Growth %                                 │
│  - Series: Paid vs Free                                     │
│                                                             │
├──────────────────────────────┬──────────────────────────────┤
│                              │                              │
│  MAR by Connector (Treemap)  │  MAR by Schema (Table)       │
│  - Size: Total MAR           │  - Connection                │
│  - Color: Growth %           │  - Schema                    │
│  - Label: Connection Name    │  - Table                     │
│                              │  - MAR                       │
│                              │  - % of Total                │
└──────────────────────────────┴──────────────────────────────┘
```

---

### Dashboard 4: Schema Change Tracking (1 page)

**Purpose**: Monitor schema evolution and breaking changes  
**Refresh**: Hourly  
**Audience**: Data Engineers, Analytics Engineers

#### Key Measures
```dax
Total Changes Last 7D = 
CALCULATE(
    COUNTROWS(fct_fivetran_schema_change_history),
    fct_fivetran_schema_change_history[change_detected_at] >= TODAY() - 7
)

Breaking Changes = 
CALCULATE(
    COUNTROWS(fct_fivetran_schema_change_history),
    fct_fivetran_schema_change_history[change_type] IN {"DROP", "ALTER"}
)

Tables Affected = 
DISTINCTCOUNT(fct_fivetran_schema_change_history[table_name])

Most Active Connection = 
TOPN(
    1,
    VALUES(fct_fivetran_schema_change_history[connection_name]),
    [Total Changes Last 7D],
    DESC
)
```

#### Visuals Layout
```
┌─────────────────────────────────────────────────────────────┐
│  SCHEMA CHANGE TRACKING                                     │
├─────────────┬─────────────┬─────────────┬─────────────────┤
│ Changes     │ Breaking    │ Tables      │ Most Active     │
│ (Last 7D)   │ Changes     │ Affected    │ Connection      │
│    [23]     │    [3]      │    [12]     │  [Salesforce]   │
├─────────────┴─────────────┴─────────────┴─────────────────┤
│                                                             │
│  Change Timeline (Gantt/Timeline)                           │
│  - X-axis: Date/Time                                        │
│  - Y-axis: Connection Name                                  │
│  - Color: Change Type (ADD/DROP/ALTER)                      │
│  - Tooltip: Column name, old/new data type                  │
│                                                             │
├──────────────────────────────┬──────────────────────────────┤
│                              │                              │
│  Change Type Distribution    │  Recent Changes (Table)      │
│  (Donut Chart)               │  - Timestamp                 │
│  - ADD                       │  - Connection                │
│  - DROP                      │  - Table.Column              │
│  - ALTER                     │  - Change Type               │
│                              │  - Old → New Value           │
└──────────────────────────────┴──────────────────────────────┘
```

---

### Dashboard 5: Error Monitoring & Troubleshooting (1 page)

**Purpose**: Identify and resolve connector errors  
**Refresh**: Every 15 minutes  
**Audience**: Data Engineers, Support Team

#### Key Measures
```dax
Total Errors Last 7D = 
CALCULATE(
    COUNTROWS(fct_fivetran_error_monitoring),
    fct_fivetran_error_monitoring[logged_at] >= TODAY() - 7
)

Recurring Errors = 
CALCULATE(
    COUNTROWS(fct_fivetran_error_monitoring),
    fct_fivetran_error_monitoring[is_recurring_error] = TRUE
)

Error Rate = 
DIVIDE(
    [Total Errors Last 7D],
    CALCULATE(
        COUNTROWS(fct_fivetran_sync_performance),
        fct_fivetran_sync_performance[started_at] >= TODAY() - 7
    ),
    0
)

MTTR (Mean Time to Resolution) = 
AVERAGE(fct_fivetran_error_monitoring[resolution_time_hours])
```

#### Visuals Layout
```
┌─────────────────────────────────────────────────────────────┐
│  ERROR MONITORING & TROUBLESHOOTING                         │
├─────────────┬─────────────┬─────────────┬─────────────────┤
│ Total       │ Recurring   │ Error       │ MTTR            │
│ Errors (7D) │ Errors      │ Rate        │                 │
│    [45]     │    [12]     │   [2.3%]    │   [4.5 hrs]     │
├─────────────┴─────────────┴─────────────┴─────────────────┤
│                                                             │
│  Error Trend (Line Chart with Anomaly Detection)            │
│  - X-axis: Hour                                             │
│  - Y-axis: Error Count                                      │
│  - Threshold line: Expected range                           │
│  - Highlight: Anomalies                                     │
│                                                             │
├──────────────────────────────┬──────────────────────────────┤
│                              │                              │
│  Error Types (Bar Chart)     │  Active Errors (Table)       │
│  - Horizontal bars           │  - Connection                │
│  - Sorted by frequency       │  - Error Type                │
│  - Color by severity         │  - First Seen                │
│                              │  - Occurrences               │
│                              │  - Status                    │
└──────────────────────────────┴──────────────────────────────┘
```

---

## 🔗 Data Model & Relationships

### Recommended Relationships

```
fct_fivetran_connector_health
    ↓ connection_id (1:many)
fct_fivetran_sync_performance

fct_fivetran_connector_health
    ↓ connection_id (1:many)
fct_fivetran_monthly_active_rows

fct_fivetran_connector_health
    ↓ connection_id (1:many)
fct_fivetran_error_monitoring

fct_fivetran_connector_health
    ↓ connection_id (1:many)
fct_fivetran_schema_change_history
```

### Date Table (Create in Power BI)

```dax
DateTable = 
ADDCOLUMNS(
    CALENDAR(DATE(2020, 1, 1), TODAY()),
    "Year", YEAR([Date]),
    "Month", FORMAT([Date], "MMM"),
    "MonthNum", MONTH([Date]),
    "Quarter", "Q" & FORMAT([Date], "Q"),
    "WeekNum", WEEKNUM([Date]),
    "DayOfWeek", FORMAT([Date], "ddd"),
    "IsWeekend", IF(WEEKDAY([Date]) IN {1, 7}, TRUE, FALSE)
)
```

**Relationships:**
- `DateTable[Date]` → `fct_fivetran_sync_performance[started_at]` (many:1)
- `DateTable[Date]` → `fct_fivetran_error_monitoring[logged_at]` (many:1)
- `DateTable[Date]` → `fct_fivetran_schema_change_history[change_detected_at]` (many:1)

---

## 🎨 Formatting & Best Practices

### Color Palette (Fivetran Brand Colors)

```
Primary Blue:   #0073E6
Success Green:  #00C48C
Warning Orange: #FF9500
Error Red:      #FF3B30
Neutral Gray:   #8E8E93
Background:     #F2F2F7
```

### Conditional Formatting Rules

**Success Rate:**
- 🟢 Green: ≥ 95%
- 🟡 Yellow: 80-94%
- 🔴 Red: < 80%

**Sync Duration:**
- 🟢 Green: < 15 minutes
- 🟡 Yellow: 15-30 minutes
- 🔴 Red: > 30 minutes

**Error Count:**
- 🟢 Green: 0 errors
- 🟡 Yellow: 1-5 errors
- 🔴 Red: > 5 errors

### Visual Best Practices

1. **Use consistent date filters** across all pages
2. **Add drill-through pages** for detailed analysis
3. **Enable tooltips** with additional context
4. **Set up alerts** for critical metrics
5. **Use bookmarks** for different views (daily/weekly/monthly)
6. **Add slicers** for:
   - Connection Name
   - Connector Type
   - Destination
   - Date Range

---

## 📥 Pre-Built Queries for Power BI

### Query 1: Connector Health Summary (for main visual)

```sql
SELECT 
    ch.connection_name,
    ch.connector_name,
    ch.destination_name,
    ch.success_rate_last_7d,
    ch.failed_syncs_last_7d,
    ch.avg_sync_duration_minutes,
    ch.last_sync_status,
    ch.last_sync_completed_at,
    ch.days_since_last_success,
    CASE 
        WHEN ch.success_rate_last_7d >= 0.95 THEN 'Healthy'
        WHEN ch.success_rate_last_7d >= 0.80 THEN 'Warning'
        ELSE 'Critical'
    END as health_status
FROM fivetran_analytics.fct_fivetran_connector_health ch
ORDER BY ch.success_rate_last_7d;
```

### Query 2: MAR by Connection and Month

```sql
SELECT 
    mar.connection_name,
    mar.month_date,
    mar.total_active_rows,
    mar.paid_active_rows,
    mar.free_active_rows,
    mar.schema_count,
    mar.table_count,
    ROUND(mar.paid_active_rows * 100.0 / NULLIF(mar.total_active_rows, 0), 2) as paid_percentage
FROM fivetran_analytics.fct_fivetran_monthly_active_rows mar
WHERE mar.month_date >= DATEADD(month, -12, CURRENT_DATE())
ORDER BY mar.month_date DESC, mar.total_active_rows DESC;
```

### Query 3: Schema Changes with Details

```sql
SELECT 
    sch.change_detected_at,
    sch.connection_name,
    sch.schema_name,
    sch.table_name,
    sch.column_name,
    sch.change_type,
    sch.previous_data_type,
    sch.new_data_type,
    CASE 
        WHEN sch.change_type IN ('DROP', 'ALTER') THEN 'Breaking'
        ELSE 'Non-Breaking'
    END as impact_level
FROM fivetran_analytics.fct_fivetran_schema_change_history sch
WHERE sch.change_detected_at >= DATEADD(day, -30, CURRENT_DATE())
ORDER BY sch.change_detected_at DESC;
```

### Query 4: Error Summary with Recurrence

```sql
SELECT 
    err.connection_name,
    err.error_type,
    err.error_message,
    err.first_occurrence,
    err.last_occurrence,
    err.occurrence_count,
    err.is_recurring_error,
    DATEDIFF(hour, err.first_occurrence, err.last_occurrence) as duration_hours,
    CASE 
        WHEN err.occurrence_count >= 10 THEN 'High'
        WHEN err.occurrence_count >= 5 THEN 'Medium'
        ELSE 'Low'
    END as severity
FROM fivetran_analytics.fct_fivetran_error_monitoring err
WHERE err.last_occurrence >= DATEADD(day, -7, CURRENT_DATE())
ORDER BY err.occurrence_count DESC;
```

### Query 5: Sync Performance Metrics

```sql
SELECT 
    sp.connection_name,
    sp.sync_id,
    sp.started_at,
    sp.completed_at,
    sp.sync_duration_minutes,
    sp.rows_synced,
    sp.sync_status,
    sp.sync_type,
    ROUND(sp.rows_synced / NULLIF(sp.sync_duration_minutes, 0), 0) as rows_per_minute
FROM fivetran_analytics.fct_fivetran_sync_performance sp
WHERE sp.started_at >= DATEADD(day, -7, CURRENT_DATE())
ORDER BY sp.started_at DESC;
```

---

## 🚀 Quick Setup Checklist

- [ ] Connect Power BI to Snowflake
- [ ] Import fact tables from `FIVETRAN_ANALYTICS` schema
- [ ] Create Date table with DAX
- [ ] Set up relationships between tables
- [ ] Create calculated measures for KPIs
- [ ] Build Dashboard 1: Executive Overview
- [ ] Build Dashboard 2: Connector Health
- [ ] Build Dashboard 3: Cost & Usage
- [ ] Build Dashboard 4: Schema Changes
- [ ] Build Dashboard 5: Error Monitoring
- [ ] Apply conditional formatting
- [ ] Add slicers and filters
- [ ] Set up scheduled refresh
- [ ] Publish to Power BI Service
- [ ] Share with stakeholders

---

## 📚 Additional Resources

- **Power BI Documentation**: https://docs.microsoft.com/power-bi/
- **Snowflake Connector Guide**: https://docs.microsoft.com/power-bi/connect-data/service-connect-snowflake
- **DAX Reference**: https://dax.guide/
- **MODEL_REFERENCE.md** - Complete model documentation

---

**Pro Tips:**
1. Use **DirectQuery** for real-time dashboards, **Import** for better performance
2. Create a **separate workspace** in Power BI Service for production dashboards
3. Set up **data alerts** on critical metrics (e.g., error count, success rate)
4. Use **Row-Level Security (RLS)** if sharing with multiple teams
5. Schedule **automatic refresh** during off-peak hours

---

**Last Updated**: November 2024  
**Power BI Version**: Desktop & Service  
**Snowflake Connector**: Native connector recommended
