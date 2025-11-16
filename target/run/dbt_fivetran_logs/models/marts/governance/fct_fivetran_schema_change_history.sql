
  
    

        create or replace transient table JASON_CHLETSOS.fivetran_analytics_fct_fivetran_logs.fct_fivetran_schema_change_history
         as
        (

with logs as (
    select * from JASON_CHLETSOS.fivetran_analytics_stg_fivetran_log.stg_fivetran_log__log
),

connector_details as (
    select * from JASON_CHLETSOS.fivetran_analytics_int_fivetran_log.int_fivetran_log__connector_details
),

-- Extract schema change events from logs
schema_change_events as (
    select
        log_id,
        logged_at as change_detected_at,
        connection_id,
        message_type,
        message_content,
        -- Extract schema and table information from message content
        regexp_substr(message_content, 'schema ([^\\s]+)', 1, 1, 'e') as schema_name,
        regexp_substr(message_content, 'table ([^\\s\\.]+)', 1, 1, 'e') as table_name,
        -- Determine change type
        case
            when message_type like '%column_added%' then 'Column Added'
            when message_type like '%column_removed%' then 'Column Removed'
            when message_type like '%column_renamed%' then 'Column Renamed'
            when message_type like '%column_type_changed%' then 'Column Type Changed'
            when message_type like '%table_added%' then 'Table Added'
            when message_type like '%table_removed%' then 'Table Removed'
            when message_type like '%table_renamed%' then 'Table Renamed'
            when message_type like '%schema_added%' then 'Schema Added'
            when message_type like '%schema_removed%' then 'Schema Removed'
            when message_type like '%schema_renamed%' then 'Schema Renamed'
            else 'Other Schema Change'
        end as change_type,
        -- Extract column information
        regexp_substr(message_content, 'column ([^\\s]+)', 1, 1, 'e') as column_name,
        -- Extract data type information for type changes
        case 
            when message_type like '%column_type_changed%' then 
                regexp_substr(message_content, 'from ([^\\s]+) to', 1, 1, 'e')
            else null
        end as previous_data_type,
        case 
            when message_type like '%column_type_changed%' then 
                regexp_substr(message_content, 'to ([^\\s\\.]+)', 1, 1, 'e')
            else null
        end as new_data_type
    from logs
    where event_type = 'schema_change'
),

-- Enrich with connector information
enriched_schema_changes as (
    select
        sce.change_detected_at,
        cd.connection_name,
        cd.connector_name,
        sce.schema_name,
        sce.table_name,
        sce.change_type,
        sce.column_name,
        sce.previous_data_type,
        sce.new_data_type
    from schema_change_events sce
    left join connector_details cd on sce.connection_id = cd.connection_id
    where sce.schema_name is not null
)

select * from enriched_schema_changes
order by change_detected_at desc
        );
      
  