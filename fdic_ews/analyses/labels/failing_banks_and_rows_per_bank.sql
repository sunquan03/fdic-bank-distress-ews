select
    count(distinct cert) as failing_banks,
    count(*) as positive_rows,
    round(count(*) * 1.0 / count(distinct cert), 2) as positive_rows_per_bank
from {{ ref('int_bank_quarter_labels') }}
where failure_in_year = 1
