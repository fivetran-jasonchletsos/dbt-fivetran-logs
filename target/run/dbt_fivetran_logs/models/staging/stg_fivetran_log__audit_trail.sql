
  create or replace   view JASON_CHLETSOS.fivetran_analytics_stg_fivetran_log.stg_fivetran_log__audit_trail
  
   as (
    with source as (
    select * from JASON_CHLETSOS.JASON_CHLETSOS_FIVETRAN_LOG.audit_trail
),

renamed as (
    select
        id as audit_id,
        user_id,
        captured_at as event_created_at,
        action as event_type,
        interaction_method,
        primary_resource_type as resource_type,
        primary_resource_id as resource_id,
        secondary_resource_type,
        secondary_resource_id,
        old_values,
        new_values,
        _fivetran_synced
    from source
)

select * from renamed
  );

