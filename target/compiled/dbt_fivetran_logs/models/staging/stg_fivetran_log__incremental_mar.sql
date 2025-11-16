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