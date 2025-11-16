with source as (
    select * from {{ source('fivetran_log', 'connection') }}
),

renamed as (
    select
        connection_id,
        name as connection_name,
        connector_type_id,
        destination_id,
        created_at,
        status,
        paused as is_paused,
        _fivetran_synced
    from source
)

select * from renamed