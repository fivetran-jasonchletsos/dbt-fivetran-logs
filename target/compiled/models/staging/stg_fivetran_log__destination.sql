with source as (
    select * from JASON_CHLETSOS.JASON_CHLETSOS_FIVETRAN_LOG.destination
),

renamed as (
    select
        id as destination_id,
        name as destination_name,
        account_id,
        created_at,
        region,
        is_active,
        deployment_type,
        destination_type,
        _fivetran_synced
    from source
)

select * from renamed