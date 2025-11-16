{{ config(
    materialized = 'table'
) }}

with sync_performance as (
    select * from {{ ref('fct_fivetran_sync_performance') }}
),

connector_details as (
    select * from {{ ref('int_fivetran_log__connector_details') }}
),

-- Get all error and warning logs - NO FILTERING
error_logs as (
    select * from {{ ref('stg_fivetran_log__log') }}
    where event_type IN ('SEVERE', 'WARNING')
),

-- Process all error logs with enrichment
all_errors as (
    select
        el.log_id,
        el.sync_id,
        el.logged_at as error_timestamp,
        el.connection_id,
        el.event_type,
        el.message_type,
        el.message_content as error_message,
        -- Categorize error types
        case
            when el.event_type = 'SEVERE' and el.message_type = 'sync_end' then 'Sync Failure'
            when el.event_type = 'SEVERE' and el.message_type = 'connection_failure' then 'Connection Failure'
            when el.event_type = 'WARNING' and el.message_type = 'transformation_failed' then 'Transformation Failed'
            when el.event_type = 'WARNING' and el.message_type = 'warning' then 'General Warning'
            when el.event_type = 'WARNING' and el.message_type = 'forced_resync_table' then 'Forced Resync'
            when el.event_type = 'WARNING' then 'Warning - ' || el.message_type
            when el.event_type = 'SEVERE' then 'Severe - ' || el.message_type
            else 'Other Error'
        end as error_type,
        date_trunc('day', el.logged_at) as error_date
    from error_logs el
),

-- Enrich with connector information
enriched_errors as (
    select
        ae.log_id,
        ae.sync_id,
        ae.error_timestamp,
        ae.error_date,
        coalesce(cd.connection_name, 'Unknown') as connection_name,
        coalesce(cd.connector_name, 'Unknown') as connector_name,
        coalesce(cd.destination_name, 'Unknown') as destination_name,
        ae.event_type as severity,
        ae.error_type,
        ae.message_type,
        ae.error_message
    from all_errors ae
    left join connector_details cd on ae.connection_id = cd.connection_id
),

-- Identify recurring errors
recurring_errors as (
    select
        connection_name,
        connector_name,
        error_type,
        count(*) as occurrence_count
    from enriched_errors
    group by 1, 2, 3
    having count(*) > 1
),

-- Flag recurring errors
flagged_errors as (
    select
        ee.*,
        case when re.connection_name is not null then true else false end as is_recurring_error,
        coalesce(re.occurrence_count, 1) as error_occurrence_count
    from enriched_errors ee
    left join recurring_errors re 
        on ee.connection_name = re.connection_name
        and ee.connector_name = re.connector_name
        and ee.error_type = re.error_type
)

select * from flagged_errors
order by error_timestamp desc