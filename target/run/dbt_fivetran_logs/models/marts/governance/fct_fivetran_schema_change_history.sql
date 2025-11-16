
  
    

        create or replace transient table JASON_CHLETSOS.fivetran_analytics_fct_fivetran_logs.fct_fivetran_schema_change_history
         as
        (

with connector_details as (
    select * from JASON_CHLETSOS.fivetran_analytics_int_fivetran_log.int_fivetran_log__connector_details
),

-- Get column change events
column_change_events as (
    select * from JASON_CHLETSOS.fivetran_analytics_stg_fivetran_log.stg_fivetran_log__destination_column_change_event
),

-- Get table change events
table_change_events as (
    select * from JASON_CHLETSOS.fivetran_analytics_stg_fivetran_log.stg_fivetran_log__destination_table_change_event
),

-- Get schema change events
schema_change_events as (
    select * from JASON_CHLETSOS.fivetran_analytics_stg_fivetran_log.stg_fivetran_log__destination_schema_change_event
),

-- Get column details for enrichment
destination_columns as (
    select * from JASON_CHLETSOS.fivetran_analytics_stg_fivetran_log.stg_fivetran_log__destination_column
),

-- Get table details for enrichment
destination_tables as (
    select * from JASON_CHLETSOS.fivetran_analytics_stg_fivetran_log.stg_fivetran_log__destination_table
),

-- Get schema details for enrichment
destination_schemas as (
    select * from JASON_CHLETSOS.fivetran_analytics_stg_fivetran_log.stg_fivetran_log__destination_schema
),

-- Process column changes
column_changes as (
    select
        cce.change_detected_at,
        cce.connection_id,
        'Column Change' as change_category,
        cce.change_type,
        ds.schema_name,
        dt.table_name,
        dc.column_name,
        cce.attribute_name,
        cce.new_value as new_value,
        null as previous_value
    from column_change_events cce
    left join destination_columns dc on cce.destination_column_id = dc.destination_column_id
    left join destination_tables dt on dc.destination_table_id = dt.destination_table_id
    left join destination_schemas ds on dt.destination_schema_id = ds.destination_schema_id
),

-- Process table changes
table_changes as (
    select
        tce.change_detected_at,
        tce.connection_id,
        'Table Change' as change_category,
        tce.change_type,
        ds.schema_name,
        dt.table_name,
        null as column_name,
        null as attribute_name,
        null as new_value,
        null as previous_value
    from table_change_events tce
    left join destination_tables dt on tce.destination_table_id = dt.destination_table_id
    left join destination_schemas ds on dt.destination_schema_id = ds.destination_schema_id
),

-- Process schema changes
schema_changes as (
    select
        sce.change_detected_at,
        sce.connection_id,
        'Schema Change' as change_category,
        sce.change_type,
        ds.schema_name,
        null as table_name,
        null as column_name,
        null as attribute_name,
        null as new_value,
        null as previous_value
    from schema_change_events sce
    left join destination_schemas ds on sce.destination_schema_id = ds.destination_schema_id
),

-- Union all change types - NO FILTERING
all_changes as (
    select * from column_changes
    union all
    select * from table_changes
    union all
    select * from schema_changes
),

-- Enrich with connector information
enriched_schema_changes as (
    select
        ac.change_detected_at,
        cd.connection_name,
        cd.connector_name,
        cd.destination_name,
        ac.change_category,
        ac.change_type,
        ac.schema_name,
        ac.table_name,
        ac.column_name,
        ac.attribute_name,
        ac.new_value,
        ac.previous_value,
        date_trunc('day', ac.change_detected_at) as change_date
    from all_changes ac
    left join connector_details cd on ac.connection_id = cd.connection_id
)

select * from enriched_schema_changes
order by change_detected_at desc
        );
      
  