
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    change_event_id as unique_field,
    count(*) as n_records

from JASON_CHLETSOS.fivetran_analytics_stg_fivetran_log.stg_fivetran_log__destination_column_change_event
where change_event_id is not null
group by change_event_id
having count(*) > 1



  
  
      
    ) dbt_internal_test