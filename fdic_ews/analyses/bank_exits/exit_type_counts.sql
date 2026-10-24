select
    exit_type,
    count(*) as banks
from {{ ref('int_bank_exits') }}
group by 1
order by banks desc
