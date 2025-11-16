
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select connection_id
from JASON_CHLETSOS.fivetran_analytics_stg_fivetran_log.stg_fivetran_log__connection
where connection_id is null



  
  
      
    ) dbt_internal_test