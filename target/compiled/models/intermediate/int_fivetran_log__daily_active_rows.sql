with incremental_mar as (
    select * from JASON_CHLETSOS.fivetran_analytics_stg_fivetran_log.stg_fivetran_log__incremental_mar
),

-- Aggregate to daily level
daily_active_rows as (
    select
        measured_date as date_day,
        connection_name,
        destination_id,
        schema_name,
        table_name,
        is_free,
        sum(incremental_rows) as active_rows
    from incremental_mar
    group by 1, 2, 3, 4, 5, 6
)

select * from daily_active_rows