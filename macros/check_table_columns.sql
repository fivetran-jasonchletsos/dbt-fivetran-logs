{% macro check_table_columns(table_name) %}

{% set query %}
SELECT column_name
FROM information_schema.columns
WHERE table_schema = 'JASON_CHLETSOS.JASON_CHLETSOS_FIVETRAN_LOG'
AND table_name = '{{ table_name }}'
{% endset %}
{% set results = run_query(query) %}

{% do log('Columns for ' ~ table_name ~ ':', info=true) %}
{% for row in results %}
  {% do log('- ' ~ row[0], info=true) %}
{% endfor %}

{% endmacro %}