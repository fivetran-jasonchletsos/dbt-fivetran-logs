{% macro check_event_types() %}

{% set query %}
SELECT DISTINCT event_type FROM {{ ref('stg_fivetran_log__log') }}
{% endset %}
{% set results = run_query(query) %}

{% for row in results %}
  {% do log('Event type: ' ~ row[0], info=true) %}
{% endfor %}

{% endmacro %}