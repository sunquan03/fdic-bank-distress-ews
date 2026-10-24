select
    change_code,
    count(*) as events,
    count(*) filter (where cert = surviving_cert) as cert_is_survivor,
    count(*) filter (where cert = outgoing_cert) as cert_is_outgoing
from {{ ref('stg_fdic__history') }}
where org_role_code = 'FI'
  and change_code in (810, 811, 812)
group by 1
order by 1
