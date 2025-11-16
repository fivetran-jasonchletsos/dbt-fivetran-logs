
  
    

create or replace transient  table JASON_CHLETSOS.fivetran_analytics.sample_model
    
    
    
    as (-- This is a sample model that doesn't require a connection
-- It will help us test if dbt compilation works

select 1 as id, 'test' as name
    )
;


  