-- =============================================
-- Row Counts for All Tables and Views
-- =============================================

-- Source Tables
SELECT 'Source: connection' as table_name, COUNT(*) as row_count FROM JASON_CHLETSOS.JASON_CHLETSOS_FIVETRAN_LOG.connection
UNION ALL
SELECT 'Source: connector_type' as table_name, COUNT(*) as row_count FROM JASON_CHLETSOS.JASON_CHLETSOS_FIVETRAN_LOG.connector_type
UNION ALL
SELECT 'Source: destination' as table_name, COUNT(*) as row_count FROM JASON_CHLETSOS.JASON_CHLETSOS_FIVETRAN_LOG.destination
UNION ALL
SELECT 'Source: log' as table_name, COUNT(*) as row_count FROM JASON_CHLETSOS.JASON_CHLETSOS_FIVETRAN_LOG.log
UNION ALL
SELECT 'Source: incremental_mar' as table_name, COUNT(*) as row_count FROM JASON_CHLETSOS.JASON_CHLETSOS_FIVETRAN_LOG.incremental_mar
UNION ALL
SELECT 'Source: transformation_runs' as table_name, COUNT(*) as row_count FROM JASON_CHLETSOS.JASON_CHLETSOS_FIVETRAN_LOG.transformation_runs
UNION ALL
SELECT 'Source: user' as table_name, COUNT(*) as row_count FROM JASON_CHLETSOS.JASON_CHLETSOS_FIVETRAN_LOG.user

UNION ALL

-- Staging Views
SELECT 'Staging: stg_fivetran_log__connection' as table_name, COUNT(*) as row_count FROM JASON_CHLETSOS.stg_fivetran_log.stg_fivetran_log__connection
UNION ALL
SELECT 'Staging: stg_fivetran_log__connector_type' as table_name, COUNT(*) as row_count FROM JASON_CHLETSOS.stg_fivetran_log.stg_fivetran_log__connector_type
UNION ALL
SELECT 'Staging: stg_fivetran_log__destination' as table_name, COUNT(*) as row_count FROM JASON_CHLETSOS.stg_fivetran_log.stg_fivetran_log__destination
UNION ALL
SELECT 'Staging: stg_fivetran_log__log' as table_name, COUNT(*) as row_count FROM JASON_CHLETSOS.stg_fivetran_log.stg_fivetran_log__log
UNION ALL
SELECT 'Staging: stg_fivetran_log__incremental_mar' as table_name, COUNT(*) as row_count FROM JASON_CHLETSOS.stg_fivetran_log.stg_fivetran_log__incremental_mar
UNION ALL
SELECT 'Staging: stg_fivetran_log__transformation_runs' as table_name, COUNT(*) as row_count FROM JASON_CHLETSOS.stg_fivetran_log.stg_fivetran_log__transformation_runs
UNION ALL
SELECT 'Staging: stg_fivetran_log__user' as table_name, COUNT(*) as row_count FROM JASON_CHLETSOS.stg_fivetran_log.stg_fivetran_log__user

UNION ALL

-- Intermediate Views
SELECT 'Intermediate: int_fivetran_log__connector_details' as table_name, COUNT(*) as row_count FROM JASON_CHLETSOS.int_fivetran_log.int_fivetran_log__connector_details
UNION ALL
SELECT 'Intermediate: int_fivetran_log__sync_events' as table_name, COUNT(*) as row_count FROM JASON_CHLETSOS.int_fivetran_log.int_fivetran_log__sync_events
UNION ALL
SELECT 'Intermediate: int_fivetran_log__daily_api_calls' as table_name, COUNT(*) as row_count FROM JASON_CHLETSOS.int_fivetran_log.int_fivetran_log__daily_api_calls
UNION ALL
SELECT 'Intermediate: int_fivetran_log__daily_active_rows' as table_name, COUNT(*) as row_count FROM JASON_CHLETSOS.int_fivetran_log.int_fivetran_log__daily_active_rows

UNION ALL

-- Mart Tables
SELECT 'Mart: fct_fivetran_connector_health' as table_name, COUNT(*) as row_count FROM JASON_CHLETSOS.fivetran_analytics.fct_fivetran_connector_health
UNION ALL
SELECT 'Mart: fct_fivetran_monthly_active_rows' as table_name, COUNT(*) as row_count FROM JASON_CHLETSOS.fivetran_analytics.fct_fivetran_monthly_active_rows
UNION ALL
SELECT 'Mart: fct_fivetran_connector_recommendations' as table_name, COUNT(*) as row_count FROM JASON_CHLETSOS.fivetran_analytics.fct_fivetran_connector_recommendations
UNION ALL
SELECT 'Mart: fct_fivetran_executive_dashboard' as table_name, COUNT(*) as row_count FROM JASON_CHLETSOS.fivetran_analytics.fct_fivetran_executive_dashboard
UNION ALL
SELECT 'Mart: fct_fivetran_error_monitoring' as table_name, COUNT(*) as row_count FROM JASON_CHLETSOS.fivetran_analytics.fct_fivetran_error_monitoring
UNION ALL
SELECT 'Mart: fct_fivetran_sync_performance' as table_name, COUNT(*) as row_count FROM JASON_CHLETSOS.fivetran_analytics.fct_fivetran_sync_performance

ORDER BY row_count DESC;