with source as (
    select * from {{ source('fivetran_log', 'destination_column') }}
),

renamed as (
    select
        id as destination_column_id,
        destination_id,
        table_id as destination_table_id,
        connection_id,
        name as column_name,
        type as data_type,
        created_at,
        updated_at,
        _fivetran_synced
    from source
)

select * from renamed
