select
    (select count(*) from {{ ref('stg_fdic__financials') }}) as stg_rows,
    (select count(*) from {{ ref('int_bank_quarters') }}) as spine_rows
