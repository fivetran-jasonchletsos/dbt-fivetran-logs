with source as (
    select * from {{ source('fivetran_log', 'source_table_change_event') }}
),

renamed as (
    select
        table_id as source_table_id,
        connection_id,
        change_type,
        detected_at as change_detected_at,
        _fivetran_synced
    from source
)

select * from renamed
