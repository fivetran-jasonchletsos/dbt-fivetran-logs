with source as (
    select * from {{ source('fivetran_log', 'user') }}
),

renamed as (
    select
        id as user_id,
        email,
        given_name as first_name,
        family_name as last_name,
        created_at,
        _fivetran_synced
    from source
)

select * from renamed