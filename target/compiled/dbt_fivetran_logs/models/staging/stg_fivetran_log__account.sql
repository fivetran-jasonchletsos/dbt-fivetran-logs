with source as (
    select * from JASON_CHLETSOS.JASON_CHLETSOS_FIVETRAN_LOG.account
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