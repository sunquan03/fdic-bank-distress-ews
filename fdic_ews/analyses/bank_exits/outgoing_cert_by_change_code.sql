select
    h.change_code,
    cc.exit_type,
    count(*) as events,
    count(h.outgoing_cert) as outgoing_cert_filled,
    count(*) filter (where h.outgoing_cert is not null and h.outgoing_cert <> h.cert) as outgoing_differs_from_cert
from {{ ref('stg_fdic__history') }} h
join {{ ref('change_code_categories') }} cc on cc.change_code = h.change_code
where h.org_role_code = 'FI'
  and cc.exit_type <> 'not_exit'
group by 1, 2
order by 2, 1
