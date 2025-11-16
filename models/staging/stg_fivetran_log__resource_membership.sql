with source as (
    select * from {{ source('fivetran_log', 'resource_membership') }}
),

renamed as (
    select
        id as resource_membership_id,
        role_id,
        team_id,
        user_id,
        account_id,
        destination_id,
        connection_id,
        organization_id,
        created_at,
        _fivetran_deleted as is_deleted,
        _fivetran_synced
    from source
)

select * from renamed
