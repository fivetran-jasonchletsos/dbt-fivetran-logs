with source as (
    select * from {{ source('fivetran_log', 'role') }}
),

renamed as (
    select
        id as role_id,
        name as role_name,
        description as role_description,
        account_id,
        connector_types,
        _fivetran_deleted as is_deleted,
        _fivetran_synced
    from source
)

select * from renamed
