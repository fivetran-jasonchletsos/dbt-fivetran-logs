with source as (
    select * from {{ source('fivetran_log', 'source_table') }}
),

renamed as (
    select
        id as source_table_id,
        connection_id,
        schema_id as source_schema_id,
        name as table_name,
        created_at,
        _fivetran_synced
    from source
)

select * from renamed
