with source as (
    select * from {{ source('fivetran_log', 'account') }}
),

renamed as (
    select
        id as account_id,
        name as account_name,
        created_at,
        status as account_status,
        country,
        _fivetran_synced
    from source
)

select * from renamed
