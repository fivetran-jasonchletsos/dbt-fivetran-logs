with source as (
    select * from {{ source('fivetran_log', 'source_schema_change_event') }}
),

renamed as (
    select
        schema_id as source_schema_id,
        connection_id,
        change_type,
        detected_at as change_detected_at,
        _fivetran_synced
    from source
)

select * from renamed
