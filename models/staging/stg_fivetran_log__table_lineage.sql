with source as (
    select * from {{ source('fivetran_log', 'table_lineage') }}
),

renamed as (
    select
        destination_table_id,
        source_table_id,
        created_at,
        _fivetran_synced
    from source
)

select * from renamed
