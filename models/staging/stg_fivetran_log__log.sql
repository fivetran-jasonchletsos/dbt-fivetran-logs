with source as (
    select * from {{ source('fivetran_log', 'log') }}
),

renamed as (
    select
        log_id,
        sync_id,
        logged_at,
        event_type,
        connection_id,
        message_type,
        message_content,
        _fivetran_synced
    from source
)

select * from renamed