select 
    -- total_deposits
    count(case when f.total_deposits = 0 then 1 end) as total_deposits_zero_cnt,
    count(case when f.total_deposits is null then 1 end) as total_deposits_null_cnt,
    -- brokered_deposits
    count(case when f.brokered_deposits = 0 then 1 end) as brokered_deposits_zero_cnt,
    count(case when f.brokered_deposits is null then 1 end) as brokered_deposits_null_cnt,
    -- total_assets
    count(case when f.total_assets = 0 then 1 end) as total_assets_zero_cnt,
    count(case when f.total_assets is null then 1 end) as total_assets_null_cnt,
    -- core_deposits
    count(case when f.core_deposits = 0 then 1 end) as core_deposits_zero_cnt,
    count(case when f.core_deposits is null then 1 end) as core_deposits_null_cnt,
    -- fhlb_advances
    count(case when f.fhlb_advances = 0 then 1 end) as fhlb_advances_zero_cnt,
    count(case when f.fhlb_advances is null then 1 end) as fhlb_advances_null_cnt,
    -- gross_loans
    count(case when f.gross_loans = 0 then 1 end) as gross_loans_zero_cnt,
    count(case when f.gross_loans is null then 1 end) as gross_loans_null_cnt,
    -- loans_construction_and_land
    count(case when f.loans_construction_and_land = 0 then 1 end) as loans_construction_and_land_zero_cnt,
    count(case when f.loans_construction_and_land is null then 1 end) as loans_construction_and_land_null_cnt
from {{ ref('stg_fdic__financials') }} f
where f.report_date <= '2008-12-31'