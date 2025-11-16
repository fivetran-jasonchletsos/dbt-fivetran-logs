
  
    

create or replace transient  table JASON_CHLETSOS.fivetran_analytics_fivetran_analytics.fct_fivetran_sync_performance
    
    
    
    as (

with logs as (
    select * from JASON_CHLETSOS.fivetran_analytics_stg_fivetran_log.stg_fivetran_log__log
),

connector_details as (
    select * from JASON_CHLETSOS.fivetran_analytics_int_fivetran_log.int_fivetran_log__connector_details
),

-- Extract detailed sync information from logs
detailed_syncs as (
    select
        l.log_id,
        l.sync_id,
        l.connection_id,
        l.logged_at as sync_time,
        cd.connection_name,
        cd.connector_name,
        cd.destination_name,
        date(l.logged_at) as sync_date,
        l.event_type,
        l.message_content,
        case 
            when l.event_type = 'SEVERE' then 'error'
            when l.event_type = 'WARNING' then 'warning'
            else 'success'
        end as sync_status,
        case
            when l.message_content like '%rows synced%' then
                try_cast(regexp_substr(l.message_content, '[0-9]+') as integer)
            else null
        end as rows_synced
    from logs l
    join connector_details cd on l.connection_id = cd.connection_id
    where l.message_content like '%sync%' 
       or l.message_content like '%Sync%'
       or l.message_content like '%rows synced%'
),

-- Group syncs by ID to get metrics
sync_metrics as (
    select
        sync_id,
        connection_id,
        connection_name,
        connector_name,
        destination_name,
        min(sync_time) as sync_start_time,
        max(sync_time) as sync_end_time,
        date(min(sync_time)) as sync_date,
        max(case when sync_status = 'error' then 1 else 0 end) > 0 as has_errors,
        max(rows_synced) as rows_synced
    from detailed_syncs
    where sync_id is not null
    group by 1, 2, 3, 4, 5
),

-- Calculate final metrics
final_syncs as (
    select
        sync_id,
        connection_id,
        connection_name,
        connector_name,
        destination_name,
        sync_start_time,
        sync_end_time,
        sync_date,
        case when has_errors then 'error' else 'success' end as sync_status,
        datediff(second, sync_start_time, sync_end_time) as sync_duration_seconds,
        coalesce(rows_synced, 0) as rows_synced
    from sync_metrics
)

select * from final_syncs
    )
;


  