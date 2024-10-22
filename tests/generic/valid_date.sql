{% test valid_date(model, column_name) %}
with validation as (
    select
        {{ column_name }} as date_field
    from {{ model }}
),
validation_errors as (
    select
        date_field
    from validation
    -- Check if the date format matches 'YYYY-MM-DD'
    where date_field IS NOT NULL
      and date_field NOT REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'  -- Adjust regex based on your required format
)
select *
from validation_errors
{% endtest %}