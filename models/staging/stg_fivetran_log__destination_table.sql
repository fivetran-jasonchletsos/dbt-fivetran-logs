with source as (
    select * from {{ source('fivetran_log', 'destination_table') }}
),

renamed as (
    select
        id as destination_table_id,
        destination_id,
        schema_id as destination_schema_id,
        connection_id,
        name as table_name,
        created_at,
        _fivetran_synced
    from source
)

select * from renamed
