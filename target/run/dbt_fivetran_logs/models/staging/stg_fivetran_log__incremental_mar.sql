
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
        table_name,
        sync_type,
        incremental_rows,
        case 
            when free_type = 'FREE' then true 
            when free_type = 'PAID' then false 
            else null 
        end as is_free,
        updated_at,
        _fivetran_synced
    from source

)

select * from renamed
  );

