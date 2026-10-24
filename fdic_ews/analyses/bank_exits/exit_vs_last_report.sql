with last_report as (
    select cert, max(report_date) as last_report_date
    from {{ ref('stg_fdic__financials') }}
    group by 1
)
select
    e.exit_type,
    e.exit_change_code,
    count(*) as banks_with_financials,
    count(*) filter (where l.last_report_date > e.exit_date) as reported_after_exit,
    median(date_diff('day', e.exit_date, l.last_report_date))
        filter (where l.last_report_date > e.exit_date) as median_days_after_exit,
    count(*) filter (where l.last_report_date > e.exit_date + interval 1 year) as reported_over_1y_after
from {{ ref('int_bank_exits') }} e
join last_report l on l.cert = e.cert
group by 1, 2
order by 1, 2
