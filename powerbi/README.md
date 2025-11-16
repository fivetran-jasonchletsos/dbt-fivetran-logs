# Power BI Resources

Complete Power BI setup resources for Fivetran Log analytics dashboards.

## 📁 Files in This Directory

### **QUICK_START.md** ⭐ START HERE
30-minute step-by-step guide to build your first dashboard:
- Connect to Snowflake (5 min)
- Import tables (5 min)
- Create relationships (3 min)
- Add DAX measures (5 min)
- Build dashboard (10 min)
- Apply formatting (3 min)

**Use this when**: You're building your first Power BI dashboard

---

### **fivetran_measures.dax**
Ready-to-import DAX measures file with 50+ measures:
- Copy/paste directly into Power BI
- All measures organized by category
- Includes comments and descriptions
- No manual typing required!

**Use this when**: You want to quickly import all measures at once

---

### **snowflake_import.pq**
Power Query M scripts for data import:
- 6 pre-built queries for all tables
- Automatic column renaming
- Data type transformations
- Date filtering for performance
- Complete Date table script

**Use this when**: You want automated data import with proper formatting

---

### **METRICS_CATALOG.md**
Complete catalog of 60+ DAX measures organized by category:
- Connector Health Metrics
- Sync Performance Metrics
- Cost & Usage Metrics (MAR tracking)
- Error & Quality Metrics
- Schema Change Metrics
- User Activity Metrics
- Time Intelligence Measures
- Ranking & Top N Measures
- Status & Health Indicators
- Conditional Formatting Expressions

**Use this when**: You need ready-to-use DAX formulas for your dashboards

---

## 🚀 Quick Start

### 1. Follow the Quick Start Guide
Start with **[QUICK_START.md](QUICK_START.md)** for a 30-minute walkthrough:
- Connect to Snowflake in 5 minutes
- Import tables and create relationships
- Add DAX measures
- Build your first dashboard
- **Result**: Working dashboard in 30 minutes!

### 2. Read the Main Guide
Then see **[POWERBI_GUIDE.md](../POWERBI_GUIDE.md)** for advanced features:
- 5 pre-designed dashboard layouts
- Advanced DAX patterns
- Pre-built SQL queries
- Formatting best practices

### 2. Copy DAX Measures
Open **METRICS_CATALOG.md** and copy the DAX measures you need:
```dax
Total Connectors = DISTINCTCOUNT(fct_fivetran_connector_health[connection_id])

Health Percentage = 
DIVIDE([Healthy Connectors], [Total Connectors], 0)

Success Rate = 
DIVIDE([Successful Syncs], [Total Syncs], 0)
```

### 3. Build Your Dashboards
Follow the dashboard templates in POWERBI_GUIDE.md:
- **Dashboard 1**: Executive Overview
- **Dashboard 2**: Connector Health Monitoring
- **Dashboard 3**: Cost & Usage Analytics
- **Dashboard 4**: Schema Change Tracking
- **Dashboard 5**: Error Monitoring & Troubleshooting

---

## 📊 Dashboard Templates

### Executive Overview
**KPIs**: Total Connectors, Health %, MAR, Active Syncs  
**Visuals**: Health trend line, MAR by connector bar, Error table  
**Audience**: Executives, Platform Managers  
**Refresh**: Daily

### Connector Health Monitoring
**KPIs**: Avg Sync Duration, Failed Syncs, Success Rate, Rows Synced  
**Visuals**: Performance area chart, Status matrix, Error table  
**Audience**: Data Engineers, DevOps  
**Refresh**: Hourly

### Cost & Usage Analytics
**KPIs**: Total MAR, Paid MAR, Free MAR, MoM Growth  
**Visuals**: MAR trend combo chart, Connector treemap, Schema table  
**Audience**: Finance, Platform Managers  
**Refresh**: Daily

### Schema Change Tracking
**KPIs**: Changes (7D), Breaking Changes, Tables Affected  
**Visuals**: Change timeline, Type distribution donut, Changes table  
**Audience**: Data Engineers, Analytics Engineers  
**Refresh**: Hourly

### Error Monitoring
**KPIs**: Total Errors, Recurring Errors, Error Rate, MTTR  
**Visuals**: Error trend with anomaly detection, Type bar, Active errors table  
**Audience**: Data Engineers, Support Team  
**Refresh**: Every 15 minutes

---

## 🎨 Design System

### Fivetran Brand Colors
```
Primary Blue:   #0073E6
Success Green:  #00C48C
Warning Orange: #FF9500
Error Red:      #FF3B30
Neutral Gray:   #8E8E93
Background:     #F2F2F7
```

### Conditional Formatting Thresholds

**Success Rate:**
- 🟢 Green (Healthy): ≥ 95%
- 🟡 Yellow (Warning): 80-94%
- 🔴 Red (Critical): < 80%

**Sync Duration:**
- 🟢 Green (Fast): < 15 minutes
- 🟡 Yellow (Normal): 15-30 minutes
- 🔴 Red (Slow): > 30 minutes

**Error Count:**
- 🟢 Green: 0 errors
- 🟡 Yellow: 1-5 errors
- 🔴 Red: > 5 errors

---

## 🔗 Data Model

### Star Schema
```
fct_fivetran_connector_health (Fact - Center)
    ↓ connection_id (1:many)
├─ fct_fivetran_sync_performance
├─ fct_fivetran_monthly_active_rows
├─ fct_fivetran_error_monitoring
└─ fct_fivetran_schema_change_history

DateTable (Dimension)
    ↓ Date (1:many)
├─ fct_fivetran_sync_performance[started_at]
├─ fct_fivetran_error_monitoring[logged_at]
└─ fct_fivetran_schema_change_history[change_detected_at]
```

### Create Date Table
```dax
DateTable = 
ADDCOLUMNS(
    CALENDAR(DATE(2020, 1, 1), TODAY()),
    "Year", YEAR([Date]),
    "Month", FORMAT([Date], "MMM"),
    "Quarter", "Q" & FORMAT([Date], "Q"),
    "WeekNum", WEEKNUM([Date]),
    "DayOfWeek", FORMAT([Date], "ddd")
)
```

---

## 📥 Pre-Built Queries

All queries are in **POWERBI_GUIDE.md**. Key queries include:

1. **Connector Health Summary** - Main health metrics with status
2. **MAR by Connection** - 12-month MAR trend with paid/free split
3. **Schema Changes** - 30-day change history with impact level
4. **Error Summary** - 7-day errors with recurrence and severity
5. **Sync Performance** - 7-day sync metrics with throughput

---

## 🎯 Measure Categories

### Core KPIs (15 measures)
- Total/Healthy/At-Risk Connectors
- Success Rate, Failed Syncs
- Total/Paid/Free MAR
- Total Errors, Error Rate

### Performance (10 measures)
- Avg/Median/P95 Sync Duration
- Rows Synced, Rows Per Minute
- Sync counts by status

### Time Intelligence (12 measures)
- Last 7D/30D metrics
- Today vs Yesterday comparisons
- MoM/YoY growth rates

### Advanced (23+ measures)
- Top N rankings
- Health status indicators
- Conditional formatting colors
- Filter context helpers

---

## ✅ Setup Checklist

### Connection Setup
- [ ] Connect Power BI Desktop to Snowflake
- [ ] Select DirectQuery or Import mode
- [ ] Import fact tables from `FIVETRAN_ANALYTICS` schema
- [ ] Create Date table with DAX
- [ ] Set up table relationships

### Measure Creation
- [ ] Copy core KPI measures from METRICS_CATALOG.md
- [ ] Add time intelligence measures
- [ ] Create conditional formatting measures
- [ ] Test all measures with sample data

### Dashboard Building
- [ ] Build Executive Overview dashboard
- [ ] Build Connector Health dashboard
- [ ] Build Cost & Usage dashboard
- [ ] Build Schema Change dashboard
- [ ] Build Error Monitoring dashboard

### Formatting & Publishing
- [ ] Apply Fivetran brand colors
- [ ] Set up conditional formatting
- [ ] Add slicers (Connection, Date Range, Connector Type)
- [ ] Configure drill-through pages
- [ ] Set up scheduled refresh
- [ ] Publish to Power BI Service
- [ ] Share with stakeholders

---

## 💡 Pro Tips

1. **Performance**: Use DirectQuery for real-time data, Import for faster visuals
2. **Security**: Implement Row-Level Security (RLS) if sharing across teams
3. **Alerts**: Set up data alerts on critical metrics (error count, success rate)
4. **Mobile**: Design mobile-friendly layouts for on-the-go monitoring
5. **Bookmarks**: Create bookmarks for different time periods (daily/weekly/monthly)
6. **Tooltips**: Add custom tooltips with additional context
7. **Drill-through**: Enable drill-through from summary to detail pages
8. **Refresh**: Schedule refresh during off-peak hours (2-4 AM)

---

## 📚 Additional Resources

### Documentation
- **[POWERBI_GUIDE.md](../POWERBI_GUIDE.md)** - Complete setup guide
- **[MODEL_REFERENCE.md](../MODEL_REFERENCE.md)** - dbt model documentation
- **[PROJECT_SUMMARY.md](../PROJECT_SUMMARY.md)** - Project overview

### External Links
- [Power BI Documentation](https://docs.microsoft.com/power-bi/)
- [DAX Guide](https://dax.guide/)
- [Snowflake Connector](https://docs.microsoft.com/power-bi/connect-data/service-connect-snowflake)
- [Power BI Best Practices](https://docs.microsoft.com/power-bi/guidance/)

---

## 🆘 Troubleshooting

### Connection Issues
**Problem**: Can't connect to Snowflake  
**Solution**: Verify account name, warehouse, and credentials. Ensure Snowflake connector is installed.

### Slow Performance
**Problem**: Dashboards are slow to load  
**Solution**: Switch to Import mode, reduce visual complexity, or create aggregated tables.

### Incorrect Calculations
**Problem**: Measures showing wrong values  
**Solution**: Check filter context, verify relationships, test with known data.

### Missing Data
**Problem**: Some tables have no data  
**Solution**: Verify dbt models have run successfully, check source data availability.

---

## 📧 Support

**Questions?** Contact: jason.chletsos@fivetran.com

**Issues?** Open a GitHub issue in the repository

---

**Last Updated**: November 2024  
**Power BI Version**: Desktop & Service  
**Total Measures**: 60+  
**Dashboard Templates**: 5
