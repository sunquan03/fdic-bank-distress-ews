with source as (

    select * from {{ source('fdic_raw', 'institutions') }}
),

renamed as (
    select 
    
    -- keys
    cast(CERT as integer)                                           as cert,
    NAME                                                            as bank_name,
    FED_RSSD                                                        as fed_rssd,
    BKCLASS                                                         as charter_class,
    strptime(ESTYMD,'%m/%d/%Y')::date                               as established_date,
    strptime(INSDATE, '%m/%d/%Y')::date                             as insurance_date,

    -- location
    CITY                                                            as city, 
    STALP                                                           as state_code, 
    ZIP                                                             as zip_code,

    -- defining data
    {{ boolean_flag('ACTIVE') }}                                    as is_active,
    {{ boolean_flag('INACTIVE') }}                                  as is_inactive,
    strptime(nullif(ENDEFYMD, '12/31/9999'), '%m/%d/%Y')::date      as end_effective_date,
    CHANGEC1                                                        as last_change_code,
    cast(NEWCERT as integer)                                        as new_cert,
    cast(ULTCERT as integer)                                        as ult_cert,
    strptime(nullif(INSDROPDATE, ''), '%m/%d/%Y')::date             as insurance_drop_date,

    -- ownership and structure
    nullif(RSSDHCR, '')                                             as top_holding_company_id, 
    nullif(NAMEHCR, '')                                             as top_holding_company_name,
    try_cast(nullif(PARCERT, '0') as int)                           as parent_bank_cert,
    CHRTAGNT                                                        as chartering_agency,
    REGAGNT                                                         as primary_fed_regulator,
    nullif(INSAGNT1, 'NONE')                                        as depo_insurance_fund,
    {{ boolean_flag('MUTUAL') }}                                    as is_mutual,
    {{ boolean_flag('DENOVO') }}                                    as is_de_novo,
    {{ boolean_flag('CB') }}                                        as is_community_bank_leverage_ratio,
    SPECGRP                                                         as spec_group_code,
    SPECGRPN                                                        as spec_group_name,
    {{ boolean_flag('CONSERVE') }}                                  as is_in_conservation

    from source
)

select * from renamed


