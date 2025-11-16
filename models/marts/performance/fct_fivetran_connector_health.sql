{{ config(
    materialized = 'table'
) }}

with sync_performance as (
    select * from {{ ref('fct_fivetran_sync_performance') }}
),

-- Calculate last sync information
last_sync as (
    select
        connection_name,
        connector_name,
        destination_name,
        max(sync_end_time) as last_sync_at,
        max(case when sync_status = 'success' then sync_end_time else null end) as last_successful_sync_at,
        max(case when sync_status = 'error' then sync_end_time else null end) as last_error_sync_at
    from sync_performance
    group by 1, 2, 3
),

-- Calculate sync status
sync_status as (
    select
        ls.connection_name,
        ls.connector_name,
        ls.destination_name,
        ls.last_sync_at,
        ls.last_successful_sync_at,
        ls.last_error_sync_at,
        case
            when ls.last_sync_at = ls.last_successful_sync_at then 'success'
            when ls.last_sync_at = ls.last_error_sync_at then 'error'
            else 'unknown'
        end as last_sync_status
    from last_sync ls
),

-- Calculate sync metrics for all time
sync_metrics as (
    select
        connection_name,
        connector_name,
        count(*) as total_syncs,
        sum(case when sync_status = 'success' then 1 else 0 end) as successful_syncs,
        sum(case when sync_status = 'error' then 1 else 0 end) as failed_syncs,
        avg(sync_duration_seconds) as avg_sync_duration_seconds,
        max(sync_duration_seconds) as max_sync_duration_seconds
    from sync_performance
    group by 1, 2
),

-- Calculate recent sync metrics (last 7 days if data exists)
recent_sync_metrics as (
    select
        connection_name,
        connector_name,
        count(*) as total_syncs_last_7d,
        sum(case when sync_status = 'success' then 1 else 0 end) as successful_syncs_last_7d,
        sum(case when sync_status = 'error' then 1 else 0 end) as failed_syncs_last_7d,
        case 
            when count(*) > 0 then 
                (sum(case when sync_status = 'success' then 1 else 0 end) / nullif(count(*), 0)) * 100 
            else null 
        end as success_rate_last_7d
    from sync_performance
    where sync_date >= dateadd(day, -7, current_date())
    group by 1, 2
),

-- Combine all metrics
connector_health as (
    select
        ss.connection_name,
        ss.connector_name,
        ss.destination_name,
        ss.last_sync_at,
        ss.last_successful_sync_at,
        ss.last_error_sync_at,
        ss.last_sync_status,
        coalesce(sm.total_syncs, 0) as total_syncs,
        coalesce(sm.successful_syncs, 0) as successful_syncs,
        coalesce(sm.failed_syncs, 0) as failed_syncs,
        sm.avg_sync_duration_seconds,
        sm.max_sync_duration_seconds,
        coalesce(rsm.total_syncs_last_7d, 0) as total_syncs_last_7d,
        coalesce(rsm.successful_syncs_last_7d, 0) as successful_syncs_last_7d,
        coalesce(rsm.failed_syncs_last_7d, 0) as failed_syncs_last_7d,
        coalesce(rsm.success_rate_last_7d, 
            case 
                when sm.total_syncs > 0 then 
                    (sm.successful_syncs / nullif(sm.total_syncs, 0)) * 100 
                else null 
            end
        ) as success_rate_last_7d
    from sync_status ss
    left join sync_metrics sm on ss.connection_name = sm.connection_name and ss.connector_name = sm.connector_name
    left join recent_sync_metrics rsm on ss.connection_name = rsm.connection_name and ss.connector_name = rsm.connector_name
)

select * from connector_health