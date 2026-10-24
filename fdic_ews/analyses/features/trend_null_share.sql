select
    count(*) as rows,
    round(100.0 * count(*) filter (where core_deposits_pct_4q_chg is null) / count(*), 1) as core_deposits_chg_null_pct,
    round(100.0 * count(*) filter (where nonperforming_assets_to_assets_pct_4q_chg is null) / count(*), 1) as npa_chg_null_pct,
    round(100.0 * count(*) filter (where roa_pct_4q_chg is null) / count(*), 1) as roa_chg_null_pct,
    round(100.0 * count(*) filter (where total_risk_based_capital_pct_4q_chg is null) / count(*), 1) as rbc_chg_null_pct,
    round(100.0 * count(*) filter (where leverage_ratio_pct_4q_chg is null) / count(*), 1) as leverage_chg_null_pct
from {{ ref('int_bank_quarter_features') }}
