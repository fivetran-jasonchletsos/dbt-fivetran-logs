
  
    

create or replace transient  table JASON_CHLETSOS.fivetran_analytics_fivetran_analytics.fct_fivetran_connector_recommendations
    
    
    
    as (

with connector_health as (
    select * from JASON_CHLETSOS.fivetran_analytics_fivetran_analytics.fct_fivetran_connector_health
),

sync_performance as (
    select * from JASON_CHLETSOS.fivetran_analytics_fivetran_analytics.fct_fivetran_sync_performance
),

monthly_active_rows as (
    select * from JASON_CHLETSOS.fivetran_analytics_fivetran_analytics.fct_fivetran_monthly_active_rows
),

-- Calculate sync frequency metrics
sync_frequency as (
    select
        connection_name,
        connector_name,
        count(*) as sync_count,
        datediff(hour, min(sync_start_time), max(sync_start_time)) as hours_between_first_last_sync,
        case 
            when datediff(hour, min(sync_start_time), max(sync_start_time)) > 0 
            then count(*) / nullif(datediff(hour, min(sync_start_time), max(sync_start_time)), 0) * 24 
            else null 
        end as avg_syncs_per_day
    from sync_performance
    group by 1, 2
    having count(*) > 1
),

-- Calculate growth metrics
growth_metrics as (
    select
        connection_name,
        sum(total_active_rows) as total_active_rows,
        count(distinct schema_name || '.' || table_name) as tables_count
    from monthly_active_rows
    group by 1
),

-- Generate recommendations
connector_recommendations as (
    select
        ch.connection_name,
        ch.connector_name,
        ch.destination_name,
        ch.last_sync_at,
        ch.last_sync_status,
        ch.avg_sync_duration_seconds,
        coalesce(sf.avg_syncs_per_day, 0) as avg_syncs_per_day,
        coalesce(gm.total_active_rows, 0) as total_active_rows,
        coalesce(gm.tables_count, 0) as tables_count,
        
        -- Generate recommendations based on patterns
        case
            -- Sync frequency recommendations
            when coalesce(sf.avg_syncs_per_day, 0) > 12 and ch.avg_sync_duration_seconds < 60 
                then 'Consider reducing sync frequency - current frequency is high with fast syncs'
            when coalesce(sf.avg_syncs_per_day, 0) < 1 and coalesce(gm.total_active_rows, 0) > 1000000 
                then 'Consider increasing sync frequency for large data volume'
            
            -- Performance recommendations
            when ch.avg_sync_duration_seconds > 3600 
                then 'Long-running syncs detected - review connector configuration and optimize'
            when ch.success_rate_last_7d < 80 
                then 'Low success rate - investigate recurring errors'
            
            -- Usage recommendations
            when coalesce(gm.tables_count, 0) = 0 
                then 'No active tables - consider pausing or removing connector'
            when coalesce(gm.total_active_rows, 0) = 0 and ch.last_sync_status = 'success' 
                then 'Connector is syncing successfully but no active rows - review schema configuration'
            
            -- Health recommendations
            when ch.last_sync_status = 'error' 
                then 'Connector is currently failing - immediate attention required'
            when ch.last_sync_at < dateadd(day, -7, current_timestamp()) 
                then 'Connector has not synced in over a week - check if paused or experiencing issues'
            
            else 'Connector is performing as expected'
        end as primary_recommendation,
        
        -- Generate a recommendation score (higher means more attention needed)
        case
            when ch.last_sync_status = 'error' then 100
            when ch.last_sync_at < dateadd(day, -7, current_timestamp()) then 90
            when ch.success_rate_last_7d < 80 then 80
            when ch.avg_sync_duration_seconds > 3600 then 70
            when coalesce(gm.tables_count, 0) = 0 then 60
            when coalesce(gm.total_active_rows, 0) = 0 and ch.last_sync_status = 'success' then 50
            when coalesce(sf.avg_syncs_per_day, 0) > 12 and ch.avg_sync_duration_seconds < 60 then 40
            when coalesce(sf.avg_syncs_per_day, 0) < 1 and coalesce(gm.total_active_rows, 0) > 1000000 then 30
            else 0
        end as recommendation_score
        
    from connector_health ch
    left join sync_frequency sf on ch.connection_name = sf.connection_name
    left join growth_metrics gm on ch.connection_name = gm.connection_name
)

select 
    *,
    case
        when recommendation_score >= 80 then 'Critical'
        when recommendation_score >= 50 then 'High'
        when recommendation_score >= 30 then 'Medium'
        else 'Low'
    end as recommendation_priority
from connector_recommendations
order by recommendation_score desc
    )
;


  