
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select user_id
from JASON_CHLETSOS.fivetran_analytics_stg_fivetran_log.stg_fivetran_log__user
where user_id is null



  
  
      
    ) dbt_internal_test