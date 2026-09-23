{% macro clean_string(column_name) %}
    case
        when lower(trim({{ column_name }})) in ('na', 'n/a', 'null', 'none', '-', '')
            then null
        else trim({{ column_name }})
    end
{% endmacro %}