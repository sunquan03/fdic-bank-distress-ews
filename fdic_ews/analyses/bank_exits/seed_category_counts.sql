select
    exit_type,
    count(*) as codes,
    string_agg(cast(change_code as varchar), ', ' order by change_code) as code_list
from {{ ref('change_code_categories') }}
group by 1
order by 1
