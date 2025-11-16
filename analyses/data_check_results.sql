-- Check if fact tables now have data
SELECT 'fct_fivetran_connector_health' as table_name, COUNT(*) as row_count FROM fivetran_analytics_fivetran_analytics.fct_fivetran_connector_health;
SELECT 'fct_fivetran_monthly_active_rows' as table_name, COUNT(*) as row_count FROM fivetran_analytics_fivetran_analytics.fct_fivetran_monthly_active_rows;
SELECT 'fct_fivetran_connector_recommendations' as table_name, COUNT(*) as row_count FROM fivetran_analytics_fivetran_analytics.fct_fivetran_connector_recommendations;
SELECT 'fct_fivetran_executive_dashboard' as table_name, COUNT(*) as row_count FROM fivetran_analytics_fivetran_analytics.fct_fivetran_executive_dashboard;
SELECT 'fct_fivetran_error_monitoring' as table_name, COUNT(*) as row_count FROM fivetran_analytics_fivetran_analytics.fct_fivetran_error_monitoring;

-- Check sample data from each table
SELECT * FROM fivetran_analytics_fivetran_analytics.fct_fivetran_connector_health LIMIT 5;
SELECT * FROM fivetran_analytics_fivetran_analytics.fct_fivetran_monthly_active_rows LIMIT 5;
SELECT * FROM fivetran_analytics_fivetran_analytics.fct_fivetran_connector_recommendations LIMIT 5;
SELECT * FROM fivetran_analytics_fivetran_analytics.fct_fivetran_executive_dashboard LIMIT 5;
SELECT * FROM fivetran_analytics_fivetran_analytics.fct_fivetran_error_monitoring LIMIT 5;