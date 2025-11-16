
  create or replace   view JASON_CHLETSOS.fivetran_analytics_stg_fivetran_log.stg_fivetran_log__destination
  
   as (
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
  );

