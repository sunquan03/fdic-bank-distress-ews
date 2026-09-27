{% macro boolean_flag(column_name) %}

    case
        when nullif(trim({{column_name}}::varchar), '') is null then null
        when upper(trim({{column_name}}::varchar)) in ('1', 'Y') then true
        when upper(trim({{column_name}}::varchar)) in ('0', 'N') then false
        else error('boolean_flag: unexpected value in {{ column_name }}')
    end

{% endmacro %}