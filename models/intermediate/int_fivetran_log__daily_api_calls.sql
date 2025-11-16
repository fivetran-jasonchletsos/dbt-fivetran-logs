with logs as (
    select * from {{ ref('stg_fivetran_log__log') }}
),

connections as (
    select * from {{ ref('stg_fivetran_log__connection') }}
),

-- Filter to API call events
api_calls as (
    select
        connection_id,
        date_trunc('day', logged_at) as date_day,
        count(*) as api_calls_count
    from logs
    where event_type = 'api_call'
    group by 1, 2
),

-- Join with connection information
enriched_api_calls as (
    select
        a.date_day,
        a.connection_id,
        c.connection_name,
        c.destination_id,
        a.api_calls_count
    from api_calls a
    left join connections c on a.connection_id = c.connection_id
)

select * from enriched_api_calls