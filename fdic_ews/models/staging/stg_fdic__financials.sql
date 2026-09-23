
with source as (

    select * from {{ source('fdic_raw', 'financials') }}

),

renamed as (

    select

        --  keys 
        cast(CERT as integer)                               as cert,
        strptime(REPDTE, '%Y%m%d')::date                    as report_date,
        ID                                                  as bank_quarter_id,
        cast(RSSDID as bigint)                              as rssd_id,

        --  identity and structure 
        NAME                                                as bank_name,
        CITY                                                as city,
        STALP                                               as state,
        lpad(cast(ZIP as varchar), 5, '0')                  as zip_code,
        BKCLASS                                             as charter_class,
        REGAGNT                                             as primary_regulator,
        SPECGRPDESC                                         as specialization,
        RSSDHCR                                             as holding_company_rssd_id,
        NAMEHCR                                             as holding_company_name,
        MUTUAL                                              as is_mutual,
        NUMEMP                                              as full_time_employees,
        OFFDOM                                              as domestic_offices,

        try_strptime(cast(ESTYMD as varchar), '%Y%m%d')::date   as established_date,
        try_strptime(INSDATE, '%Y%m%d')::date                   as insured_date,
        ACTIVE                                              as is_active,
        case
            when ENDEFYMD = 99991231 then null
            else try_strptime(cast(ENDEFYMD as varchar), '%Y%m%d')::date
        end                                                 as inactive_date,

        --  balance sheet (thousands usd) 
        ASSET                                               as total_assets,
        LIAB                                                as total_liabilities,
        EQ                                                  as total_equity,
        DEP                                                 as total_deposits,
        DEPDOM                                              as domestic_deposits,
        LNLSGR                                              as gross_loans,
        LNLSNET                                             as net_loans,
        SC                                                  as total_securities,
        CHBAL                                               as cash_and_due,
        FREPO                                               as fed_funds_and_repos_sold,
        TRADE                                               as trading_assets,
        BKPREM                                              as premises_and_fixed_assets,
        ORE                                                 as other_real_estate_owned,
        INTAN                                               as intangible_assets,
        AOA                                                 as all_other_assets,

        -- capital 
        RBC1AAJ                                             as leverage_ratio_pct,
        RBCRWAJ                                             as total_risk_based_capital_pct,
        IDT1RWAJR                                           as tier1_risk_based_capital_pct,
        RBCT1J                                              as tier1_capital,
        RWAJT                                               as risk_weighted_assets,
        CBLRIND                                             as community_bank_leverage_ratio_flag,
        EQV                                                 as equity_to_assets_pct,

        -- asset quality (thousands usd unless _pct) 
        NAASSET                                             as nonaccrual_assets,
        P3ASSET                                             as past_due_30_89_assets,
        P9ASSET                                             as past_due_90_plus_assets,
        NARECONS                                            as nonaccrual_construction,
        NARENRES                                            as nonaccrual_cre_nonres,
        NARERES                                             as nonaccrual_residential,
        NACI                                                as nonaccrual_c_and_i,
        NACON                                               as nonaccrual_consumer,
        LNATRES                                             as loan_loss_allowance,
        ELNATR                                              as provision_for_credit_losses_ytd,
        NTLNLS                                              as net_charge_offs_ytd,
        NTRE                                                as net_charge_offs_real_estate_ytd,
        NTCI                                                as net_charge_offs_c_and_i_ytd,
        NTCON                                               as net_charge_offs_consumer_ytd,
        NTCRCD                                              as net_charge_offs_credit_card_ytd,
        LNATRESR                                            as loan_loss_allowance_to_loans_pct,
        NCLNLSR                                             as noncurrent_loans_to_loans_pct,
        NPERFV                                              as nonperforming_assets_to_assets_pct,

        --loans mix (thousands usd) 
        LNRE                                                as loans_real_estate,
        LNRECONS                                            as loans_construction_and_land,
        LNRENRES                                            as loans_cre_nonres,
        LNRERES                                             as loans_residential_1_4,
        LNREMULT                                            as loans_multifamily,
        LNCI                                                as loans_c_and_i,
        LNCON                                               as loans_consumer,
        LNCRCD                                              as loans_credit_card,
        LNAUTO                                              as loans_auto,
        LNAG                                                as loans_agricultural,

        --  M: management and efficiency (pct / ratio) 
        EEFFR                                               as efficiency_ratio_pct,
        ASTEMPM                                             as assets_per_employee_musd,
        ERNASTR                                             as earning_assets_to_assets_pct,

        -- earnings (thousands USD, YEAR-TO-DATE) 
        NETINC                                              as net_income_ytd,
        INTINC                                              as interest_income_ytd,
        EINTEXP                                             as interest_expense_ytd,
        NIM                                                 as net_interest_income_ytd,
        NONII                                               as noninterest_income_ytd,
        NONIX                                               as noninterest_expense_ytd,
        ITAX                                                as income_taxes_ytd,
        PTAXNETINC                                          as pretax_income_ytd,
        IGLSEC                                              as securities_gains_losses_ytd,
        EQCDIV                                              as cash_dividends_ytd,

        --earnings ratios (pct annualised by FDIC) 
        ROA                                                 as roa_pct,
        ROE                                                 as roe_pct,
        ROAPTX                                              as pretax_roa_pct,
        NIMY                                                as net_interest_margin_pct,
        INTINCY                                             as yield_on_earning_assets_pct,
        INTEXPY                                             as cost_of_funding_earning_assets_pct,
        NONIIAY                                             as noninterest_income_to_assets_pct,
        NONIXAY                                             as noninterest_expense_to_assets_pct,
        ELNATRY                                             as provision_to_assets_pct,

        --   liquidity & funding (thousands usd unless _pct) 
        DEPINS                                              as insured_deposits,
        DEPUNINS                                            as uninsured_deposits,
        COREDEP                                             as core_deposits,
        BRO                                                 as brokered_deposits,
        BROINS                                              as brokered_deposits_insured,
        DEPNIDOM                                            as noninterest_bearing_deposits,
        DEPIDOM                                             as interest_bearing_deposits,
        NTRTIME                                             as time_deposits,
        NTRTMLG                                             as time_deposits_large,
        VOLIAB                                              as volatile_liabilities,
        DEPLSNB                                             as listing_service_deposits,
        OTHBFHLB                                            as fhlb_advances,
        EFHLBADV                                            as fhlb_advance_interest_expense_ytd,
        OTBFH1L                                             as fhlb_advances_1y_or_less,
        LNLSDEPR                                            as loans_to_deposits_pct,
        DEPDASTR                                            as domestic_deposits_to_assets_pct,

        --  Srate sensitivity and securities (thousands usd) 
        SCAA                                                as afs_securities_amortized_cost,
        SCAF                                                as afs_securities_fair_value,
        SCHA                                                as htm_securities_amortized_cost,
        SCHF                                                as htm_securities_fair_value,
        IGLSCA                                              as afs_securities_gains_losses_ytd,
        IGLSCH                                              as htm_securities_gains_losses_ytd,
        SCMUNI                                              as municipal_securities,
        SCEQ                                                as equity_securities,
        SC1LES                                              as debt_securities_maturing_1y_or_less

    from source

)

select * from renamed