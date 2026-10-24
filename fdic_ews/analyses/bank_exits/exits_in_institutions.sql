select
    be.exit_type,
    case
        when exists (select 1 from {{ ref('stg_fdic__institutions') }} i where i.cert = be.cert) then 'exist'
        else 'not_exist'
    end as status,
    count(*) as banks
from {{ ref('int_bank_exits') }} be
group by 1, 2
order by 1, 2
