with source as (
    select * from JASON_CHLETSOS.JASON_CHLETSOS_FIVETRAN_LOG.connection
),

renamed as (
    select
        connection_id,
        connecting_user_id,
        connector_type_id,
        connection_name,
        signed_up as created_at,
        paused as is_paused,
        sync_frequency as sync_frequency_minutes,
        deployment_type,
        _fivetran_deleted as is_deleted,
        destination_id,
        _fivetran_synced
    from source
)

select * from renamed