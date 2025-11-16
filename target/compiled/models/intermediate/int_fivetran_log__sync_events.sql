with logs as (
    select * from JASON_CHLETSOS.fivetran_analytics_stg_fivetran_log.stg_fivetran_log__log
),

connections as (
    select * from JASON_CHLETSOS.fivetran_analytics_stg_fivetran_log.stg_fivetran_log__connection
),

destinations as (
    select * from JASON_CHLETSOS.fivetran_analytics_stg_fivetran_log.stg_fivetran_log__destination
),

connector_types as (
    select * from JASON_CHLETSOS.fivetran_analytics_stg_fivetran_log.stg_fivetran_log__connector_type
),

-- Extract sync information from message content
sync_logs as (
    select
        log_id,
        sync_id,
        connection_id,
        logged_at as sync_time,
        message_content,
        event_type,
        case 
            when event_type = 'SEVERE' then 'error'
            when event_type = 'WARNING' then 'warning'
            else 'info'
        end as sync_status,
        case
            when message_content like '%rows synced%' then
                try_cast(regexp_substr(message_content, '[0-9]+') as integer)
            else null
        end as rows_synced
    from logs
    where message_content like '%sync%' 
       or message_content like '%Sync%'
       or message_content like '%rows synced%'
),

-- Group by connection to get sync metrics
connection_syncs as (
    select
        connection_id,
        min(sync_time) as first_sync_time,
        max(sync_time) as last_sync_time,
        count(*) as sync_count,
        sum(case when sync_status = 'error' then 1 else 0 end) as error_count,
        sum(coalesce(rows_synced, 0)) as total_rows_synced
    from sync_logs
    group by 1
),

-- Join with connection and destination information
combined_syncs as (
    select
        cs.connection_id,
        c.connection_name,
        ct.connector_name,
        cs.first_sync_time,
        cs.last_sync_time,
        cs.sync_count,
        cs.error_count,
        cs.total_rows_synced,
        (cs.sync_count - cs.error_count) / nullif(cs.sync_count, 0) * 100 as success_rate,
        c.destination_id,
        d.destination_name
    from connection_syncs cs
    left join connections c on cs.connection_id = c.connection_id
    left join destinations d on c.destination_id = d.destination_id
    left join connector_types ct on c.connector_type_id = ct.connector_type_id
)

select * from combined_syncs