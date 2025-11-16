# Metrics Catalog

Complete catalog of all metrics, KPIs, and calculations for Power BI dashboards.

## 📊 Core KPIs

### Connector Health Metrics

#### Total Connectors
```dax
Total Connectors = DISTINCTCOUNT(fct_fivetran_connector_health[connection_id])
```
**Description**: Total number of active Fivetran connectors  
**Use Case**: Executive dashboard, capacity planning  
**Target**: N/A (informational)

#### Healthy Connectors
```dax
Healthy Connectors = 
CALCULATE(
    DISTINCTCOUNT(fct_fivetran_connector_health[connection_id]),
    fct_fivetran_connector_health[success_rate_last_7d] >= 0.95
)
```
**Description**: Connectors with ≥95% success rate in last 7 days  
**Use Case**: Platform health monitoring  
**Target**: ≥90% of total connectors

#### Health Percentage
```dax
Health Percentage = 
DIVIDE([Healthy Connectors], [Total Connectors], 0)
```
**Description**: Percentage of healthy connectors  
**Use Case**: Executive KPI, SLA tracking  
**Target**: ≥90%  
**Format**: Percentage (0.95 = 95%)

#### Connectors at Risk
```dax
Connectors at Risk = 
CALCULATE(
    DISTINCTCOUNT(fct_fivetran_connector_health[connection_id]),
    fct_fivetran_connector_health[success_rate_last_7d] < 0.80
)
```
**Description**: Connectors with <80% success rate  
**Use Case**: Proactive alerting  
**Target**: 0

---

### Sync Performance Metrics

#### Average Sync Duration
```dax
Avg Sync Duration (min) = 
AVERAGE(fct_fivetran_sync_performance[sync_duration_minutes])
```
**Description**: Average time to complete a sync  
**Use Case**: Performance monitoring, optimization  
**Target**: <15 minutes

#### Median Sync Duration
```dax
Median Sync Duration (min) = 
MEDIAN(fct_fivetran_sync_performance[sync_duration_minutes])
```
**Description**: Median sync duration (less affected by outliers)  
**Use Case**: Performance baseline  
**Target**: <10 minutes

#### P95 Sync Duration
```dax
P95 Sync Duration (min) = 
PERCENTILEX.INC(fct_fivetran_sync_performance, 
    fct_fivetran_sync_performance[sync_duration_minutes], 0.95)
```
**Description**: 95th percentile sync duration  
**Use Case**: SLA monitoring, capacity planning  
**Target**: <30 minutes

#### Total Syncs
```dax
Total Syncs = COUNTROWS(fct_fivetran_sync_performance)
```
**Description**: Total number of sync operations  
**Use Case**: Volume tracking  
**Target**: N/A (informational)

#### Successful Syncs
```dax
Successful Syncs = 
CALCULATE(
    COUNTROWS(fct_fivetran_sync_performance),
    fct_fivetran_sync_performance[sync_status] = "SUCCESS"
)
```
**Description**: Number of successful syncs  
**Use Case**: Success tracking  
**Target**: ≥95% of total syncs

#### Failed Syncs
```dax
Failed Syncs = 
CALCULATE(
    COUNTROWS(fct_fivetran_sync_performance),
    fct_fivetran_sync_performance[sync_status] = "FAILURE"
)
```
**Description**: Number of failed syncs  
**Use Case**: Error tracking  
**Target**: <5% of total syncs

#### Success Rate
```dax
Success Rate = 
DIVIDE([Successful Syncs], [Total Syncs], 0)
```
**Description**: Percentage of successful syncs  
**Use Case**: SLA monitoring, platform health  
**Target**: ≥95%  
**Format**: Percentage

#### Rows Synced
```dax
Rows Synced = SUM(fct_fivetran_sync_performance[rows_synced])
```
**Description**: Total rows synced across all connectors  
**Use Case**: Volume tracking, capacity planning  
**Target**: N/A (informational)

#### Rows Per Minute
```dax
Rows Per Minute = 
DIVIDE(
    [Rows Synced],
    SUM(fct_fivetran_sync_performance[sync_duration_minutes]),
    0
)
```
**Description**: Average throughput (rows/minute)  
**Use Case**: Performance optimization  
**Target**: Varies by connector

---

### Cost & Usage Metrics

#### Total MAR
```dax
Total MAR = SUM(fct_fivetran_monthly_active_rows[total_active_rows])
```
**Description**: Total Monthly Active Rows  
**Use Case**: Billing, cost tracking  
**Target**: N/A (informational)  
**Format**: Number (1,234,567)

#### Paid MAR
```dax
Paid MAR = SUM(fct_fivetran_monthly_active_rows[paid_active_rows])
```
**Description**: Billable Monthly Active Rows  
**Use Case**: Cost tracking  
**Target**: N/A (informational)

#### Free MAR
```dax
Free MAR = SUM(fct_fivetran_monthly_active_rows[free_active_rows])
```
**Description**: Free tier Monthly Active Rows  
**Use Case**: Free tier usage tracking  
**Target**: N/A (informational)

#### Paid MAR Percentage
```dax
Paid MAR % = 
DIVIDE([Paid MAR], [Total MAR], 0)
```
**Description**: Percentage of MAR that is billable  
**Use Case**: Cost analysis  
**Target**: N/A (informational)  
**Format**: Percentage

#### MAR Growth MoM
```dax
MAR Growth MoM = 
VAR CurrentMonth = [Total MAR]
VAR PreviousMonth = 
    CALCULATE(
        [Total MAR],
        DATEADD(fct_fivetran_monthly_active_rows[month_date], -1, MONTH)
    )
RETURN
    DIVIDE(CurrentMonth - PreviousMonth, PreviousMonth, 0)
```
**Description**: Month-over-month MAR growth rate  
**Use Case**: Trend analysis, forecasting  
**Target**: N/A (informational)  
**Format**: Percentage

#### MAR Growth YoY
```dax
MAR Growth YoY = 
VAR CurrentYear = [Total MAR]
VAR PreviousYear = 
    CALCULATE(
        [Total MAR],
        DATEADD(fct_fivetran_monthly_active_rows[month_date], -1, YEAR)
    )
RETURN
    DIVIDE(CurrentYear - PreviousYear, PreviousYear, 0)
```
**Description**: Year-over-year MAR growth rate  
**Use Case**: Annual planning  
**Target**: N/A (informational)  
**Format**: Percentage

#### Avg MAR per Connector
```dax
Avg MAR per Connector = 
DIVIDE(
    [Total MAR], 
    DISTINCTCOUNT(fct_fivetran_monthly_active_rows[connection_name])
)
```
**Description**: Average MAR per connector  
**Use Case**: Connector comparison  
**Target**: N/A (informational)

#### Estimated Monthly Cost
```dax
Estimated Monthly Cost = 
VAR CostPerMillionMAR = 100  -- Adjust based on your pricing
RETURN
    ([Paid MAR] / 1000000) * CostPerMillionMAR
```
**Description**: Estimated monthly Fivetran cost  
**Use Case**: Budget tracking  
**Target**: Within budget  
**Format**: Currency

---

### Error & Quality Metrics

#### Total Errors
```dax
Total Errors = COUNTROWS(fct_fivetran_error_monitoring)
```
**Description**: Total number of errors  
**Use Case**: Error tracking  
**Target**: Minimize

#### Recurring Errors
```dax
Recurring Errors = 
CALCULATE(
    COUNTROWS(fct_fivetran_error_monitoring),
    fct_fivetran_error_monitoring[is_recurring_error] = TRUE
)
```
**Description**: Errors that have occurred multiple times  
**Use Case**: Problem identification  
**Target**: 0

#### Error Rate
```dax
Error Rate = 
DIVIDE(
    [Total Errors],
    [Total Syncs],
    0
)
```
**Description**: Errors per sync  
**Use Case**: Quality monitoring  
**Target**: <5%  
**Format**: Percentage

#### Unique Error Types
```dax
Unique Error Types = 
DISTINCTCOUNT(fct_fivetran_error_monitoring[error_type])
```
**Description**: Number of distinct error types  
**Use Case**: Error diversity tracking  
**Target**: Minimize

#### Connectors with Errors
```dax
Connectors with Errors = 
DISTINCTCOUNT(fct_fivetran_error_monitoring[connection_name])
```
**Description**: Number of connectors experiencing errors  
**Use Case**: Impact assessment  
**Target**: Minimize

#### Mean Time to Resolution (MTTR)
```dax
MTTR (hours) = 
AVERAGE(fct_fivetran_error_monitoring[resolution_time_hours])
```
**Description**: Average time to resolve errors  
**Use Case**: Support efficiency  
**Target**: <4 hours

---

### Schema Change Metrics

#### Total Schema Changes
```dax
Total Schema Changes = 
COUNTROWS(fct_fivetran_schema_change_history)
```
**Description**: Total number of schema changes detected  
**Use Case**: Change tracking  
**Target**: N/A (informational)

#### Breaking Changes
```dax
Breaking Changes = 
CALCULATE(
    COUNTROWS(fct_fivetran_schema_change_history),
    fct_fivetran_schema_change_history[change_type] IN {"DROP", "ALTER"}
)
```
**Description**: Changes that may break downstream processes  
**Use Case**: Risk management  
**Target**: Minimize

#### Non-Breaking Changes
```dax
Non-Breaking Changes = 
CALCULATE(
    COUNTROWS(fct_fivetran_schema_change_history),
    fct_fivetran_schema_change_history[change_type] = "ADD"
)
```
**Description**: Additive changes (new columns/tables)  
**Use Case**: Schema evolution tracking  
**Target**: N/A (informational)

#### Tables Affected by Changes
```dax
Tables Affected = 
DISTINCTCOUNT(fct_fivetran_schema_change_history[table_name])
```
**Description**: Number of tables with schema changes  
**Use Case**: Impact assessment  
**Target**: N/A (informational)

#### Connections with Changes
```dax
Connections with Changes = 
DISTINCTCOUNT(fct_fivetran_schema_change_history[connection_name])
```
**Description**: Number of connectors with schema changes  
**Use Case**: Change distribution  
**Target**: N/A (informational)

---

### User Activity Metrics

#### Total User Actions
```dax
Total User Actions = 
COUNTROWS(fct_fivetran_user_activity)
```
**Description**: Total number of user actions in audit log  
**Use Case**: Activity tracking  
**Target**: N/A (informational)

#### Active Users
```dax
Active Users = 
DISTINCTCOUNT(fct_fivetran_user_activity[user_email])
```
**Description**: Number of users who performed actions  
**Use Case**: Adoption tracking  
**Target**: N/A (informational)

#### Admin Actions
```dax
Admin Actions = 
CALCULATE(
    COUNTROWS(fct_fivetran_user_activity),
    fct_fivetran_user_activity[event_type] IN {
        "CREATE", "UPDATE", "DELETE", "GRANT", "REVOKE"
    }
)
```
**Description**: Number of administrative actions  
**Use Case**: Governance, compliance  
**Target**: N/A (informational)

#### High-Risk Actions
```dax
High-Risk Actions = 
CALCULATE(
    COUNTROWS(fct_fivetran_user_activity),
    fct_fivetran_user_activity[event_type] IN {"DELETE", "REVOKE"}
)
```
**Description**: Actions that could cause data loss  
**Use Case**: Security monitoring  
**Target**: Minimize

---

## 📈 Time Intelligence Measures

### Last 7 Days Metrics

#### Syncs Last 7D
```dax
Syncs Last 7D = 
CALCULATE(
    [Total Syncs],
    DATESINPERIOD(
        fct_fivetran_sync_performance[started_at],
        LASTDATE(fct_fivetran_sync_performance[started_at]),
        -7,
        DAY
    )
)
```

#### Errors Last 7D
```dax
Errors Last 7D = 
CALCULATE(
    [Total Errors],
    DATESINPERIOD(
        fct_fivetran_error_monitoring[logged_at],
        LASTDATE(fct_fivetran_error_monitoring[logged_at]),
        -7,
        DAY
    )
)
```

#### Success Rate Last 7D
```dax
Success Rate Last 7D = 
CALCULATE(
    [Success Rate],
    DATESINPERIOD(
        fct_fivetran_sync_performance[started_at],
        LASTDATE(fct_fivetran_sync_performance[started_at]),
        -7,
        DAY
    )
)
```

### Last 30 Days Metrics

#### Syncs Last 30D
```dax
Syncs Last 30D = 
CALCULATE(
    [Total Syncs],
    DATESINPERIOD(
        fct_fivetran_sync_performance[started_at],
        LASTDATE(fct_fivetran_sync_performance[started_at]),
        -30,
        DAY
    )
)
```

#### MAR Last 30D
```dax
MAR Last 30D = 
CALCULATE(
    [Total MAR],
    DATESINPERIOD(
        fct_fivetran_monthly_active_rows[month_date],
        LASTDATE(fct_fivetran_monthly_active_rows[month_date]),
        -30,
        DAY
    )
)
```

### Yesterday vs Today

#### Syncs Today
```dax
Syncs Today = 
CALCULATE(
    [Total Syncs],
    fct_fivetran_sync_performance[started_at] = TODAY()
)
```

#### Syncs Yesterday
```dax
Syncs Yesterday = 
CALCULATE(
    [Total Syncs],
    fct_fivetran_sync_performance[started_at] = TODAY() - 1
)
```

#### Syncs Change vs Yesterday
```dax
Syncs Change vs Yesterday = 
[Syncs Today] - [Syncs Yesterday]
```

#### Syncs % Change vs Yesterday
```dax
Syncs % Change vs Yesterday = 
DIVIDE(
    [Syncs Change vs Yesterday],
    [Syncs Yesterday],
    0
)
```

---

## 🎯 Ranking & Top N Measures

### Top Connectors by MAR
```dax
Top 10 Connectors by MAR = 
TOPN(
    10,
    VALUES(fct_fivetran_monthly_active_rows[connection_name]),
    [Total MAR],
    DESC
)
```

### Bottom Performers by Success Rate
```dax
Bottom 5 by Success Rate = 
TOPN(
    5,
    VALUES(fct_fivetran_connector_health[connection_name]),
    [Success Rate],
    ASC
)
```

### Most Error-Prone Connectors
```dax
Most Error-Prone = 
TOPN(
    10,
    VALUES(fct_fivetran_error_monitoring[connection_name]),
    [Total Errors],
    DESC
)
```

---

## 🚦 Status & Health Indicators

### Health Status
```dax
Health Status = 
SWITCH(
    TRUE(),
    [Success Rate] >= 0.95, "Healthy",
    [Success Rate] >= 0.80, "Warning",
    "Critical"
)
```

### Sync Duration Status
```dax
Duration Status = 
SWITCH(
    TRUE(),
    [Avg Sync Duration (min)] < 15, "Fast",
    [Avg Sync Duration (min)] < 30, "Normal",
    "Slow"
)
```

### Error Severity
```dax
Error Severity = 
SWITCH(
    TRUE(),
    [Total Errors] = 0, "None",
    [Total Errors] <= 5, "Low",
    [Total Errors] <= 20, "Medium",
    "High"
)
```

---

## 📊 Conditional Formatting Expressions

### Success Rate Color
```dax
Success Rate Color = 
SWITCH(
    TRUE(),
    [Success Rate] >= 0.95, "#00C48C",  -- Green
    [Success Rate] >= 0.80, "#FF9500",  -- Orange
    "#FF3B30"                            -- Red
)
```

### MAR Growth Color
```dax
MAR Growth Color = 
IF(
    [MAR Growth MoM] >= 0,
    "#00C48C",  -- Green (positive growth)
    "#FF3B30"   -- Red (negative growth)
)
```

### Sync Duration Color
```dax
Duration Color = 
SWITCH(
    TRUE(),
    [Avg Sync Duration (min)] < 15, "#00C48C",   -- Green
    [Avg Sync Duration (min)] < 30, "#FF9500",   -- Orange
    "#FF3B30"                                     -- Red
)
```

---

## 🔍 Filter Context Measures

### Selected Connection MAR
```dax
Selected Connection MAR = 
IF(
    HASONEVALUE(fct_fivetran_monthly_active_rows[connection_name]),
    [Total MAR],
    BLANK()
)
```

### Selected Date Range
```dax
Selected Date Range = 
IF(
    HASONEFILTER(DateTable[Date]),
    "Filtered",
    "All Dates"
)
```

---

## 📚 Usage Notes

### Measure Naming Conventions
- **Descriptive names**: Use clear, business-friendly names
- **Units in parentheses**: Include units like (min), (%), ($)
- **Abbreviations**: Use common abbreviations (MAR, MoM, YoY)

### Performance Tips
1. Use **variables** in complex calculations
2. Avoid **nested CALCULATE** when possible
3. Use **COUNTROWS** instead of COUNT for better performance
4. Create **aggregated tables** for large datasets

### Testing Checklist
- [ ] Verify calculations with known data
- [ ] Test with different filter contexts
- [ ] Check for division by zero errors
- [ ] Validate time intelligence measures
- [ ] Test with empty tables

---

**Last Updated**: November 2024  
**Total Measures**: 60+  
**Categories**: 7 (Health, Performance, Cost, Errors, Schema, Users, Time Intelligence)
