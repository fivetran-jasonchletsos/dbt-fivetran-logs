with source as (
    select * from {{ source('fivetran_log', 'connector_sdk_log') }}
),

renamed as (
    select
        id as log_id,
        connection_id,
        sync_id,
        event_time as logged_at,
        level as log_level,
        message as log_message,
        message_origin,
        _fivetran_synced
    from source
)

select * from renamed
