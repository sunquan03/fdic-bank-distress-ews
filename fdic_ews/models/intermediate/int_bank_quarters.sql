select 
    bank_quarter_id, 
    cert, 
    report_date 
from {{ ref('stg_fdic__financials') }}
