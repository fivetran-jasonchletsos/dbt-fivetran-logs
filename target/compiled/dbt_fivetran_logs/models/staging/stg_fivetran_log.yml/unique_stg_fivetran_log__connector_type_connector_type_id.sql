
    
    

select
    connector_type_id as unique_field,
    count(*) as n_records

from JASON_CHLETSOS.fivetran_analytics_stg_fivetran_log.stg_fivetran_log__connector_type
where connector_type_id is not null
group by connector_type_id
having count(*) > 1


