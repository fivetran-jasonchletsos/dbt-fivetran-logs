
  create or replace   view JASON_CHLETSOS.fivetran_analytics_stg_fivetran_log.stg_fivetran_log__user
  
   as (
    with source as (
    select * from JASON_CHLETSOS.JASON_CHLETSOS_FIVETRAN_LOG.user
),

renamed as (
    select
        id as user_id,
        email,
        given_name as first_name,
        family_name as last_name,
        created_at,
        _fivetran_synced
    from source
)

select * from renamed
  );

