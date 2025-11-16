with source as (
    select * from {{ source('fivetran_log', 'team') }}
),

renamed as (
    select
        id as team_id,
        name as team_name,
        description as team_description,
        parent_id as parent_team_id,
        account_id,
        _fivetran_deleted as is_deleted,
        _fivetran_synced
    from source
)

select * from renamed
