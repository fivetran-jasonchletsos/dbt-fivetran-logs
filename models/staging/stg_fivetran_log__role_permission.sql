with source as (
    select * from {{ source('fivetran_log', 'role_permission') }}
),

renamed as (
    select
        role_id,
        permission,
        _fivetran_deleted as is_deleted,
        _fivetran_synced
    from source
)

select * from renamed
