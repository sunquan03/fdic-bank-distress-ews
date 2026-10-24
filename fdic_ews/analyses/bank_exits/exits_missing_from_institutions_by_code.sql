select
    be.exit_type,
    be.exit_change_code,
    count(*) as banks
from {{ ref('int_bank_exits') }} be
where not exists (select 1 from {{ ref('stg_fdic__institutions') }} i where i.cert = be.cert)
group by 1, 2
order by banks desc
