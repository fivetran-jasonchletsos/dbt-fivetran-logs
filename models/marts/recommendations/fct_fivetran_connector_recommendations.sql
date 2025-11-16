{{ config(
    materialized = 'table'
) }}

with connector_health as (
    select * from {{ ref('fct_fivetran_connector_health') }}
),

monthly_active_rows as (
    select * from {{ ref('fct_fivetran_monthly_active_rows') }}
    where month_date = (select max(month_date) from {{ ref('fct_fivetran_monthly_active_rows') }})
),

-- Calculate connector metrics
connector_metrics as (
    select
        ch.connection_name,
        ch.connector_name,
        ch.destination_name,
        ch.last_sync_at,
        ch.last_sync_status,
        ch.total_syncs,
        ch.successful_syncs,
        ch.failed_syncs,
        ch.avg_sync_duration_seconds,
        ch.total_syncs_last_7d,
        ch.failed_syncs_last_7d,
        ch.success_rate_last_7d,
        case
            when ch.total_syncs > 0 then ch.total_syncs / nullif(datediff(day, date_trunc('day', ch.last_sync_at), current_date()), 0)
            else 0
        end as avg_syncs_per_day
    from connector_health ch
),

-- Calculate active rows by connector
connector_active_rows as (
    select
        connection_name,
        sum(total_active_rows) as total_active_rows,
        sum(free_active_rows) as free_active_rows,
        sum(paid_active_rows) as paid_active_rows
    from monthly_active_rows
    group by 1
),

-- Generate recommendations
connector_recommendations as (
    select
        cm.connection_name,
        cm.connector_name,
        cm.destination_name,
        cm.last_sync_at,
        cm.last_sync_status,
        cm.total_syncs,
        cm.successful_syncs,
        cm.failed_syncs,
        cm.avg_sync_duration_seconds,
        cm.avg_syncs_per_day,
        coalesce(car.total_active_rows, 0) as total_active_rows,
        coalesce(car.free_active_rows, 0) as free_active_rows,
        coalesce(car.paid_active_rows, 0) as paid_active_rows,
        
        -- Calculate recommendation score (higher = more important to address)
        case
            when cm.last_sync_status = 'error' then 100
            when cm.success_rate_last_7d < 50 then 90
            when cm.success_rate_last_7d < 80 then 70
            when cm.avg_sync_duration_seconds > 3600 then 60
            when cm.avg_syncs_per_day > 24 then 50
            when cm.avg_syncs_per_day < 1 and coalesce(car.total_active_rows, 0) = 0 then 40
            else 0
        end as recommendation_score,
        
        -- Determine recommendation priority
        case
            when cm.last_sync_status = 'error' then 'Critical'
            when cm.success_rate_last_7d < 50 then 'High'
            when cm.success_rate_last_7d < 80 then 'Medium'
            when cm.avg_sync_duration_seconds > 3600 then 'Medium'
            when cm.avg_syncs_per_day > 24 then 'Medium'
            when cm.avg_syncs_per_day < 1 and coalesce(car.total_active_rows, 0) = 0 then 'Low'
            else 'None'
        end as recommendation_priority,
        
        -- Generate primary recommendation
        case
            when cm.last_sync_status = 'error' then 'Fix failing connector'
            when cm.success_rate_last_7d < 50 then 'Investigate frequent failures'
            when cm.success_rate_last_7d < 80 then 'Address intermittent failures'
            when cm.avg_sync_duration_seconds > 3600 then 'Optimize long-running syncs'
            when cm.avg_syncs_per_day > 24 then 'Reduce sync frequency'
            when cm.avg_syncs_per_day < 1 and coalesce(car.total_active_rows, 0) = 0 then 'Consider removing unused connector'
            else 'No action needed'
        end as primary_recommendation
        
    from connector_metrics cm
    left join connector_active_rows car on cm.connection_name = car.connection_name
)

select * from connector_recommendations
order by recommendation_score desc