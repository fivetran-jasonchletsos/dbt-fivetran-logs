with source as (
    select * from {{ source('fivetran_log', 'audit_trail') }}
),

renamed as (
    select
        id as audit_id,
        user_id,
        event_type,
        event_subtype,
        resource_id,
        resource_type,
        created_at as event_created_at,
        _fivetran_synced
    from source
)

select * from renamed
