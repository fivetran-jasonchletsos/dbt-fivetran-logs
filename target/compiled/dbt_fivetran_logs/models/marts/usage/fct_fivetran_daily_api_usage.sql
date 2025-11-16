with daily_api_calls as (
    select * from JASON_CHLETSOS.fivetran_analytics_int_fivetran_log.int_fivetran_log__daily_api_calls
),

connector_details as (
    select * from JASON_CHLETSOS.fivetran_analytics_int_fivetran_log.int_fivetran_log__connector_details
),

-- Enrich with connector and destination information
enriched_api_calls as (
    select
        dac.date_day,
        dac.connection_id,
        dac.connection_name,
        cd.connector_name,
        cd.destination_name,
        dac.api_calls_count
    from daily_api_calls dac
    left join connector_details cd on dac.connection_id = cd.connection_id
)

select * from enriched_api_calls