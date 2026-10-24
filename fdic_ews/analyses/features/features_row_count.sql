select
    (select count(*) from {{ ref('int_bank_quarters') }}) as spine_rows,
    (select count(*) from {{ ref('int_bank_quarter_features') }}) as feature_rows
