select
    bank_quarter_id,
    cert,
    report_date,
    bank_quarter_id = cert || '_' || strftime(report_date, '%Y%m%d') as matches_cert_date
from {{ ref('stg_fdic__financials') }}
