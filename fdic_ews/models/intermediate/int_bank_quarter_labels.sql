with data_end as (
    select max(report_date) as max_report_date
    from {{ ref('int_bank_quarters') }}
)
select 
    q.bank_quarter_id, 
    q.cert, 
    q.report_date,
    case 
        when q.report_date + INTERVAL 12 MONTH > de.max_report_date then NULL
        when  q.report_date + INTERVAL 12 MONTH >= be.exit_date
         and q.report_date < be.exit_date
         and be.exit_type in ('failure', 'assisted') then 1
        else 0 end as failure_in_year
from {{ ref('int_bank_quarters') }} q
left join {{ ref('int_bank_exits') }} be on q.cert = be.cert
cross join data_end de