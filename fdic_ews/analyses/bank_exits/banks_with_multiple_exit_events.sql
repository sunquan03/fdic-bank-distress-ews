with exit_events as (
    select
        coalesce(h.outgoing_cert, h.cert) as cert,
        h.effective_date,
        cc.exit_type
    from {{ ref('stg_fdic__history') }} h
    join {{ ref('change_code_categories') }} cc on cc.change_code = h.change_code
    where h.org_role_code = 'FI'
      and cc.exit_type <> 'not_exit'
),
per_bank as (
    select
        cert,
        count(*) as exit_events,
        string_agg(exit_type, ' -> ' order by effective_date) as exit_sequence
    from exit_events
    group by 1
    having count(*) > 1
)
select
    exit_sequence,
    count(*) as banks
from per_bank
group by 1
order by banks desc
