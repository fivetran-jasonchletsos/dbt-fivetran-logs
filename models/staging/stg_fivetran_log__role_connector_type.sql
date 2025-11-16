with source as (
    select * from {{ source('fivetran_log', 'role_connector_type') }}
),

renamed as (
    select
        role_id,
        connector_type,
        _fivetran_deleted as is_deleted,
        _fivetran_synced
    from source
)

select * from renamed
