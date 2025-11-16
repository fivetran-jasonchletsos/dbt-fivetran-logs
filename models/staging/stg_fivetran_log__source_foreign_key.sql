with source as (
    select * from {{ source('fivetran_log', 'source_foreign_key') }}
),

renamed as (
    select
        column_id as source_column_id,
        ordinal,
        foreign_key_reference,
        created_at,
        updated_at,
        _fivetran_synced
    from source
)

select * from renamed
