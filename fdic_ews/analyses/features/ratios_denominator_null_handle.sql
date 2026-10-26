select 
    -- total_deposits
    count(case when f.total_deposits = 0 then 1 end) as total_deposits_zero_cnt,
    count(case when f.total_deposits is null then 1 end) as total_deposits_null_cnt,
    -- total_assets
    count(case when f.total_assets = 0 then 1 end) as total_assets_zero_cnt,
    count(case when f.total_assets is null then 1 end) as total_assets_null_cnt,
    -- gross_loans
    count(case when f.gross_loans = 0 then 1 end) as gross_loans_zero_cnt,
    count(case when f.gross_loans is null then 1 end) as gross_loans_null_cnt
from {{ ref('stg_fdic__financials') }} f