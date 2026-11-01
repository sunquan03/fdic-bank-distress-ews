with zero_leverage as (
    select 
        f.cert, 
        f.bank_quarter_id,
        l.failure_in_year
    from {{ ref('int_bank_quarter_features') }} f
    join {{ ref('int_bank_quarter_labels') }} l on f.bank_quarter_id = l.bank_quarter_id
    where f.report_date <= '2008-12-31'
    and f.leverage_ratio_pct = 0
)
select 
    count(distinct zl.cert) as cnt_banks,
    count(zl.bank_quarter_id) as cnt_quarters, 
    count(case when zl.failure_in_year = 1 then 1 end) as cnt_failure_quarters
from zero_leverage zl