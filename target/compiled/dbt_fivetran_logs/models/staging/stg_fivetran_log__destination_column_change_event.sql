with source as (
    select * from JASON_CHLETSOS.JASON_CHLETSOS_FIVETRAN_LOG.destination_column_change_event
),

renamed as (
    select
        column_id as destination_column_id,
        destination_id,
        connection_id,
        attribute_name,
        change_type,
        new_value,
        detected_at as change_detected_at,
        _fivetran_synced
    from source
)

select * from renamed