{% macro check_connector_health() %}

{% set query %}
SELECT COUNT(*) as row_count FROM {{ ref('fct_fivetran_connector_health') }}
{% endset %}
{% set results = run_query(query) %}

{% do log('Connector Health row count: ' ~ results.columns[0].values()[0], info=true) %}

{% if results.columns[0].values()[0] > 0 %}
  {% set sample_query %}
  SELECT * FROM {{ ref('fct_fivetran_connector_health') }} LIMIT 5
  {% endset %}
  {% set sample_results = run_query(sample_query) %}
  
  {% for row in sample_results %}
    {% do log('Sample row: connection=' ~ row[0] ~ ', connector=' ~ row[1] ~ ', status=' ~ row[6], info=true) %}
  {% endfor %}
{% endif %}

{% endmacro %}