{% macro check_monthly_active_rows() %}

{% set query %}
SELECT COUNT(*) as row_count FROM {{ ref('fct_fivetran_monthly_active_rows') }}
{% endset %}
{% set results = run_query(query) %}

{% do log('Monthly Active Rows row count: ' ~ results.columns[0].values()[0], info=true) %}

{% if results.columns[0].values()[0] > 0 %}
  {% set sample_query %}
  SELECT * FROM {{ ref('fct_fivetran_monthly_active_rows') }} LIMIT 5
  {% endset %}
  {% set sample_results = run_query(sample_query) %}
  
  {% for row in sample_results %}
    {% do log('Sample row: month=' ~ row[0] ~ ', connection=' ~ row[1] ~ ', schema=' ~ row[3] ~ ', table=' ~ row[4] ~ ', rows=' ~ row[7], info=true) %}
  {% endfor %}
{% endif %}

{% endmacro %}