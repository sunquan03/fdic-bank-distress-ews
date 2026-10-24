select
    change_code,
    any_value(change_code_desc) as change_code_desc,
    count(*) as events
from {{ ref('stg_fdic__history') }}
where org_role_code = 'FI'
group by 1
order by 1
