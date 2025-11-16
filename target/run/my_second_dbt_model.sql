
  
    

create or replace transient  table JASON_CHLETSOS.fivetran_analytics.my_second_dbt_model
    
    
    
    as (
-- Use the `ref` function to select from other models

select *
from JASON_CHLETSOS.fivetran_analytics.my_first_dbt_model
where id = 1
    )
;


  