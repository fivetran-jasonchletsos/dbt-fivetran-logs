with source as (
    select * from {{ source('fivetran_log', 'team_membership') }}
),

renamed as (
    select
        team_id,
        role_id,
        user_id,
        created_at,
        _fivetran_deleted as is_deleted,
        _fivetran_synced
    from source
)

select * from renamed
