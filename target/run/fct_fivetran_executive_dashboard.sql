
  
    

create or replace transient  table JASON_CHLETSOS.fivetran_analytics_fivetran_analytics.fct_fivetran_executive_dashboard
    
    
    
    as (

with connector_health as (
    select * from JASON_CHLETSOS.fivetran_analytics_fivetran_analytics.fct_fivetran_connector_health
),

monthly_active_rows as (
    select * from JASON_CHLETSOS.fivetran_analytics_fivetran_analytics.fct_fivetran_monthly_active_rows
),

error_monitoring as (
    select * from JASON_CHLETSOS.fivetran_analytics_fivetran_analytics.fct_fivetran_error_monitoring
    -- Remove date filter to include all data
),

-- Calculate connector health metrics
connector_health_metrics as (
    select
        current_date() as report_date,
        count(distinct connection_name) as total_connectors,
        sum(case when last_sync_status = 'success' then 1 else 0 end) as healthy_connectors,
        sum(case when last_sync_status = 'error' then 1 else 0 end) as failing_connectors,
        (sum(case when last_sync_status = 'success' then 1 else 0 end) / 
         nullif(count(distinct connection_name), 0)) * 100 as connector_health_percentage
    from connector_health
),

-- Calculate active rows metrics
active_rows_metrics as (
    select
        current_date() as report_date,
        sum(total_active_rows) as total_active_rows,
        sum(paid_active_rows) as paid_active_rows,
        sum(free_active_rows) as free_active_rows
    from monthly_active_rows
    -- Use the most recent month if available
    where month_date = (select max(month_date) from monthly_active_rows)
),

-- Calculate error metrics
error_metrics as (
    select
        current_date() as report_date,
        count(*) as total_errors,
        count(distinct connection_name) as connectors_with_errors,
        count(distinct case when is_recurring_error then connection_name else null end) as connectors_with_recurring_errors
    from error_monitoring
),

-- Combine all metrics
executive_dashboard as (
    select
        chm.report_date,
        chm.total_connectors,
        chm.healthy_connectors,
        chm.failing_connectors,
        chm.connector_health_percentage,
        coalesce(arm.total_active_rows, 0) as total_active_rows,
        coalesce(arm.paid_active_rows, 0) as paid_active_rows,
        coalesce(arm.free_active_rows, 0) as free_active_rows,
        coalesce(em.total_errors, 0) as total_errors,
        coalesce(em.connectors_with_errors, 0) as connectors_with_errors,
        coalesce(em.connectors_with_recurring_errors, 0) as connectors_with_recurring_errors
    from connector_health_metrics chm
    left join active_rows_metrics arm on chm.report_date = arm.report_date
    left join error_metrics em on chm.report_date = em.report_date
)

select * from executive_dashboard
    )
;


  