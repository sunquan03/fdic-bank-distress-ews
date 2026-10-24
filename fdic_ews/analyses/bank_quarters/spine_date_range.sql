select
    min(report_date) as first_report_date,
    max(report_date) as last_report_date,
    count(distinct report_date) as quarters,
    count(distinct cert) as banks
from {{ ref('int_bank_quarters') }}
