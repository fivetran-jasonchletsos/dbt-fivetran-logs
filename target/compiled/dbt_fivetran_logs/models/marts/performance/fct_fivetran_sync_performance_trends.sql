

with sync_performance as (
    select * from JASON_CHLETSOS.fivetran_analytics_fct_fivetran_logs.fct_fivetran_sync_performance
),

-- Calculate daily sync metrics
daily_sync_metrics as (
    select
        sync_date,
        connection_name,
        connector_name,
        count(*) as sync_count,
        sum(case when sync_status = 'success' then 1 else 0 end) as successful_syncs,
        sum(case when sync_status = 'error' then 1 else 0 end) as failed_syncs,
        avg(sync_duration_seconds) as avg_sync_duration,
        max(sync_duration_seconds) as max_sync_duration,
        min(sync_duration_seconds) as min_sync_duration,
        sum(rows_synced) as total_rows_synced
    from sync_performance
    where sync_date >= dateadd(day, -90, current_date())
    group by 1, 2, 3
),

-- Calculate rolling averages
rolling_metrics as (
    select
        sync_date,
        connection_name,
        connector_name,
        sync_count,
        successful_syncs,
        failed_syncs,
        avg_sync_duration,
        max_sync_duration,
        min_sync_duration,
        total_rows_synced,
        -- Calculate 7-day rolling averages
        avg(avg_sync_duration) over (
            partition by connection_name, connector_name
            order by sync_date
            rows between 6 preceding and current row
        ) as rolling_7d_avg_duration,
        avg(total_rows_synced) over (
            partition by connection_name, connector_name
            order by sync_date
            rows between 6 preceding and current row
        ) as rolling_7d_avg_rows,
        -- Calculate success rate
        (successful_syncs / nullif(sync_count, 0)) * 100 as success_rate,
        -- Calculate 7-day rolling success rate
        avg((successful_syncs / nullif(sync_count, 0)) * 100) over (
            partition by connection_name, connector_name
            order by sync_date
            rows between 6 preceding and current row
        ) as rolling_7d_success_rate
    from daily_sync_metrics
)

select * from rolling_metrics
order by sync_date desc, connection_name, connector_name