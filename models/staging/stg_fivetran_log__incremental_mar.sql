with source as (

    select * from {{ source('fivetran_log', 'incremental_mar') }}

),

renamed as (

    select
        connection_name,
        destination_id,
        measured_date,
        schema_name,
        table_name,
        incremental_rows,
        is_free,
        _fivetran_synced
    from source

)

select * from renamed