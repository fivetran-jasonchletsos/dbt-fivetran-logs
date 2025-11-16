with source as (
    select * from {{ source('fivetran_log', 'destination_table_change_event') }}
),

renamed as (
    select
        table_id as destination_table_id,
        destination_id,
        connection_id,
        change_type,
        detected_at as change_detected_at,
        _fivetran_synced
    from source
)

select * from renamed
