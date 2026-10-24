{% set cert = 5520 %}
select
    qf.cert,
    qf.report_date,
    f.total_risk_based_capital_pct as raw_risk_based_capital_pct,
    qf.total_risk_based_capital_pct,
    qf.total_risk_based_capital_pct_4q_chg,
    qf.leverage_ratio_pct,
    qf.leverage_ratio_pct_4q_chg,
    f.community_bank_leverage_ratio_flag
from {{ ref('int_bank_quarter_features') }} qf
join {{ ref('stg_fdic__financials') }} f on f.bank_quarter_id = qf.bank_quarter_id
where qf.cert = {{ cert }}
order by qf.report_date desc
