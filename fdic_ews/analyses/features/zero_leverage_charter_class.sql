select 
f.charter_class,
count(distinct f.cert) as cnt_banks
from {{ ref('stg_fdic__financials') }} f
where f.leverage_ratio_pct = 0
group by 1