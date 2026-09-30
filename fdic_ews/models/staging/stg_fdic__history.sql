with source as (

    select * from {{ source('fdic_raw', 'history') }}

),
renamed as (
    select 

    TRANSNUM                                                                            as transaction_number,
    CERT                                                                                as cert,
    INSTNAME                                                                            as bank_name,

    CHANGECODE	                                                                        as change_code,
    CHANGECODE_DESC                                                                     as change_code_desc,
    try_strptime(EFFDATE, '%Y-%m-%dT%H:%M:%S')::date                                    as effective_date,
    ORG_ROLE_CDE                                                                        as org_role_code,
    ACQ_CERT                                                                            as acquirer_cert, 
    ACQ_INSTNAME                                                                        as acquirer_name,
    OUT_CERT                                                                            as outgoing_cert, 
    OUT_INSTNAME                                                                        as outgoing_name,
    SUR_CERT                                                                            as surviving_cert, 
    SUR_INSTNAME                                                                        as surviving_name,
    FRM_CERT                                                                            as previous_cert,

    try_strptime(PROCDATE, '%Y-%m-%dT%H:%M:%S')::date                                   as process_date,
    try_strptime(nullif(ENDDATE, '9999-12-31T00:00:00'), '%Y-%m-%dT%H:%M:%S')::date     as end_date,
    {{ boolean_flag('BANK_INSURED') }}                                                  as is_insured, 
    cast(REPORT_TYPE as integer)                                                        as report_type,
    SUR_CHANGECODE                                                                      as surviving_change_code, 
    SUR_CHANGECODE_DESC                                                                 as surviving_change_code_desc

    from source
)

select * from renamed