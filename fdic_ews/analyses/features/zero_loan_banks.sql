with bank_loan_stats as (
    select 
        f.cert,
        count(f.bank_quarter_id) as total_quarters,
        count(case when f.gross_loans = 0 then f.bank_quarter_id end) as zero_loans_quarters
    from {{ ref('stg_fdic__financials') }} f
    group by 1
),
zero_loan_quarters as (
    select 
        f.cert,
        f.bank_quarter_id
    from {{ ref('stg_fdic__financials') }} f
    where f.gross_loans = 0
)
select 
case when s.total_quarters = s.zero_loans_quarters then 'always_zero' else 'sometimes_zero' end as class,
count(distinct q.cert) as banks,
count(q.bank_quarter_id) as zero_loan_rows,
count(case when l.failure_in_year then 1 end) as positive_rows
from zero_loan_quarters q 
join {{ ref('int_bank_quarter_labels') }} l on q.bank_quarter_id = l.bank_quarter_id
join bank_loan_stats s on q.cert = s.cert
group by 1