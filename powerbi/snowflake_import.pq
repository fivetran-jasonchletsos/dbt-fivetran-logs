// ============================================================================
// FIVETRAN LOG ANALYTICS - POWER QUERY M SCRIPTS
// ============================================================================
// These are Power Query M scripts to import data from Snowflake
// Copy each section into Power BI Desktop > Get Data > Blank Query > Advanced Editor
// Replace placeholders with your actual values:
//   - YOUR_ACCOUNT: Your Snowflake account identifier
//   - YOUR_WAREHOUSE: Your Snowflake warehouse name
//   - YOUR_DATABASE: Your database name (likely same as account)
//   - FIVETRAN_ANALYTICS: Your schema name (default: FIVETRAN_ANALYTICS)
// ============================================================================

// ============================================================================
// QUERY 1: Connector Health
// ============================================================================
let
    Source = Snowflake.Databases(
        "YOUR_ACCOUNT.snowflakecomputing.com",
        "YOUR_WAREHOUSE",
        [Role="ACCOUNTADMIN"]
    ),
    Database = Source{[Name="YOUR_DATABASE"]}[Data],
    Schema = Database{[Name="FIVETRAN_ANALYTICS"]}[Data],
    Table = Schema{[Name="FCT_FIVETRAN_CONNECTOR_HEALTH"]}[Data],
    
    // Rename columns to friendly names
    RenamedColumns = Table.RenameColumns(Table,{
        {"CONNECTION_ID", "connection_id"},
        {"CONNECTION_NAME", "connection_name"},
        {"CONNECTOR_TYPE", "connector_type"},
        {"DESTINATION_ID", "destination_id"},
        {"LAST_SYNC_STARTED_AT", "last_sync_started_at"},
        {"LAST_SYNC_COMPLETED_AT", "last_sync_completed_at"},
        {"LAST_SYNC_STATUS", "last_sync_status"},
        {"SUCCESS_RATE_LAST_7D", "success_rate_last_7d"},
        {"SUCCESS_RATE_LAST_30D", "success_rate_last_30d"},
        {"AVG_SYNC_DURATION_MINUTES_7D", "avg_sync_duration_minutes_7d"},
        {"TOTAL_SYNCS_LAST_7D", "total_syncs_last_7d"},
        {"FAILED_SYNCS_LAST_7D", "failed_syncs_last_7d"},
        {"ROWS_SYNCED_LAST_7D", "rows_synced_last_7d"},
        {"IS_PAUSED", "is_paused"},
        {"HEALTH_STATUS", "health_status"}
    }),
    
    // Set data types
    TypedColumns = Table.TransformColumnTypes(RenamedColumns,{
        {"connection_id", type text},
        {"connection_name", type text},
        {"connector_type", type text},
        {"destination_id", type text},
        {"last_sync_started_at", type datetimezone},
        {"last_sync_completed_at", type datetimezone},
        {"last_sync_status", type text},
        {"success_rate_last_7d", type number},
        {"success_rate_last_30d", type number},
        {"avg_sync_duration_minutes_7d", type number},
        {"total_syncs_last_7d", Int64.Type},
        {"failed_syncs_last_7d", Int64.Type},
        {"rows_synced_last_7d", Int64.Type},
        {"is_paused", type logical},
        {"health_status", type text}
    })
in
    TypedColumns

// ============================================================================
// QUERY 2: Sync Performance
// ============================================================================
let
    Source = Snowflake.Databases(
        "YOUR_ACCOUNT.snowflakecomputing.com",
        "YOUR_WAREHOUSE",
        [Role="ACCOUNTADMIN"]
    ),
    Database = Source{[Name="YOUR_DATABASE"]}[Data],
    Schema = Database{[Name="FIVETRAN_ANALYTICS"]}[Data],
    Table = Schema{[Name="FCT_FIVETRAN_SYNC_PERFORMANCE"]}[Data],
    
    // Filter to last 90 days for performance
    FilteredRows = Table.SelectRows(Table, each [STARTED_AT] >= Date.AddDays(DateTime.LocalNow(), -90)),
    
    // Rename columns
    RenamedColumns = Table.RenameColumns(FilteredRows,{
        {"SYNC_ID", "sync_id"},
        {"CONNECTION_ID", "connection_id"},
        {"CONNECTION_NAME", "connection_name"},
        {"CONNECTOR_TYPE", "connector_type"},
        {"STARTED_AT", "started_at"},
        {"COMPLETED_AT", "completed_at"},
        {"SYNC_STATUS", "sync_status"},
        {"SYNC_DURATION_MINUTES", "sync_duration_minutes"},
        {"ROWS_SYNCED", "rows_synced"},
        {"ROWS_UPDATED_OR_INSERTED", "rows_updated_or_inserted"},
        {"TOTAL_ROWS_IN_TABLES", "total_rows_in_tables"},
        {"SCHEMA_NAME", "schema_name"},
        {"TABLE_NAME", "table_name"}
    }),
    
    // Set data types
    TypedColumns = Table.TransformColumnTypes(RenamedColumns,{
        {"sync_id", type text},
        {"connection_id", type text},
        {"connection_name", type text},
        {"connector_type", type text},
        {"started_at", type datetimezone},
        {"completed_at", type datetimezone},
        {"sync_status", type text},
        {"sync_duration_minutes", type number},
        {"rows_synced", Int64.Type},
        {"rows_updated_or_inserted", Int64.Type},
        {"total_rows_in_tables", Int64.Type},
        {"schema_name", type text},
        {"table_name", type text}
    })
in
    TypedColumns

// ============================================================================
// QUERY 3: Monthly Active Rows (MAR)
// ============================================================================
let
    Source = Snowflake.Databases(
        "YOUR_ACCOUNT.snowflakecomputing.com",
        "YOUR_WAREHOUSE",
        [Role="ACCOUNTADMIN"]
    ),
    Database = Source{[Name="YOUR_DATABASE"]}[Data],
    Schema = Database{[Name="FIVETRAN_ANALYTICS"]}[Data],
    Table = Schema{[Name="FCT_FIVETRAN_MONTHLY_ACTIVE_ROWS"]}[Data],
    
    // Rename columns
    RenamedColumns = Table.RenameColumns(Table,{
        {"CONNECTION_ID", "connection_id"},
        {"CONNECTION_NAME", "connection_name"},
        {"CONNECTOR_TYPE", "connector_type"},
        {"SCHEMA_NAME", "schema_name"},
        {"TABLE_NAME", "table_name"},
        {"MONTH_DATE", "month_date"},
        {"TOTAL_ACTIVE_ROWS", "total_active_rows"},
        {"PAID_ACTIVE_ROWS", "paid_active_rows"},
        {"FREE_ACTIVE_ROWS", "free_active_rows"}
    }),
    
    // Set data types
    TypedColumns = Table.TransformColumnTypes(RenamedColumns,{
        {"connection_id", type text},
        {"connection_name", type text},
        {"connector_type", type text},
        {"schema_name", type text},
        {"table_name", type text},
        {"month_date", type date},
        {"total_active_rows", Int64.Type},
        {"paid_active_rows", Int64.Type},
        {"free_active_rows", Int64.Type}
    })
in
    TypedColumns

// ============================================================================
// QUERY 4: Error Monitoring
// ============================================================================
let
    Source = Snowflake.Databases(
        "YOUR_ACCOUNT.snowflakecomputing.com",
        "YOUR_WAREHOUSE",
        [Role="ACCOUNTADMIN"]
    ),
    Database = Source{[Name="YOUR_DATABASE"]}[Data],
    Schema = Database{[Name="FIVETRAN_ANALYTICS"]}[Data],
    Table = Schema{[Name="FCT_FIVETRAN_ERROR_MONITORING"]}[Data],
    
    // Filter to last 30 days for performance
    FilteredRows = Table.SelectRows(Table, each [LOGGED_AT] >= Date.AddDays(DateTime.LocalNow(), -30)),
    
    // Rename columns
    RenamedColumns = Table.RenameColumns(FilteredRows,{
        {"ERROR_ID", "error_id"},
        {"CONNECTION_ID", "connection_id"},
        {"CONNECTION_NAME", "connection_name"},
        {"LOGGED_AT", "logged_at"},
        {"ERROR_MESSAGE", "error_message"},
        {"ERROR_TYPE", "error_type"},
        {"ERROR_CODE", "error_code"},
        {"SYNC_ID", "sync_id"},
        {"SCHEMA_NAME", "schema_name"},
        {"TABLE_NAME", "table_name"},
        {"IS_RECURRING_ERROR", "is_recurring_error"},
        {"OCCURRENCE_COUNT", "occurrence_count"},
        {"FIRST_OCCURRENCE_AT", "first_occurrence_at"},
        {"LAST_OCCURRENCE_AT", "last_occurrence_at"},
        {"RESOLUTION_TIME_HOURS", "resolution_time_hours"},
        {"ERROR_SEVERITY", "error_severity"}
    }),
    
    // Set data types
    TypedColumns = Table.TransformColumnTypes(RenamedColumns,{
        {"error_id", type text},
        {"connection_id", type text},
        {"connection_name", type text},
        {"logged_at", type datetimezone},
        {"error_message", type text},
        {"error_type", type text},
        {"error_code", type text},
        {"sync_id", type text},
        {"schema_name", type text},
        {"table_name", type text},
        {"is_recurring_error", type logical},
        {"occurrence_count", Int64.Type},
        {"first_occurrence_at", type datetimezone},
        {"last_occurrence_at", type datetimezone},
        {"resolution_time_hours", type number},
        {"error_severity", type text}
    })
in
    TypedColumns

// ============================================================================
// QUERY 5: Schema Change History
// ============================================================================
let
    Source = Snowflake.Databases(
        "YOUR_ACCOUNT.snowflakecomputing.com",
        "YOUR_WAREHOUSE",
        [Role="ACCOUNTADMIN"]
    ),
    Database = Source{[Name="YOUR_DATABASE"]}[Data],
    Schema = Database{[Name="FIVETRAN_ANALYTICS"]}[Data],
    Table = Schema{[Name="FCT_FIVETRAN_SCHEMA_CHANGE_HISTORY"]}[Data],
    
    // Filter to last 90 days
    FilteredRows = Table.SelectRows(Table, each [CHANGE_DETECTED_AT] >= Date.AddDays(DateTime.LocalNow(), -90)),
    
    // Rename columns
    RenamedColumns = Table.RenameColumns(FilteredRows,{
        {"CHANGE_ID", "change_id"},
        {"CONNECTION_ID", "connection_id"},
        {"CONNECTION_NAME", "connection_name"},
        {"CHANGE_DETECTED_AT", "change_detected_at"},
        {"SCHEMA_NAME", "schema_name"},
        {"TABLE_NAME", "table_name"},
        {"COLUMN_NAME", "column_name"},
        {"CHANGE_TYPE", "change_type"},
        {"OLD_VALUE", "old_value"},
        {"NEW_VALUE", "new_value"},
        {"IS_BREAKING_CHANGE", "is_breaking_change"},
        {"IMPACT_LEVEL", "impact_level"}
    }),
    
    // Set data types
    TypedColumns = Table.TransformColumnTypes(RenamedColumns,{
        {"change_id", type text},
        {"connection_id", type text},
        {"connection_name", type text},
        {"change_detected_at", type datetimezone},
        {"schema_name", type text},
        {"table_name", type text},
        {"column_name", type text},
        {"change_type", type text},
        {"old_value", type text},
        {"new_value", type text},
        {"is_breaking_change", type logical},
        {"impact_level", type text}
    })
in
    TypedColumns

// ============================================================================
// QUERY 6: Date Table (Calendar Dimension)
// ============================================================================
let
    // Create date range from 2020 to 3 years in future
    StartDate = #date(2020, 1, 1),
    EndDate = Date.AddYears(DateTime.Date(DateTime.LocalNow()), 3),
    DayCount = Duration.Days(EndDate - StartDate) + 1,
    DateList = List.Dates(StartDate, DayCount, #duration(1, 0, 0, 0)),
    
    // Convert to table
    TableFromList = Table.FromList(DateList, Splitter.SplitByNothing(), {"Date"}),
    
    // Change type
    ChangedType = Table.TransformColumnTypes(TableFromList,{{"Date", type date}}),
    
    // Add date attributes
    AddYear = Table.AddColumn(ChangedType, "Year", each Date.Year([Date]), Int64.Type),
    AddQuarter = Table.AddColumn(AddYear, "Quarter", each "Q" & Number.ToText(Date.QuarterOfYear([Date])), type text),
    AddMonth = Table.AddColumn(AddQuarter, "Month", each Date.Month([Date]), Int64.Type),
    AddMonthName = Table.AddColumn(AddMonth, "MonthName", each Date.MonthName([Date]), type text),
    AddMonthShort = Table.AddColumn(AddMonthName, "MonthShort", each Text.Start(Date.MonthName([Date]), 3), type text),
    AddWeek = Table.AddColumn(AddMonthShort, "WeekNum", each Date.WeekOfYear([Date]), Int64.Type),
    AddDayOfWeek = Table.AddColumn(AddWeek, "DayOfWeek", each Date.DayOfWeek([Date], Day.Monday) + 1, Int64.Type),
    AddDayName = Table.AddColumn(AddDayOfWeek, "DayName", each Date.DayOfWeekName([Date]), type text),
    AddDayShort = Table.AddColumn(AddDayName, "DayShort", each Text.Start(Date.DayOfWeekName([Date]), 3), type text),
    AddIsWeekend = Table.AddColumn(AddDayShort, "IsWeekend", each Date.DayOfWeek([Date], Day.Monday) >= 5, type logical),
    AddYearMonth = Table.AddColumn(AddIsWeekend, "YearMonth", each Date.ToText([Date], "yyyy-MM"), type text),
    AddYearQuarter = Table.AddColumn(AddYearMonth, "YearQuarter", each Number.ToText([Year]) & "-" & [Quarter], type text)
in
    AddYearQuarter

// ============================================================================
// INSTRUCTIONS FOR USE
// ============================================================================
// 
// 1. Open Power BI Desktop
// 2. Click "Get Data" > "Blank Query"
// 3. Open "Advanced Editor"
// 4. Copy and paste ONE of the queries above
// 5. Replace the following placeholders:
//    - YOUR_ACCOUNT: e.g., "abc12345.us-east-1"
//    - YOUR_WAREHOUSE: e.g., "COMPUTE_WH"
//    - YOUR_DATABASE: e.g., "FIVETRAN_DB"
//    - FIVETRAN_ANALYTICS: Your schema name (usually "FIVETRAN_ANALYTICS")
// 6. Click "Done"
// 7. Rename the query to match the table name
// 8. Repeat for all 6 queries
// 
// QUERY NAMES TO USE:
// - fct_fivetran_connector_health
// - fct_fivetran_sync_performance
// - fct_fivetran_monthly_active_rows
// - fct_fivetran_error_monitoring
// - fct_fivetran_schema_change_history
// - DateTable
//
// After importing all queries, go to Model view and set up relationships:
// - fct_fivetran_connector_health[connection_id] → Other fact tables (1:many)
// - DateTable[Date] → Fact tables date columns (1:many)
//
// ============================================================================
