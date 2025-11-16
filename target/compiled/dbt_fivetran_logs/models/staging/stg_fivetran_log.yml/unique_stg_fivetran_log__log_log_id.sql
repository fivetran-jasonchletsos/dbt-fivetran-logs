
    
    

select
    log_id as unique_field,
    count(*) as n_records

from JASON_CHLETSOS.fivetran_analytics_stg_fivetran_log.stg_fivetran_log__log
where log_id is not null
group by log_id
having count(*) > 1


