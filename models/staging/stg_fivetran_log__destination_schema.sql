with source as (
    select * from {{ source('fivetran_log', 'destination_schema') }}
),

renamed as (
    select
        id as destination_schema_id,
        destination_id,
        connection_id,
        name as schema_name,
        created_at,
        _fivetran_synced
    from source
)

select * from renamed
