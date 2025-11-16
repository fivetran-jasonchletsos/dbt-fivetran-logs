with source as (
    select * from {{ source('fivetran_log', 'destination_column_change_event') }}
),

renamed as (
    select
        id as change_event_id,
        column_id as destination_column_id,
        change_type,
        previous_data_type,
        new_data_type,
        created_at as change_detected_at,
        _fivetran_synced
    from source
)

select * from renamed
