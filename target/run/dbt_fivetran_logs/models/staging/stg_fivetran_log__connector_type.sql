
  create or replace   view JASON_CHLETSOS.fivetran_analytics_stg_fivetran_log.stg_fivetran_log__connector_type
  
   as (
    with source as (
    select * from JASON_CHLETSOS.JASON_CHLETSOS_FIVETRAN_LOG.connector_type
),

renamed as (
    select
        id as connector_type_id,
        official_connector_name as connector_name,
        type as connector_type,
        availability as availability_status,
        created_at,
        public_beta_at,
        release_at as released_at,
        deleted as is_deleted,
        _fivetran_synced
    from source
)

select * from renamed
  );

