{{ config(
    materialized = 'table'
) }}

with audit_trail as (
    select * from {{ ref('stg_fivetran_log__audit_trail') }}
),

users as (
    select * from {{ ref('stg_fivetran_log__user') }}
),

connector_details as (
    select * from {{ ref('int_fivetran_log__connector_details') }}
),

-- Get all audit trail events - NO FILTERING
user_activity_events as (
    select
        at.event_created_at,
        at.user_id,
        at.event_type as action_type,
        at.resource_type,
        at.resource_id,
        at.secondary_resource_type,
        at.secondary_resource_id,
        at.interaction_method,
        at.old_values,
        at.new_values
    from audit_trail at
),

-- Aggregate by date and user
aggregated_activity as (
    select
        date_trunc('day', event_created_at) as activity_date,
        user_id,
        action_type,
        resource_type,
        resource_id as resource_name,
        secondary_resource_type,
        secondary_resource_id as secondary_resource_name,
        interaction_method,
        count(*) as activity_count
    from user_activity_events
    group by 1, 2, 3, 4, 5, 6, 7, 8
),

-- Enrich with user information and connector details
enriched_user_activity as (
    select
        aa.activity_date,
        coalesce(aa.user_id, 'unknown') as user_id,
        coalesce(u.email, 'unknown') as user_email,
        coalesce(concat(u.first_name, ' ', u.last_name), 'Unknown User') as user_name,
        aa.action_type,
        aa.resource_type,
        aa.resource_name,
        aa.secondary_resource_type,
        aa.secondary_resource_name,
        aa.interaction_method,
        aa.activity_count,
        -- Add connector details when resource is a connector
        case 
            when aa.resource_type = 'connector' then cd.connection_name
            else null
        end as connector_name,
        case 
            when aa.resource_type = 'connector' then cd.connector_name
            else null
        end as connector_type,
        case 
            when aa.resource_type = 'connector' then cd.destination_name
            else null
        end as destination_name
    from aggregated_activity aa
    left join users u on aa.user_id = u.user_id
    -- Join to connector details when resource is a connector
    left join connector_details cd on 
        aa.resource_type = 'connector' and 
        aa.resource_name = cd.connection_id
)

select * from enriched_user_activity
order by activity_date desc, user_email, action_type