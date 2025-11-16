
  
    

        create or replace transient table JASON_CHLETSOS.fivetran_analytics_fct_fivetran_logs.fct_fivetran_user_activity
         as
        (

with logs as (
    select * from JASON_CHLETSOS.fivetran_analytics_stg_fivetran_log.stg_fivetran_log__log
),

users as (
    select * from JASON_CHLETSOS.fivetran_analytics_stg_fivetran_log.stg_fivetran_log__user
),

connector_details as (
    select * from JASON_CHLETSOS.fivetran_analytics_int_fivetran_log.int_fivetran_log__connector_details
),

-- Extract user activity events from logs
user_activity_events as (
    select
        logged_at,
        connection_id,
        event_type,
        message_type,
        message_content
    from logs
    where event_type in ('user_action', 'account_modification', 'setup')
),

-- Categorize user actions
categorized_actions as (
    select
        date_trunc('day', logged_at) as activity_date,
        connection_id,
        -- Determine action type
        case
            when message_type like '%create%' then 'Create'
            when message_type like '%update%' then 'Update'
            when message_type like '%delete%' then 'Delete'
            when message_type like '%enable%' then 'Enable'
            when message_type like '%disable%' then 'Disable'
            when message_type like '%pause%' then 'Pause'
            when message_type like '%resume%' then 'Resume'
            when message_type like '%sync%' then 'Sync'
            when message_type like '%login%' then 'Login'
            else 'Other'
        end as action_type,
        -- Determine resource type
        case
            when message_type like '%connection%' then 'Connection'
            when message_type like '%destination%' then 'Destination'
            when message_type like '%schema%' then 'Schema'
            when message_type like '%table%' then 'Table'
            when message_type like '%user%' then 'User'
            when message_type like '%account%' then 'Account'
            else 'Other'
        end as resource_type,
        -- Extract user information if available
        regexp_substr(message_content, 'by user ([^\\s]+)', 1, 1, 'e') as user_email,
        -- Extract resource name if available
        case
            when message_type like '%connection%' then 
                regexp_substr(message_content, 'connection ([^\\s]+)', 1, 1, 'e')
            when message_type like '%destination%' then 
                regexp_substr(message_content, 'destination ([^\\s]+)', 1, 1, 'e')
            when message_type like '%schema%' then 
                regexp_substr(message_content, 'schema ([^\\s]+)', 1, 1, 'e')
            when message_type like '%table%' then 
                regexp_substr(message_content, 'table ([^\\s]+)', 1, 1, 'e')
            else null
        end as resource_name,
        count(*) as activity_count
    from user_activity_events
    group by 1, 2, 3, 4, 5, 6
),

-- Enrich with user and connection information
enriched_user_activity as (
    select
        ca.activity_date,
        coalesce(u.user_id, 'unknown') as user_id,
        coalesce(ca.user_email, u.email, 'unknown') as user_email,
        concat(coalesce(u.first_name, ''), ' ', coalesce(u.last_name, '')) as user_name,
        ca.action_type,
        ca.resource_type,
        coalesce(ca.resource_name, cd.connection_name, 'unknown') as resource_name,
        ca.activity_count
    from categorized_actions ca
    left join users u on ca.user_email = u.email
    left join connector_details cd on ca.connection_id = cd.connection_id
)

select * from enriched_user_activity
order by activity_date desc, user_email, action_type
        );
      
  