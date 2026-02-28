{% macro trim_quotes_all(table_ref) %}
  {%- set columns = adapter.get_columns_in_relation(table_ref) -%}
  
  {% for col in columns %}
    trim({{ col.column }}, '"') as {{ col.column }}{% if not loop.last %},{% endif %}
  {% endfor %}
  
{% endmacro %}