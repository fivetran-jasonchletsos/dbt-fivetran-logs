
  create or replace   view JASON_CHLETSOS.fivetran_analytics_stg_fivetran_log.stg_fivetran_log__incremental_mar
  
   as (
    with source as (
    select * from JASON_CHLETSOS.JASON_CHLETSOS_FIVETRAN_LOG.incremental_mar
),

renamed as (
    select
        connection_name,
        destination_id,
        measured_date,
        schema_name,
        sync_type,
        table_name,
        case 
            when free_type = 'free' then true
            else false
        end as is_free,
        updated_at,
        incremental_rows,
        _fivetran_synced
    from source
)

select * from renamed
  );

