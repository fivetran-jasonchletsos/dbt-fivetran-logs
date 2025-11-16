with source as (
    select * from JASON_CHLETSOS.JASON_CHLETSOS_FIVETRAN_LOG.log
),

renamed as (
    select
        id as log_id,
        time_stamp as logged_at,
        connection_id,
        event as event_type,
        message_event as message_type,
        message_data as message_content,
        sync_id,
        _fivetran_synced
    from source
)

select * from renamed