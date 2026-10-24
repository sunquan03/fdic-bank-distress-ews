select 
    f.cert,
    f.report_date,
    f.bank_quarter_id,
    l.failure_in_year,
    f.total_risk_based_capital_pct,
    f.nonperforming_assets_to_assets_pct,
    f.loan_loss_allowance_to_loans_pct,
    f.roa_pct,
    f.net_interest_margin_pct,
    f.efficiency_ratio_pct,
    f.brokered_deposits_pct,
    f.core_deposits_pct,
    f.fhlb_advances_to_assets_pct,
    f.construction_concentration_pct,
    f.leverage_ratio_pct,
    f.core_deposits_pct_4q_chg,
    f.nonperforming_assets_to_assets_pct_4q_chg,
    f.roa_pct_4q_chg,
    f.total_risk_based_capital_pct_4q_chg,
    f.leverage_ratio_pct_4q_chg
from {{ ref('int_bank_quarter_features') }} f
join {{ ref('int_bank_quarter_labels') }} l on f.bank_quarter_id = l.bank_quarter_id
where l.failure_in_year is not null
