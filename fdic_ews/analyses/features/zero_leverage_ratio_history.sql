{% set cert = 25927 %}
select 
sf.bank_name, 
sf.specialization, 
sf.total_assets, 
sf.gross_loans, 
sf.total_deposits,
f.bank_quarter_id,
f.leverage_ratio_pct,
f.leverage_ratio_pct_4q_chg
from {{ ref('int_bank_quarter_features') }} f 
join {{ ref('int_bank_quarter_labels') }} l on f.bank_quarter_id = l.bank_quarter_id 
join {{ ref('stg_fdic__financials') }} sf on f.bank_quarter_id = sf.bank_quarter_id
where f.cert = {{ cert }}
order by f.report_date desc