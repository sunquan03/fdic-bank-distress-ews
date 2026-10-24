select
    bank_quarter_id,
    cert,
    report_date,
    failure_in_year
from {{ ref('int_bank_quarter_labels') }}
where failure_in_year = 1
order by report_date desc
