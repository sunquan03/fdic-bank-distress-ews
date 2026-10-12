with exit_data as (
    select 
        coalesce(h.outgoing_cert, h.cert) as cert, 
        h.transaction_number,
        h.effective_date as exit_date, 
        h.change_code as exit_change_code, 
        cc.exit_type
    from {{ ref('stg_fdic__history') }} h
    join {{ ref('change_code_categories') }} cc on cc.change_code = h.change_code 
    where h.org_role_code = 'FI'
)
select x.cert, x.exit_date, x.exit_change_code, x.exit_type
from 
(select 
    e.cert,
    e.exit_date,
    e.exit_change_code,
    e.exit_type,
    row_number() over (partition by e.cert 
                       order by e.exit_date,
                                case e.exit_type 
                                    when 'failure' then 1
                                    when 'assisted' then 2
                                    else 3 end,
                                e.transaction_number
                       ) as rn
 from exit_data e
 where e.exit_type <> 'not_exit') x
where x.rn=1 


