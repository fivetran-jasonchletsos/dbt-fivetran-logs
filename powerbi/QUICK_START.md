# Power BI Quick Start Guide

**Get your first dashboard running in 30 minutes!**

---

## 📋 Prerequisites

- [ ] Power BI Desktop installed ([Download here](https://powerbi.microsoft.com/desktop/))
- [ ] Snowflake account credentials
- [ ] dbt models successfully run in `FIVETRAN_ANALYTICS_FCT_FIVETRAN_LOGS` schema
- [ ] Snowflake connector for Power BI installed (auto-installs on first use)

---

## 🚀 Step 1: Connect to Snowflake (5 minutes)

### 1.1 Open Power BI Desktop
- Launch Power BI Desktop
- Close the splash screen

### 1.2 Get Data from Snowflake
1. Click **Home** → **Get Data** → **More...**
2. Search for "Snowflake"
3. Select **Snowflake** and click **Connect**

### 1.3 Enter Connection Details
```
Server: YOUR_ACCOUNT.snowflakecomputing.com
Warehouse: YOUR_WAREHOUSE
```

**Example:**
```
Server: abc12345.us-east-1.snowflakecomputing.com
Warehouse: COMPUTE_WH
```

4. Click **OK**

### 1.4 Authenticate
1. Select **Username/Password** or **Microsoft Account**
2. Enter your credentials
3. Click **Connect**

### 1.5 Select Data Mode
- **DirectQuery**: Real-time data (recommended for dashboards)
- **Import**: Faster performance (recommended for reports)

**Recommendation**: Start with **Import** for faster development

---

## 📊 Step 2: Import Tables (5 minutes)

### 2.1 Navigate to Schema
1. In the Navigator window, expand your database
2. Find and expand the `FIVETRAN_ANALYTICS_FCT_FIVETRAN_LOGS` schema

### 2.2 Select Tables
Check the boxes next to these 5 tables (all UPPERCASE):
- ✅ `FCT_FIVETRAN_CONNECTOR_HEALTH`
- ✅ `FCT_FIVETRAN_SYNC_PERFORMANCE`
- ✅ `FCT_FIVETRAN_MONTHLY_ACTIVE_ROWS`
- ✅ `FCT_FIVETRAN_ERROR_MONITORING`
- ✅ `FCT_FIVETRAN_SCHEMA_CHANGE_HISTORY`

### 2.3 Load or Transform Data
**Option 1: Quick Load (Fastest)**
- Click **Load** to import tables as-is
- Table and column names will be UPPERCASE (Snowflake standard)

**Option 2: Transform First (Recommended)**
1. Click **Transform Data** instead of **Load**
2. This opens Power Query Editor
3. Optionally rename tables/columns to your preferred case
4. Verify data types are correct
5. Click **Close & Apply**

**Note**: All table and column names are UPPERCASE by default in Snowflake. You can rename them in Power BI Power Query Editor if you prefer lowercase.

---

## 📅 Step 3: Create Date Table (3 minutes)

### 3.1 Create New Table
1. Click **Modeling** tab
2. Click **New Table**
3. Paste this DAX formula:

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
    "YearMonth", FORMAT([Date], "yyyy-MM")
)
```

4. Press **Enter**

### 3.2 Mark as Date Table
1. Select the `DateTable` in the Fields pane
2. Click **Table tools** → **Mark as date table**
3. Select `Date` column
4. Click **OK**

---

## 🔗 Step 4: Create Relationships (3 minutes)

### 4.1 Open Model View
- Click the **Model** icon on the left sidebar (looks like three connected boxes)

### 4.2 Create Relationships
Drag and drop to create these relationships:

**From `FCT_FIVETRAN_CONNECTOR_HEALTH`:**
```
CONNECTION_NAME → FCT_FIVETRAN_SYNC_PERFORMANCE[CONNECTION_NAME]
CONNECTION_NAME → FCT_FIVETRAN_MONTHLY_ACTIVE_ROWS[CONNECTION_NAME]
CONNECTION_NAME → FCT_FIVETRAN_ERROR_MONITORING[CONNECTION_NAME]
CONNECTION_NAME → FCT_FIVETRAN_SCHEMA_CHANGE_HISTORY[CONNECTION_NAME]
```

**From `DateTable`:**
```
Date → FCT_FIVETRAN_SYNC_PERFORMANCE[SYNC_START_TIME] (date part)
Date → FCT_FIVETRAN_ERROR_MONITORING[ERROR_TIMESTAMP] (date part)
Date → FCT_FIVETRAN_MONTHLY_ACTIVE_ROWS[MEASURED_MONTH]
Date → FCT_FIVETRAN_SCHEMA_CHANGE_HISTORY[CHANGE_TIMESTAMP] (date part)
```

**Relationship Settings:**
- Cardinality: **One to Many (1:*)**
- Cross filter direction: **Single**
- Make this relationship active: **✓**

---

## 📏 Step 5: Import DAX Measures (5 minutes)

### 5.1 Open Measures File
- Open `powerbi/fivetran_measures.dax` in a text editor

### 5.2 Import Core Measures
Copy and paste these measures one at a time:

**Method 1: Individual Measures**
1. Click **Modeling** → **New Measure**
2. Copy a measure from the `.dax` file
3. Paste into the formula bar
4. Press **Enter**
5. Repeat for each measure

**Method 2: Bulk Import (Faster)**
1. Select all measures from the `.dax` file (Ctrl+A)
2. Copy (Ctrl+C)
3. In Power BI, click on any table in Fields pane
4. Paste (Ctrl+V)
5. Power BI will create all measures at once

### 5.3 Essential Measures to Start With
If doing one at a time, start with these 10:

```dax
Total Connectors = DISTINCTCOUNT(fct_fivetran_connector_health[connection_id])

Healthy Connectors = 
CALCULATE(
    DISTINCTCOUNT(fct_fivetran_connector_health[connection_id]),
    fct_fivetran_connector_health[success_rate_last_7d] >= 0.95
)

Health Percentage = 
DIVIDE([Healthy Connectors], [Total Connectors], 0)

Total Syncs = COUNTROWS(fct_fivetran_sync_performance)

Success Rate = 
DIVIDE([Successful Syncs], [Total Syncs], 0)

Successful Syncs = 
CALCULATE(
    COUNTROWS(fct_fivetran_sync_performance),
    fct_fivetran_sync_performance[sync_status] = "SUCCESS"
)

Total MAR = SUM(fct_fivetran_monthly_active_rows[total_active_rows])

Total Errors = COUNTROWS(fct_fivetran_error_monitoring)

Avg Sync Duration (min) = 
AVERAGE(fct_fivetran_sync_performance[sync_duration_minutes])

Rows Synced = SUM(fct_fivetran_sync_performance[rows_synced])
```

---

## 🎨 Step 6: Build Your First Dashboard (10 minutes)

### 6.1 Create New Report Page
- Click **Report** view (left sidebar)
- You should see a blank canvas

### 6.2 Add KPI Cards (Top Row)

**Card 1: Total Connectors**
1. Click **Visualizations** → **Card**
2. Drag `Total Connectors` measure to **Fields**
3. Resize and position in top-left
4. Format:
   - **Callout value** → Font size: 48pt
   - **Category label** → Text: "Total Connectors"

**Card 2: Health Percentage**
1. Add another **Card** visual
2. Drag `Health Percentage` measure
3. Format:
   - **Callout value** → Display units: Percentage, Decimal places: 0
   - **Category label** → Text: "Health Rate"

**Card 3: Total MAR**
1. Add another **Card** visual
2. Drag `Total MAR` measure
3. Format:
   - **Callout value** → Display units: Millions, Decimal places: 1
   - **Category label** → Text: "Total MAR"

**Card 4: Success Rate**
1. Add another **Card** visual
2. Drag `Success Rate` measure
3. Format:
   - **Callout value** → Display units: Percentage, Decimal places: 1
   - **Category label** → Text: "Success Rate"

### 6.3 Add Line Chart (Health Trend)

1. Click **Visualizations** → **Line chart**
2. Drag fields:
   - **X-axis**: `DateTable[Date]`
   - **Y-axis**: `Health Percentage`
3. Resize to fill middle section
4. Format:
   - **Title**: "Connector Health Trend"
   - **Y-axis** → Display units: Percentage
   - **Data colors** → Line color: #0073E6 (Fivetran blue)

### 6.4 Add Bar Chart (MAR by Connector)

1. Click **Visualizations** → **Clustered bar chart**
2. Drag fields:
   - **Y-axis**: `FCT_FIVETRAN_MONTHLY_ACTIVE_ROWS[CONNECTION_NAME]`
   - **X-axis**: `Total MAR`
3. Resize and position
4. Format:
   - **Title**: "MAR by Connector"
   - **Data colors** → Default color: #0073E6
   - **Data labels** → On

### 6.5 Add Table (Recent Errors)

1. Click **Visualizations** → **Table**
2. Drag fields:
   - `FCT_FIVETRAN_ERROR_MONITORING[CONNECTION_NAME]`
   - `FCT_FIVETRAN_ERROR_MONITORING[ERROR_TYPE]`
   - `FCT_FIVETRAN_ERROR_MONITORING[ERROR_TIMESTAMP]`
   - `FCT_FIVETRAN_ERROR_MONITORING[ERROR_MESSAGE]`
3. Resize and position in bottom section
4. Format:
   - **Title**: "Recent Errors"
   - **Style** → Minimal

### 6.6 Add Slicers (Filters)

**Date Range Slicer:**
1. Click **Visualizations** → **Slicer**
2. Drag `DateTable[Date]` to **Field**
3. Change slicer type to **Between** (click dropdown in slicer)
4. Position in top-right corner

**Connector Type Slicer:**
1. Add another **Slicer**
2. Drag `FCT_FIVETRAN_CONNECTOR_HEALTH[CONNECTOR_NAME]`
3. Position below date slicer

---

## 🎨 Step 7: Apply Formatting (3 minutes)

### 7.1 Apply Theme Colors
1. Click **View** → **Themes** → **Customize current theme**
2. Under **Colors**, set:
   - Primary: `#0073E6` (Fivetran Blue)
   - Success: `#00C48C` (Green)
   - Warning: `#FF9500` (Orange)
   - Danger: `#FF3B30` (Red)

### 7.2 Set Page Background
1. Click blank area of canvas
2. In **Format** pane → **Canvas background**
3. Color: `#F2F2F7` (Light gray)

### 7.3 Add Title
1. Click **Insert** → **Text box**
2. Type: "Fivetran Platform Health Dashboard"
3. Format:
   - Font: Segoe UI
   - Size: 24pt
   - Color: #0073E6
   - Bold: Yes
4. Position at top of page

---

## ✅ Step 8: Test & Validate (3 minutes)

### 8.1 Test Filters
- Select different date ranges in the slicer
- Verify all visuals update correctly
- Select different connector types
- Verify filtering works

### 8.2 Validate Data
- Check that numbers make sense
- Compare with source data in Snowflake
- Verify date ranges are correct

### 8.3 Test Interactions
- Click on a bar in the bar chart
- Verify other visuals filter accordingly
- Click on a line in the line chart
- Test cross-filtering behavior

---

## 💾 Step 9: Save & Publish (2 minutes)

### 9.1 Save Locally
1. Click **File** → **Save**
2. Choose location
3. Name: `Fivetran_Analytics_Dashboard.pbix`
4. Click **Save**

### 9.2 Publish to Power BI Service (Optional)
1. Click **Home** → **Publish**
2. Sign in to Power BI Service
3. Select workspace
4. Click **Select**
5. Wait for publish to complete
6. Click **Open in Power BI** to view online

---

## 🎉 You're Done!

You now have a working Fivetran analytics dashboard with:
- ✅ 4 KPI cards showing key metrics
- ✅ Health trend line chart
- ✅ MAR by connector bar chart
- ✅ Recent errors table
- ✅ Interactive filters
- ✅ Fivetran brand colors

---

## 🚀 Next Steps

### Immediate
1. ✅ Add more measures from `fivetran_measures.dax`
2. ✅ Create conditional formatting on tables
3. ✅ Add drill-through pages for detailed analysis
4. ✅ Set up scheduled refresh (if published)

### This Week
1. ✅ Build additional dashboard pages (see `POWERBI_GUIDE.md`)
2. ✅ Add more advanced visuals (matrix, treemap, scatter)
3. ✅ Create bookmarks for different views
4. ✅ Share with stakeholders

### This Month
1. ✅ Build all 5 dashboard templates
2. ✅ Set up data alerts on critical metrics
3. ✅ Create mobile layouts
4. ✅ Implement Row-Level Security (if needed)

---

## 📚 Additional Resources

- **[POWERBI_GUIDE.md](../POWERBI_GUIDE.md)** - Complete dashboard templates
- **[METRICS_CATALOG.md](METRICS_CATALOG.md)** - All 60+ DAX measures
- **[fivetran_measures.dax](fivetran_measures.dax)** - Ready-to-import measures

---

## 🆘 Troubleshooting

### Can't Connect to Snowflake
- Verify account name format: `account.region.snowflakecomputing.com`
- Check warehouse is running
- Verify user has access to `FIVETRAN_ANALYTICS_FCT_FIVETRAN_LOGS` schema
- Try using **Microsoft Account** authentication if SSO is enabled

### Tables Not Loading
- Verify dbt models have run successfully
- Check schema name is `FIVETRAN_ANALYTICS_FCT_FIVETRAN_LOGS` (UPPERCASE)
- Ensure user has SELECT permissions on tables
- Look for tables starting with `FCT_FIVETRAN_` (all UPPERCASE)

### Measures Show Errors
- Check table and column names match your schema
- Verify relationships are set up correctly
- Check for typos in measure formulas
- Ensure referenced columns exist in tables

### Visuals Not Updating
- Check filter context
- Verify relationships are active
- Clear all filters and try again
- Refresh data: **Home** → **Refresh**

### Performance Issues
- Switch from DirectQuery to Import mode
- Reduce date range in filters
- Create aggregated tables for large datasets
- Remove unused columns from tables

---

## 📧 Need Help?

- **Email**: jason.chletsos@fivetran.com
- **Documentation**: See other files in `powerbi/` folder
- **GitHub Issues**: Open an issue in the repository

---

**Total Time**: ~30 minutes  
**Difficulty**: Beginner  
**Result**: Production-ready dashboard! 🎉
