with connections as (
    
    select * from JASON_CHLETSOS.fivetran_analytics_stg_fivetran_log.stg_fivetran_log__connection

),

destinations as (

    select * from JASON_CHLETSOS.fivetran_analytics_stg_fivetran_log.stg_fivetran_log__destination

),

connector_types as (

    select * from JASON_CHLETSOS.fivetran_analytics_stg_fivetran_log.stg_fivetran_log__connector_type

),

connector_details as (

    select
        connections.connection_id,
        connections.connection_name,
        connections.connector_type_id,
        connector_types.connector_name,
        connections.created_at as connection_created_at,
        connections.destination_id,
        destinations.destination_name,
        connections.is_paused
    from connections
    left join destinations 
        on connections.destination_id = destinations.destination_id
    left join connector_types 
        on connections.connector_type_id = connector_types.connector_type_id

)

select * from connector_details