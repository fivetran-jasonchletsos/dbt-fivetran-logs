with source as (
    select * from {{ source('fivetran_log', 'schema_lineage') }}
),

renamed as (
    select
        destination_schema_id,
        source_schema_id,
        created_at,
        _fivetran_synced
    from source
)

select * from renamed
