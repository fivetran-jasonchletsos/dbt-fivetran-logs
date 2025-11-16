
  
    

        create or replace transient table JASON_CHLETSOS.fivetran_analytics_fivetran_analytics.fct_fivetran_monthly_active_rows
         as
        (

with incremental_mar as (
    select * from JASON_CHLETSOS.fivetran_analytics_stg_fivetran_log.stg_fivetran_log__incremental_mar
),

connector_details as (
    select * from JASON_CHLETSOS.fivetran_analytics_int_fivetran_log.int_fivetran_log__connector_details
),

-- Get all months in the data
months as (
    select distinct 
        date_trunc('month', measured_date) as month_date
    from incremental_mar
),

-- Get all connector, schema, table combinations
connector_schema_tables as (
    select distinct
        connection_name,
        schema_name,
        table_name
    from incremental_mar
),

-- Create a cross join of all months and connector/schema/tables
month_connector_combinations as (
    select
        m.month_date,
        cst.connection_name,
        cst.schema_name,
        cst.table_name
    from months m
    cross join connector_schema_tables cst
),

-- Calculate monthly active rows
monthly_active_rows as (
    select
        date_trunc('month', measured_date) as month_date,
        connection_name,
        schema_name,
        table_name,
        sum(incremental_rows) as active_rows,
        sum(case when is_free then incremental_rows else 0 end) as free_active_rows,
        sum(case when not is_free then incremental_rows else 0 end) as paid_active_rows
    from incremental_mar
    group by 1, 2, 3, 4
),

-- Join with connector details
enriched_monthly_active_rows as (
    select
        mcc.month_date,
        mcc.connection_name,
        cd.connector_name,
        mcc.schema_name,
        mcc.table_name,
        coalesce(mar.free_active_rows, 0) as free_active_rows,
        coalesce(mar.paid_active_rows, 0) as paid_active_rows,
        coalesce(mar.active_rows, 0) as total_active_rows
    from month_connector_combinations mcc
    left join monthly_active_rows mar 
        on mcc.month_date = mar.month_date
        and mcc.connection_name = mar.connection_name
        and mcc.schema_name = mar.schema_name
        and mcc.table_name = mar.table_name
    left join connector_details cd 
        on mcc.connection_name = cd.connection_name
)

select * from enriched_monthly_active_rows
order by month_date desc, total_active_rows desc
        );
      
  