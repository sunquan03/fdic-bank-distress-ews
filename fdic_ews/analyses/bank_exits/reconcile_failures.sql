with exit_failures as (
    select cert, exit_date
    from {{ ref('int_bank_exits') }}
    where exit_type = 'failure'
      and exit_date >= date '2001-01-01'
),
official_failures as (
    select cert, failure_date
    from {{ ref('stg_fdic__failures') }}
    where failure_date >= date '2001-01-01'
)
select
    case
        when e.cert is not null and f.cert is not null then 'both'
        when e.cert is not null then 'only_exits'
        else 'only_failures'
    end as bucket,
    count(*) as banks,
    count(*) filter (where e.exit_date = f.failure_date) as same_date
from exit_failures e
full outer join official_failures f on f.cert = e.cert
group by 1
order by 1
