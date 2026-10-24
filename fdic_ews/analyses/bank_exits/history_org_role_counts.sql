select
    org_role_code,
    count(*) as events,
    count(distinct cert) as banks
from {{ ref('stg_fdic__history') }}
group by 1
order by events desc
