-- This test ensures that all SQL queries in the project can run without errors
-- It uses a simple SELECT 1 pattern to verify query validity without executing full data processing

{%- set staging_models = [
    'stg_fivetran_log__connection',
    'stg_fivetran_log__connector_type',
    'stg_fivetran_log__destination',
    'stg_fivetran_log__log',
    'stg_fivetran_log__incremental_mar',
    'stg_fivetran_log__transformation_runs',
    'stg_fivetran_log__user'
] -%}

{%- set intermediate_models = [
    'int_fivetran_log__connector_details',
    'int_fivetran_log__sync_events',
    'int_fivetran_log__daily_api_calls',
    'int_fivetran_log__daily_active_rows'
] -%}

{%- set mart_models = [
    'fct_fivetran_connector_health',
    'fct_fivetran_monthly_active_rows',
    'fct_fivetran_connector_recommendations',
    'fct_fivetran_executive_dashboard',
    'fct_fivetran_error_monitoring',
    'fct_fivetran_sync_performance'
] -%}

{%- set models_to_test = staging_models + intermediate_models + mart_models -%}

-- This query will fail if any of the models fail to compile or run
with model_validity as (
    {%- for model in models_to_test -%}
    select 
        '{{ model }}' as model_name,
        case 
            when (select count(*) from {{ ref(model) }} limit 1) >= 0 
            then true 
            else false 
        end as is_valid
        {%- if not loop.last %} union all {% endif -%}
    {%- endfor -%}
)

select * from model_validity where not is_valid