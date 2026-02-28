{% test no_double_quotes(model, column_name) %}

with validation as (
    select
        {{ column_name }} as field
    from {{ model }}
)

select
    field
from validation
-- This will return rows that still have a " at the start or end
where field like '"%' 
   or field like '%"'

{% endtest %}