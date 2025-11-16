
  
    

        create or replace transient table JASON_CHLETSOS.fivetran_analytics_fct_fivetran_logs.fct_fivetran_error_monitoring
         as
        (

with sync_performance as (
    select * from JASON_CHLETSOS.fivetran_analytics_fct_fivetran_logs.fct_fivetran_sync_performance
    -- Remove date filter to include all data
),

connector_details as (
    select * from JASON_CHLETSOS.fivetran_analytics_int_fivetran_log.int_fivetran_log__connector_details
),

-- Get error logs
error_logs as (
    select * from JASON_CHLETSOS.fivetran_analytics_stg_fivetran_log.stg_fivetran_log__log
    where event_type = 'error'
),

-- Get failed syncs
failed_syncs as (
    select
        sync_id,
        connection_name,
        connector_name,
        sync_start_time,
        sync_end_time,
        sync_date,
        rows_synced
    from sync_performance
    where sync_status = 'error'
),

-- Create simple error types based on sync failures
sync_errors as (
    select
        fs.sync_id,
        fs.connection_name,
        fs.connector_name,
        fs.sync_start_time,
        fs.sync_end_time,
        fs.sync_date,
        fs.rows_synced,
        'Sync Failure' as error_message,
        'Sync Error' as error_type
    from failed_syncs fs
),

-- Identify recurring errors
recurring_errors as (
    select
        connection_name,
        connector_name,
        error_type,
        count(*) as occurrence_count
    from sync_errors
    group by 1, 2, 3
    having count(*) > 1
),

-- Flag recurring errors
flagged_errors as (
    select
        se.*,
        case when re.connection_name is not null then true else false end as is_recurring_error,
        coalesce(re.occurrence_count, 1) as error_occurrence_count
    from sync_errors se
    left join recurring_errors re 
        on se.connection_name = re.connection_name
        and se.connector_name = re.connector_name
        and se.error_type = re.error_type
)

select * from flagged_errors
order by sync_start_time desc
        );
      
  