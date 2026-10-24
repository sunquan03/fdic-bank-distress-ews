select
    failure_in_year,
    count(*) as rows,
    round(100.0 * count(*) / sum(count(*)) over (), 2) as pct_of_all_rows
from {{ ref('int_bank_quarter_labels') }}
group by 1
order by 1 nulls first
