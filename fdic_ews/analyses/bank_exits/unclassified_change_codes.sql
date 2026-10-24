select
    h.change_code,
    any_value(h.change_code_desc) as change_code_desc,
    count(*) as events
from {{ ref('stg_fdic__history') }} h
left join {{ ref('change_code_categories') }} cc on cc.change_code = h.change_code
where h.org_role_code = 'FI'
  and cc.change_code is null
group by 1
order by events desc
