-- =============================================
-- Fivetran Data Check Queries
-- =============================================
-- These queries help diagnose why the fact tables are empty
-- by examining data at each stage of the pipeline

-- =============================================
-- 1. CHECK SOURCE DATA
-- =============================================
-- Check if source tables have data
SELECT 'connection' as table_name, COUNT(*) as row_count FROM JASON_CHLETSOS.JASON_CHLETSOS_FIVETRAN_LOG.connection
UNION ALL
SELECT 'connector_type' as table_name, COUNT(*) as row_count FROM JASON_CHLETSOS.JASON_CHLETSOS_FIVETRAN_LOG.connector_type
UNION ALL
SELECT 'destination' as table_name, COUNT(*) as row_count FROM JASON_CHLETSOS.JASON_CHLETSOS_FIVETRAN_LOG.destination
UNION ALL
SELECT 'log' as table_name, COUNT(*) as row_count FROM JASON_CHLETSOS.JASON_CHLETSOS_FIVETRAN_LOG.log
UNION ALL
SELECT 'incremental_mar' as table_name, COUNT(*) as row_count FROM JASON_CHLETSOS.JASON_CHLETSOS_FIVETRAN_LOG.incremental_mar
UNION ALL
SELECT 'transformation_runs' as table_name, COUNT(*) as row_count FROM JASON_CHLETSOS.JASON_CHLETSOS_FIVETRAN_LOG.transformation_runs
UNION ALL
SELECT 'user' as table_name, COUNT(*) as row_count FROM JASON_CHLETSOS.JASON_CHLETSOS_FIVETRAN_LOG.user
ORDER BY row_count DESC;

-- =============================================
-- 2. CHECK STAGING VIEWS
-- =============================================
-- Check if staging views have data
SELECT 'stg_fivetran_log__connection' as view_name, COUNT(*) as row_count FROM fivetran_analytics_stg_fivetran_log.stg_fivetran_log__connection
UNION ALL
SELECT 'stg_fivetran_log__connector_type' as view_name, COUNT(*) as row_count FROM fivetran_analytics_stg_fivetran_log.stg_fivetran_log__connector_type
UNION ALL
SELECT 'stg_fivetran_log__destination' as view_name, COUNT(*) as row_count FROM fivetran_analytics_stg_fivetran_log.stg_fivetran_log__destination
UNION ALL
SELECT 'stg_fivetran_log__log' as view_name, COUNT(*) as row_count FROM fivetran_analytics_stg_fivetran_log.stg_fivetran_log__log
UNION ALL
SELECT 'stg_fivetran_log__incremental_mar' as view_name, COUNT(*) as row_count FROM fivetran_analytics_stg_fivetran_log.stg_fivetran_log__incremental_mar
UNION ALL
SELECT 'stg_fivetran_log__transformation_runs' as view_name, COUNT(*) as row_count FROM fivetran_analytics_stg_fivetran_log.stg_fivetran_log__transformation_runs
UNION ALL
SELECT 'stg_fivetran_log__user' as view_name, COUNT(*) as row_count FROM fivetran_analytics_stg_fivetran_log.stg_fivetran_log__user
ORDER BY row_count DESC;

-- =============================================
-- 3. CHECK INTERMEDIATE VIEWS
-- =============================================
-- Check if intermediate views have data
SELECT 'int_fivetran_log__connector_details' as view_name, COUNT(*) as row_count FROM fivetran_analytics_int_fivetran_log.int_fivetran_log__connector_details
UNION ALL
SELECT 'int_fivetran_log__sync_events' as view_name, COUNT(*) as row_count FROM fivetran_analytics_int_fivetran_log.int_fivetran_log__sync_events
UNION ALL
SELECT 'int_fivetran_log__daily_api_calls' as view_name, COUNT(*) as row_count FROM fivetran_analytics_int_fivetran_log.int_fivetran_log__daily_api_calls
UNION ALL
SELECT 'int_fivetran_log__daily_active_rows' as view_name, COUNT(*) as row_count FROM fivetran_analytics_int_fivetran_log.int_fivetran_log__daily_active_rows
ORDER BY row_count DESC;

-- =============================================
-- 4. CHECK SYNC PERFORMANCE DATA
-- =============================================
-- Check if sync_performance has data without date filters
SELECT 
    COUNT(*) as total_syncs,
    MIN(sync_start_time) as earliest_sync,
    MAX(sync_start_time) as latest_sync,
    COUNT(DISTINCT connection_name) as connection_count,
    SUM(CASE WHEN sync_status = 'success' THEN 1 ELSE 0 END) as successful_syncs,
    SUM(CASE WHEN sync_status = 'error' THEN 1 ELSE 0 END) as failed_syncs
FROM fivetran_analytics_fivetran_analytics.fct_fivetran_sync_performance;

-- Check date ranges to see if filters are excluding data
SELECT 
    MIN(sync_date) as earliest_date,
    MAX(sync_date) as latest_date,
    CURRENT_DATE() as today,
    DATEADD(day, -7, CURRENT_DATE()) as seven_days_ago,
    DATEADD(day, -30, CURRENT_DATE()) as thirty_days_ago
FROM fivetran_analytics_fivetran_analytics.fct_fivetran_sync_performance;

-- =============================================
-- 5. CHECK CONNECTOR HEALTH COMPONENTS
-- =============================================
-- Check the CTEs that make up the connector health model
-- Last sync information
SELECT 
    COUNT(*) as sync_count,
    COUNT(DISTINCT connection_name) as connection_count
FROM fivetran_analytics_fivetran_analytics.fct_fivetran_sync_performance;

-- Check if there are any recent syncs (last 7 days)
SELECT 
    COUNT(*) as recent_sync_count,
    COUNT(DISTINCT connection_name) as connection_count
FROM fivetran_analytics_fivetran_analytics.fct_fivetran_sync_performance
WHERE sync_date >= DATEADD(day, -7, CURRENT_DATE());

-- =============================================
-- 6. CHECK MONTHLY ACTIVE ROWS
-- =============================================
-- Check if MAR data exists and its date range
SELECT 
    COUNT(*) as total_rows,
    MIN(month_date) as earliest_month,
    MAX(month_date) as latest_month,
    COUNT(DISTINCT connection_name) as connection_count,
    SUM(total_active_rows) as total_active_rows
FROM fivetran_analytics_fivetran_analytics.fct_fivetran_monthly_active_rows;

-- =============================================
-- 7. SOLUTION: MODIFY MODELS TO REMOVE DATE FILTERS
-- =============================================
-- If the issue is date filtering, you can temporarily modify the models
-- Here's an example of how to modify fct_fivetran_connector_health:

-- WITH sync_performance as (
--     select * from {{ ref('fct_fivetran_sync_performance') }}
--     -- Remove the date filter to include all data
-- ),
--
-- -- Calculate last sync information
-- last_sync as (
--     select
--         connection_name,
--         connector_name,
--         destination_name,
--         max(sync_end_time) as last_sync_at
--     from sync_performance
--     group by 1, 2, 3
-- ),
-- ...

-- =============================================
-- 8. CHECK LOG DATA FOR ERRORS
-- =============================================
-- Check if there are any error logs
SELECT 
    COUNT(*) as error_count,
    COUNT(DISTINCT connection_id) as connection_count
FROM fivetran_analytics_stg_fivetran_log.stg_fivetran_log__log
WHERE event_type = 'error';

-- =============================================
-- 9. CHECK SCHEMA CHANGES
-- =============================================
-- Check if there are any schema change events
SELECT 
    COUNT(*) as schema_change_count,
    COUNT(DISTINCT connection_id) as connection_count
FROM fivetran_analytics_stg_fivetran_log.stg_fivetran_log__log
WHERE event_type = 'schema_change';

-- =============================================
-- 10. CHECK USER ACTIVITY
-- =============================================
-- Check if there are any user activity events
SELECT 
    COUNT(*) as activity_count,
    COUNT(DISTINCT connection_id) as connection_count
FROM fivetran_analytics_stg_fivetran_log.stg_fivetran_log__log
WHERE event_type IN ('user_action', 'account_modification', 'setup');