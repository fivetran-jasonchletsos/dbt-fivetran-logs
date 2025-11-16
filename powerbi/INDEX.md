# Power BI Resources - Complete Index

**Everything you need to build Fivetran analytics dashboards in Power BI**

---

## 🎯 Where to Start?

### New to Power BI or Fivetran Analytics?
👉 **Start here**: [QUICK_START.md](QUICK_START.md)
- 30-minute walkthrough
- Step-by-step instructions
- Build your first dashboard today!

### Want to see what's possible?
👉 **Go to**: [POWERBI_GUIDE.md](../POWERBI_GUIDE.md)
- 5 complete dashboard templates
- Visual mockups and layouts
- Design best practices

### Need specific measures?
👉 **Check**: [METRICS_CATALOG.md](METRICS_CATALOG.md)
- 60+ DAX measures
- Organized by category
- Complete descriptions

### Want to import everything quickly?
👉 **Use these**:
- [fivetran_measures.dax](fivetran_measures.dax) - All measures ready to import
- [snowflake_import.pq](snowflake_import.pq) - Power Query scripts

---

## 📚 Complete File Guide

### 1. Quick Start Guide
**File**: `QUICK_START.md`  
**Time**: 30 minutes  
**What you'll build**: Working dashboard with KPIs, charts, and filters

**Sections**:
- ✅ Step 1: Connect to Snowflake (5 min)
- ✅ Step 2: Import Tables (5 min)
- ✅ Step 3: Create Date Table (3 min)
- ✅ Step 4: Create Relationships (3 min)
- ✅ Step 5: Import DAX Measures (5 min)
- ✅ Step 6: Build Dashboard (10 min)
- ✅ Step 7: Apply Formatting (3 min)
- ✅ Step 8: Test & Validate (3 min)
- ✅ Step 9: Save & Publish (2 min)

**Best for**: First-time users, quick setup

---

### 2. Complete Power BI Guide
**File**: `../POWERBI_GUIDE.md` (in root directory)  
**Length**: 585 lines  
**What's included**: Complete reference for all dashboards

**Sections**:
- 📊 5 Dashboard Templates (Executive, Health, Cost, Schema, Errors)
- 🔗 Data Model & Relationships
- 🎨 Design System & Colors
- 📈 Pre-built SQL Queries
- 💡 Pro Tips & Best Practices
- ✅ Setup Checklist

**Best for**: Comprehensive reference, advanced features

---

### 3. DAX Measures Catalog
**File**: `METRICS_CATALOG.md`  
**Length**: 687 lines  
**Measures**: 60+

**Categories**:
1. **Core KPIs** (15 measures)
   - Total Connectors, Health %, Success Rate, MAR
2. **Sync Performance** (10 measures)
   - Duration, Throughput, Status tracking
3. **Cost & Usage** (9 measures)
   - MAR tracking, Growth rates, Cost estimation
4. **Error & Quality** (6 measures)
   - Error tracking, MTTR, Severity
5. **Schema Changes** (5 measures)
   - Change tracking, Impact assessment
6. **User Activity** (4 measures)
   - Actions, Adoption, Security
7. **Time Intelligence** (12+ measures)
   - Last 7D, Last 30D, MoM, YoY comparisons
8. **Conditional Formatting** (3 measures)
   - Color coding, Status indicators

**Best for**: Reference, copy individual measures

---

### 4. Ready-to-Import DAX File
**File**: `fivetran_measures.dax`  
**Length**: 306 lines  
**Measures**: 50+

**How to use**:
1. Open file in text editor
2. Copy all or specific measures
3. Paste into Power BI (Ctrl+V)
4. All measures created instantly!

**Includes**:
- ✅ All core KPI measures
- ✅ Performance metrics
- ✅ Cost & MAR tracking
- ✅ Error monitoring
- ✅ Time intelligence
- ✅ Conditional formatting
- ✅ Status indicators

**Best for**: Bulk import, quick setup

---

### 5. Power Query Import Scripts
**File**: `snowflake_import.pq`  
**Length**: 329 lines  
**Queries**: 6 (5 tables + Date table)

**Included Queries**:
1. **Connector Health** - Real-time health metrics
2. **Sync Performance** - Sync history (last 90 days)
3. **Monthly Active Rows** - MAR tracking
4. **Error Monitoring** - Error logs (last 30 days)
5. **Schema Change History** - Schema changes (last 90 days)
6. **Date Table** - Calendar dimension (2020 to +3 years)

**Features**:
- ✅ Automatic column renaming (uppercase → lowercase)
- ✅ Data type transformations
- ✅ Date filtering for performance
- ✅ Complete date attributes (Year, Quarter, Month, Week, Day)

**How to use**:
1. Open Power BI → Get Data → Blank Query
2. Open Advanced Editor
3. Copy/paste one query at a time
4. Replace placeholders (YOUR_ACCOUNT, YOUR_WAREHOUSE, etc.)
5. Rename query to table name
6. Repeat for all 6 queries

**Best for**: Automated import, consistent formatting

---

### 6. Power BI README
**File**: `README.md`  
**Length**: 285 lines  
**Purpose**: Quick reference and navigation

**Sections**:
- 🚀 Quick start steps
- 📁 File descriptions
- 🎨 Design system
- 📊 Dashboard templates
- 💡 Pro tips
- 🆘 Troubleshooting

**Best for**: Navigation, quick reference

---

## 🎨 Design Resources

### Fivetran Brand Colors
```
Primary Blue:   #0073E6  (Main brand, titles, primary charts)
Success Green:  #00C48C  (Healthy status, positive metrics)
Warning Orange: #FF9500  (Warning status, needs attention)
Error Red:      #FF3B30  (Critical status, errors)
Neutral Gray:   #8E8E93  (Secondary text, borders)
Background:     #F2F2F7  (Page background)
```

### Color Usage Examples
- **Health Rate ≥95%**: Green (#00C48C)
- **Health Rate 80-95%**: Orange (#FF9500)
- **Health Rate <80%**: Red (#FF3B30)
- **Positive Growth**: Green (#00C48C)
- **Negative Growth**: Red (#FF3B30)

---

## 📊 Dashboard Templates

### 1. Executive Overview
**Purpose**: High-level KPIs for leadership  
**Visuals**: 4 KPI cards, health trend line, MAR bar chart, errors table  
**Refresh**: Daily  
**Audience**: Executives, managers

### 2. Connector Health Monitoring
**Purpose**: Detailed performance tracking  
**Visuals**: Performance cards, sync trends, status matrix, error details  
**Refresh**: Hourly  
**Audience**: Data engineers, operations

### 3. Cost & Usage Analytics
**Purpose**: MAR tracking and optimization  
**Visuals**: MAR cards, trend charts, connector breakdown, growth analysis  
**Refresh**: Daily  
**Audience**: Finance, data leadership

### 4. Schema Change Tracking
**Purpose**: Monitor schema evolution  
**Visuals**: Change counts, timeline, type distribution, impact table  
**Refresh**: Daily  
**Audience**: Data engineers, analysts

### 5. Error Monitoring & Troubleshooting
**Purpose**: Proactive issue resolution  
**Visuals**: Error cards, trend analysis, type breakdown, active errors  
**Refresh**: Hourly  
**Audience**: Support, operations, engineers

---

## 🚀 Implementation Paths

### Path 1: Quick Start (30 minutes)
**Goal**: Get first dashboard running ASAP

1. Follow [QUICK_START.md](QUICK_START.md)
2. Use [fivetran_measures.dax](fivetran_measures.dax) for bulk import
3. Build Executive Overview dashboard
4. Test and publish

**Result**: Working dashboard with core KPIs

---

### Path 2: Comprehensive Setup (2-3 hours)
**Goal**: Build all 5 dashboards with full features

1. Follow [QUICK_START.md](QUICK_START.md) for setup
2. Use [snowflake_import.pq](snowflake_import.pq) for data import
3. Import all measures from [fivetran_measures.dax](fivetran_measures.dax)
4. Build all 5 dashboards from [POWERBI_GUIDE.md](../POWERBI_GUIDE.md)
5. Apply conditional formatting
6. Set up scheduled refresh
7. Publish to Power BI Service

**Result**: Complete analytics solution

---

### Path 3: Custom Development (Ongoing)
**Goal**: Customize for your specific needs

1. Start with Path 1 or 2
2. Reference [METRICS_CATALOG.md](METRICS_CATALOG.md) for additional measures
3. Create custom measures for your use cases
4. Add custom visuals and pages
5. Implement Row-Level Security if needed
6. Create mobile layouts

**Result**: Tailored solution for your organization

---

## ✅ Checklists

### Pre-Setup Checklist
- [ ] Power BI Desktop installed
- [ ] Snowflake credentials available
- [ ] dbt models successfully run
- [ ] Access to `FIVETRAN_ANALYTICS` schema verified
- [ ] Snowflake warehouse running

### Setup Checklist
- [ ] Connected to Snowflake
- [ ] Imported 5 fact tables
- [ ] Created Date table
- [ ] Set up relationships
- [ ] Imported DAX measures
- [ ] Built first dashboard
- [ ] Applied formatting
- [ ] Tested filters and interactions
- [ ] Saved .pbix file

### Post-Setup Checklist
- [ ] Published to Power BI Service
- [ ] Set up scheduled refresh
- [ ] Shared with stakeholders
- [ ] Created mobile layouts
- [ ] Set up data alerts
- [ ] Documented custom changes
- [ ] Trained users

---

## 🆘 Common Issues & Solutions

### Issue: Can't connect to Snowflake
**Solutions**:
- Verify account format: `account.region.snowflakecomputing.com`
- Check warehouse is running
- Verify schema access
- Try Microsoft Account authentication

### Issue: Measures show errors
**Solutions**:
- Check table/column names match your schema
- Verify relationships are set up
- Check for typos in formulas
- Ensure referenced columns exist

### Issue: Slow performance
**Solutions**:
- Switch to Import mode
- Reduce date range filters
- Create aggregated tables
- Remove unused columns

### Issue: Visuals not updating
**Solutions**:
- Check filter context
- Verify relationships are active
- Clear all filters
- Refresh data

---

## 📈 Next Steps After Setup

### Week 1
- [ ] Build Executive Overview dashboard
- [ ] Build Connector Health dashboard
- [ ] Share with initial stakeholders
- [ ] Gather feedback

### Week 2
- [ ] Build Cost & Usage dashboard
- [ ] Build Schema Change dashboard
- [ ] Build Error Monitoring dashboard
- [ ] Set up scheduled refresh

### Week 3
- [ ] Add conditional formatting
- [ ] Create drill-through pages
- [ ] Add bookmarks for different views
- [ ] Create mobile layouts

### Week 4
- [ ] Set up data alerts
- [ ] Implement Row-Level Security (if needed)
- [ ] Train users
- [ ] Document customizations

---

## 📧 Support & Resources

### Documentation
- **Quick Start**: [QUICK_START.md](QUICK_START.md)
- **Complete Guide**: [POWERBI_GUIDE.md](../POWERBI_GUIDE.md)
- **Measures**: [METRICS_CATALOG.md](METRICS_CATALOG.md)
- **DAX File**: [fivetran_measures.dax](fivetran_measures.dax)
- **Power Query**: [snowflake_import.pq](snowflake_import.pq)

### Contact
- **Email**: jason.chletsos@fivetran.com
- **GitHub**: Open an issue in the repository

### External Resources
- [Power BI Documentation](https://docs.microsoft.com/power-bi/)
- [DAX Reference](https://dax.guide/)
- [Power Query M Reference](https://docs.microsoft.com/powerquery-m/)
- [Snowflake Connector Docs](https://docs.microsoft.com/power-bi/connect-data/desktop-connect-snowflake)

---

## 📊 Summary Statistics

### Documentation
- **Total Files**: 6
- **Total Lines**: 2,100+
- **Total Measures**: 60+
- **Dashboard Templates**: 5
- **Power Query Scripts**: 6

### Time Estimates
- **Quick Start**: 30 minutes
- **Full Setup**: 2-3 hours
- **Custom Development**: Ongoing

### What You Get
- ✅ Complete setup guide
- ✅ 60+ ready-to-use DAX measures
- ✅ 6 Power Query import scripts
- ✅ 5 dashboard templates
- ✅ Design system & colors
- ✅ Troubleshooting guide
- ✅ Best practices

---

**Created**: November 2024  
**Last Updated**: November 2024  
**Version**: 1.0  
**Status**: Production Ready ✅
