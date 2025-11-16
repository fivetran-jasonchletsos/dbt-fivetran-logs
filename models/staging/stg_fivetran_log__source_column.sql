with source as (
    select * from {{ source('fivetran_log', 'source_column') }}
),

renamed as (
    select
        id as source_column_id,
        connection_id,
        table_id as source_table_id,
        name as column_name,
        type as data_type,
        is_primary_key,
        created_at,
        updated_at,
        _fivetran_synced
    from source
)

select * from renamed
