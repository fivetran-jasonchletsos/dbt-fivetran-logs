{% macro check_sync_performance() %}

{% set query %}
SELECT COUNT(*) as row_count FROM {{ ref('fct_fivetran_sync_performance') }}
{% endset %}
{% set results = run_query(query) %}

{% do log('Sync Performance row count: ' ~ results.columns[0].values()[0], info=true) %}

{% if results.columns[0].values()[0] > 0 %}
  {% set sample_query %}
  SELECT * FROM {{ ref('fct_fivetran_sync_performance') }} LIMIT 5
  {% endset %}
  {% set sample_results = run_query(sample_query) %}
  
  {% for row in sample_results %}
    {% do log('Sample row: sync_id=' ~ row[0] ~ ', connection=' ~ row[2] ~ ', status=' ~ row[8], info=true) %}
  {% endfor %}
{% endif %}

{% endmacro %}