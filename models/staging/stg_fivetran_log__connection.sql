with source as (
    select * from {{ source('fivetran_log', 'connection') }}
),

renamed as (
    select
        connection_id,
        connection_name,
        connector_type_id,
        destination_id,
        connecting_user_id,
        signed_up as created_at,
        paused as is_paused,
        sync_frequency,
        deployment_type,
        _fivetran_deleted,
        _fivetran_synced
    from source
)

select * from renamed