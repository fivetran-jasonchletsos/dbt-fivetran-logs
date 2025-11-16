
    
    

select
    connection_id as unique_field,
    count(*) as n_records

from JASON_CHLETSOS.fivetran_analytics_int_fivetran_log.int_fivetran_log__connector_details
where connection_id is not null
group by connection_id
having count(*) > 1


