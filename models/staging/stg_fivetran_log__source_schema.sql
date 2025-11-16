with source as (
    select * from {{ source('fivetran_log', 'source_schema') }}
),

renamed as (
    select
        id as source_schema_id,
        connection_id,
        name as schema_name,
        created_at,
        _fivetran_synced
    from source
)

select * from renamed
