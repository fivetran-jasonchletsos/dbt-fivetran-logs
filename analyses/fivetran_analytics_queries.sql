-- =============================================
-- Fivetran Analytics SQL Worksheet
-- =============================================
-- This worksheet contains queries for exploring the Fivetran analytics models
-- You can run individual queries by selecting them and clicking "Run"

-- =============================================
-- 1. EXECUTIVE DASHBOARD
-- =============================================
-- Overview of key metrics for executive reporting
SELECT
    report_date,
    total_connectors,
    healthy_connectors,
    failing_connectors,
    connector_health_percentage,
    total_active_rows,
    paid_active_rows,
    free_active_rows,
    total_errors,
    connectors_with_errors,
    connectors_with_recurring_errors
FROM fivetran_analytics_fivetran_analytics.fct_fivetran_executive_dashboard
ORDER BY report_date DESC
LIMIT 10;

-- =============================================
-- 2. CONNECTOR HEALTH
-- =============================================
-- Health metrics for all connectors
SELECT
    connection_name,
    connector_name,
    destination_name,
    last_sync_at,
    last_sync_status,
    avg_sync_duration_seconds,
    total_syncs_last_7d,
    failed_syncs_last_7d,
    success_rate_last_7d
FROM fivetran_analytics_fivetran_analytics.fct_fivetran_connector_health
ORDER BY success_rate_last_7d ASC, total_syncs_last_7d DESC;

-- =============================================
-- 3. MONTHLY ACTIVE ROWS
-- =============================================
-- Active rows by connector, schema, and table
SELECT
    month_date,
    connection_name,
    connector_name,
    schema_name,
    table_name,
    free_active_rows,
    paid_active_rows,
    total_active_rows
FROM fivetran_analytics_fivetran_analytics.fct_fivetran_monthly_active_rows
WHERE total_active_rows > 0
ORDER BY month_date DESC, total_active_rows DESC;

-- Top tables by active rows
SELECT
    connection_name,
    schema_name,
    table_name,
    SUM(total_active_rows) AS total_active_rows
FROM fivetran_analytics_fivetran_analytics.fct_fivetran_monthly_active_rows
WHERE month_date = (SELECT MAX(month_date) FROM fivetran_analytics_fivetran_analytics.fct_fivetran_monthly_active_rows)
GROUP BY 1, 2, 3
ORDER BY 4 DESC
LIMIT 20;

-- =============================================
-- 4. SYNC PERFORMANCE
-- =============================================
-- Recent sync performance
SELECT
    sync_id,
    connection_name,
    connector_name,
    sync_start_time,
    sync_end_time,
    sync_status,
    sync_duration_seconds,
    rows_synced
FROM fivetran_analytics_fivetran_analytics.fct_fivetran_sync_performance
ORDER BY sync_start_time DESC
LIMIT 100;

-- Longest running syncs
SELECT
    connection_name,
    connector_name,
    AVG(sync_duration_seconds) AS avg_duration,
    MAX(sync_duration_seconds) AS max_duration,
    COUNT(*) AS sync_count
FROM fivetran_analytics_fivetran_analytics.fct_fivetran_sync_performance
WHERE sync_date >= DATEADD(day, -30, CURRENT_DATE())
GROUP BY 1, 2
HAVING COUNT(*) > 5
ORDER BY avg_duration DESC
LIMIT 20;

-- =============================================
-- 5. ERROR MONITORING
-- =============================================
-- Recent errors
SELECT
    sync_id,
    connection_name,
    connector_name,
    sync_start_time,
    error_type,
    error_message,
    is_recurring_error
FROM fivetran_analytics_fivetran_analytics.fct_fivetran_error_monitoring
ORDER BY sync_start_time DESC
LIMIT 50;

-- Error types by frequency
SELECT
    error_type,
    COUNT(*) AS error_count,
    COUNT(DISTINCT connection_name) AS affected_connectors,
    SUM(CASE WHEN is_recurring_error THEN 1 ELSE 0 END) AS recurring_errors
FROM fivetran_analytics_fivetran_analytics.fct_fivetran_error_monitoring
WHERE sync_start_time >= DATEADD(day, -30, CURRENT_DATE())
GROUP BY 1
ORDER BY 2 DESC;

-- =============================================
-- 6. PROBLEMATIC CONNECTORS
-- =============================================
-- Connectors that need attention
SELECT
    connection_name,
    connector_name,
    problem_score,
    problem_severity,
    error_syncs,
    error_rate,
    recurring_error_count,
    primary_recommendation
FROM fivetran_analytics_fivetran_analytics.fct_fivetran_problematic_connectors
WHERE problem_severity IN ('Critical', 'High')
ORDER BY problem_score DESC;

-- =============================================
-- 7. API USAGE
-- =============================================
-- Daily API usage
SELECT
    date_day,
    connection_name,
    connector_name,
    api_calls_count
FROM fivetran_analytics_fivetran_analytics.fct_fivetran_daily_api_usage
ORDER BY date_day DESC, api_calls_count DESC;

-- API usage by connector (last 30 days)
SELECT
    connection_name,
    connector_name,
    SUM(api_calls_count) AS total_api_calls,
    AVG(api_calls_count) AS avg_daily_api_calls,
    MAX(api_calls_count) AS max_daily_api_calls
FROM fivetran_analytics_fivetran_analytics.fct_fivetran_daily_api_usage
WHERE date_day >= DATEADD(day, -30, CURRENT_DATE())
GROUP BY 1, 2
ORDER BY 3 DESC
LIMIT 20;

-- =============================================
-- 8. SCHEMA CHANGES
-- =============================================
-- Recent schema changes
SELECT
    change_detected_at,
    connection_name,
    schema_name,
    table_name,
    change_type,
    column_name,
    previous_data_type,
    new_data_type
FROM fivetran_analytics_fivetran_analytics.fct_fivetran_schema_change_history
ORDER BY change_detected_at DESC
LIMIT 100;

-- Schema changes by type
SELECT
    change_type,
    COUNT(*) AS change_count,
    COUNT(DISTINCT connection_name) AS affected_connectors,
    MIN(change_detected_at) AS first_detected,
    MAX(change_detected_at) AS last_detected
FROM fivetran_analytics_fivetran_analytics.fct_fivetran_schema_change_history
GROUP BY 1
ORDER BY 2 DESC;

-- =============================================
-- 9. USER ACTIVITY
-- =============================================
-- Recent user activity
SELECT
    activity_date,
    user_email,
    user_name,
    action_type,
    resource_type,
    resource_name,
    activity_count
FROM fivetran_analytics_fivetran_analytics.fct_fivetran_user_activity
ORDER BY activity_date DESC, activity_count DESC
LIMIT 100;

-- Activity by user
SELECT
    user_email,
    user_name,
    SUM(activity_count) AS total_activities,
    COUNT(DISTINCT action_type) AS distinct_actions,
    COUNT(DISTINCT resource_type) AS distinct_resources,
    MAX(activity_date) AS last_activity_date
FROM fivetran_analytics_fivetran_analytics.fct_fivetran_user_activity
GROUP BY 1, 2
ORDER BY 3 DESC;

-- =============================================
-- 10. OPTIMIZATION RECOMMENDATIONS
-- =============================================
-- All recommendations
SELECT
    connection_name,
    connector_name,
    recommendation_score,
    recommendation_priority,
    primary_recommendation,
    avg_syncs_per_day,
    total_active_rows,
    avg_sync_duration_seconds
FROM fivetran_analytics_fivetran_analytics.fct_fivetran_connector_recommendations
ORDER BY recommendation_score DESC;

-- High priority recommendations
SELECT
    connection_name,
    connector_name,
    primary_recommendation,
    recommendation_priority,
    last_sync_status,
    last_sync_at,
    avg_sync_duration_seconds,
    avg_syncs_per_day
FROM fivetran_analytics_fivetran_analytics.fct_fivetran_connector_recommendations
WHERE recommendation_priority IN ('Critical', 'High')
ORDER BY recommendation_score DESC;