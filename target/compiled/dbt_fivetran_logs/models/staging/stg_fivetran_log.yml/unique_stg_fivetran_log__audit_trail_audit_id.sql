
    
    

select
    audit_id as unique_field,
    count(*) as n_records

from JASON_CHLETSOS.fivetran_analytics_stg_fivetran_log.stg_fivetran_log__audit_trail
where audit_id is not null
group by audit_id
having count(*) > 1


