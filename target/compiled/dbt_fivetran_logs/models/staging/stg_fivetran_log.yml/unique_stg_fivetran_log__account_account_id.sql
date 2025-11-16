
    
    

select
    account_id as unique_field,
    count(*) as n_records

from JASON_CHLETSOS.fivetran_analytics_stg_fivetran_log.stg_fivetran_log__account
where account_id is not null
group by account_id
having count(*) > 1


