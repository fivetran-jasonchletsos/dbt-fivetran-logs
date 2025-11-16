with source as (
    select * from {{ source('fivetran_log', 'column_lineage') }}
),

renamed as (
    select
        destination_column_id,
        source_column_id,
        created_at,
        _fivetran_synced
    from source
)

select * from renamed
