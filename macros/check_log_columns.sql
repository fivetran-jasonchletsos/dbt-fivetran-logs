{% macro check_log_columns() %}

{% set query %}
SELECT column_name
FROM information_schema.columns
WHERE table_schema = 'FIVETRAN_ANALYTICS_STG_FIVETRAN_LOG'
AND table_name = 'STG_FIVETRAN_LOG__LOG'
{% endset %}
{% set results = run_query(query) %}

{% for row in results %}
  {% do log('Column name: ' ~ row[0], info=true) %}
{% endfor %}

{% endmacro %}