select
    year(report_date) as year,
    count(distinct cert) filter (where total_risk_based_capital_pct = 0) as banks_with_zero_rbc,
    count(distinct cert) filter (where community_bank_leverage_ratio_flag = 1) as banks_with_cblr_flag,
    count(distinct cert) as banks
from {{ ref('stg_fdic__financials') }}
group by 1
order by 1
