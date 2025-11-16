{% macro get_row_counts() %}

{% set source_query %}
SELECT 'Source: connection' as table_name, COUNT(*) as row_count FROM {{ source('fivetran_log', 'connection') }}
{% endset %}
{% set source_results = run_query(source_query) %}
{% do log('Source: connection - ' ~ source_results.columns[1].values()[0], info=true) %}

{% set source_query %}
SELECT 'Source: log' as table_name, COUNT(*) as row_count FROM {{ source('fivetran_log', 'log') }}
{% endset %}
{% set source_results = run_query(source_query) %}
{% do log('Source: log - ' ~ source_results.columns[1].values()[0], info=true) %}

{% set source_query %}
SELECT 'Source: incremental_mar' as table_name, COUNT(*) as row_count FROM {{ source('fivetran_log', 'incremental_mar') }}
{% endset %}
{% set source_results = run_query(source_query) %}
{% do log('Source: incremental_mar - ' ~ source_results.columns[1].values()[0], info=true) %}

{% set staging_query %}
SELECT 'Staging: stg_fivetran_log__log' as table_name, COUNT(*) as row_count FROM {{ ref('stg_fivetran_log__log') }}
{% endset %}
{% set staging_results = run_query(staging_query) %}
{% do log('Staging: stg_fivetran_log__log - ' ~ staging_results.columns[1].values()[0], info=true) %}

{% set int_query %}
SELECT 'Intermediate: int_fivetran_log__sync_events' as table_name, COUNT(*) as row_count FROM {{ ref('int_fivetran_log__sync_events') }}
{% endset %}
{% set int_results = run_query(int_query) %}
{% do log('Intermediate: int_fivetran_log__sync_events - ' ~ int_results.columns[1].values()[0], info=true) %}

{% set mart_query %}
SELECT 'Mart: fct_fivetran_sync_performance' as table_name, COUNT(*) as row_count FROM {{ ref('fct_fivetran_sync_performance') }}
{% endset %}
{% set mart_results = run_query(mart_query) %}
{% do log('Mart: fct_fivetran_sync_performance - ' ~ mart_results.columns[1].values()[0], info=true) %}

{% endmacro %}