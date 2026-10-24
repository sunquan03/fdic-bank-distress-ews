{% set cert = 5520 %}
select
    l.cert,
    l.report_date,
    l.failure_in_year,
    e.exit_date,
    e.exit_type
from {{ ref('int_bank_quarter_labels') }} l
left join {{ ref('int_bank_exits') }} e on e.cert = l.cert
where l.cert = {{ cert }}
order by l.report_date desc
