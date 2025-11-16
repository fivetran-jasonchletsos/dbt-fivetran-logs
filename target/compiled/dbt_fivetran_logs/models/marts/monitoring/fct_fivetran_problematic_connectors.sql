

with sync_performance as (
    select * from JASON_CHLETSOS.fivetran_analytics_fct_fivetran_logs.fct_fivetran_sync_performance
),

error_monitoring as (
    select * from JASON_CHLETSOS.fivetran_analytics_fct_fivetran_logs.fct_fivetran_error_monitoring
),

-- Calculate error metrics by connector
connector_error_metrics as (
    select
        connection_name,
        connector_name,
        destination_name,
        count(*) as total_syncs,
        sum(case when sync_status = 'error' then 1 else 0 end) as error_syncs,
        sum(case when sync_status = 'success' then 1 else 0 end) as successful_syncs,
        (sum(case when sync_status = 'error' then 1 else 0 end) / nullif(count(*), 0)) * 100 as error_rate,
        avg(sync_duration_seconds) as avg_sync_duration,
        max(sync_duration_seconds) as max_sync_duration
    from sync_performance
    where sync_date >= dateadd(day, -30, current_date())
    group by 1, 2, 3
),

-- Get recurring error information
recurring_error_counts as (
    select
        connection_name,
        connector_name,
        count(*) as recurring_error_count,
        count(distinct error_type) as distinct_error_types,
        max(sync_start_time) as last_error_time
    from error_monitoring
    where is_recurring_error = true
    group by 1, 2
),

-- Calculate a problem score based on multiple factors
problematic_connectors as (
    select
        cem.connection_name,
        cem.connector_name,
        cem.destination_name,
        cem.total_syncs,
        cem.error_syncs,
        cem.successful_syncs,
        cem.error_rate,
        cem.avg_sync_duration,
        cem.max_sync_duration,
        coalesce(rec.recurring_error_count, 0) as recurring_error_count,
        coalesce(rec.distinct_error_types, 0) as distinct_error_types,
        rec.last_error_time,
        -- Calculate a problem score (higher is worse)
        (cem.error_rate * 0.5) + 
        (coalesce(rec.recurring_error_count, 0) * 10) +
        (coalesce(rec.distinct_error_types, 0) * 5) +
        (case when rec.last_error_time is not null and rec.last_error_time >= dateadd(day, -1, current_timestamp()) then 20 else 0 end) as problem_score
    from connector_error_metrics cem
    left join recurring_error_counts rec 
        on cem.connection_name = rec.connection_name
        and cem.connector_name = rec.connector_name
)

select 
    *,
    case
        when problem_score >= 50 then 'Critical'
        when problem_score >= 30 then 'High'
        when problem_score >= 10 then 'Medium'
        else 'Low'
    end as problem_severity
from problematic_connectors
order by problem_score desc