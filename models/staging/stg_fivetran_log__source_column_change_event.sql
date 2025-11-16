with source as (
    select * from {{ source('fivetran_log', 'source_column_change_event') }}
),

renamed as (
    select
        column_id as source_column_id,
        connection_id,
        attribute_name,
        entity_type,
        change_type,
        new_value,
        detected_at as change_detected_at,
        _fivetran_synced
    from source
)

select * from renamed
