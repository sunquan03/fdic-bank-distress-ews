with ratios as (
    select 
    f.cert,
    f.report_date,
    f.bank_quarter_id,
    case when f.community_bank_leverage_ratio_flag = 1 or  f.total_risk_based_capital_pct = 0 then null
    else f.total_risk_based_capital_pct end as total_risk_based_capital_pct,
    f.nonperforming_assets_to_assets_pct,
    f.loan_loss_allowance_to_loans_pct,
    f.roa_pct,
    f.net_interest_margin_pct,
    f.efficiency_ratio_pct,
    f.leverage_ratio_pct,
    f.brokered_deposits / nullif(f.total_deposits, 0) * 100 as brokered_deposits_pct,
    f.core_deposits / nullif(f.total_assets, 0) * 100 as core_deposits_pct,
    f.fhlb_advances / nullif(f.total_assets, 0) * 100 as fhlb_advances_to_assets_pct,
    f.loans_construction_and_land / nullif(f.gross_loans, 0) * 100 as construction_concentration_pct
    from {{ ref('stg_fdic__financials') }} f
),
trends as (
    select
    r.bank_quarter_id,
    case when r.report_date - interval 12 month = lag(r.report_date, 4) over (partition by r.cert order by r.report_date)
        then r.core_deposits_pct - lag(r.core_deposits_pct, 4) over (partition by r.cert order by r.report_date)
    else null end as core_deposits_pct_4q_chg, 
    case when r.report_date - interval 12 month = lag(r.report_date, 4) over (partition by r.cert order by r.report_date)
        then r.nonperforming_assets_to_assets_pct - lag(r.nonperforming_assets_to_assets_pct, 4) over (partition by r.cert order by r.report_date)
    else null end as nonperforming_assets_to_assets_pct_4q_chg,
    case when r.report_date - interval 12 month = lag(r.report_date, 4) over (partition by r.cert order by r.report_date)
        then r.roa_pct - lag(r.roa_pct, 4) over (partition by r.cert order by r.report_date)
    else null end as roa_pct_4q_chg,
    case when r.report_date - interval 12 month = lag(r.report_date, 4) over (partition by r.cert order by r.report_date)
        then r.total_risk_based_capital_pct - lag(r.total_risk_based_capital_pct, 4) over (partition by r.cert order by r.report_date)
    else null end as total_risk_based_capital_pct_4q_chg,
    case when r.report_date - interval 12 month = lag(r.report_date, 4) over (partition by r.cert order by r.report_date)
        then r.leverage_ratio_pct - lag(r.leverage_ratio_pct, 4) over (partition by r.cert order by r.report_date)
    else null end as leverage_ratio_pct_4q_chg
    from ratios r
)
select 
    r.cert,
    r.report_date,
    r.bank_quarter_id,
    r.total_risk_based_capital_pct,
    r.nonperforming_assets_to_assets_pct,
    r.loan_loss_allowance_to_loans_pct,
    r.roa_pct,
    r.net_interest_margin_pct,
    r.efficiency_ratio_pct,
    r.brokered_deposits_pct,
    r.core_deposits_pct,
    r.fhlb_advances_to_assets_pct,
    r.construction_concentration_pct,
    r.leverage_ratio_pct,
    t.core_deposits_pct_4q_chg,
    t.nonperforming_assets_to_assets_pct_4q_chg,
    t.roa_pct_4q_chg,
    t.total_risk_based_capital_pct_4q_chg,
    t.leverage_ratio_pct_4q_chg
from ratios r
join trends t on r.bank_quarter_id = t.bank_quarter_id