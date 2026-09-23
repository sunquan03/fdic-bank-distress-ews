with source as (

    select * from {{ source('fdic_raw', 'failures') }}

),

renamed as (
    select
        -- identifiers
        ID::int                                             as failure_id,
        CERT::int                                           as cert,
        nullif(BANKNO, '')                                  as fdic_bank_number,
        FUND::int                                           as fdic_fund_id,

        -- bank
        NAME                                                as bank_name,
        CITY                                                as city,
        PSTALP                                              as state_code,
        CITYST                                              as city_state,
        CHCLASS                                             as charter_class,
        CHCLASS1                                            as charter_class_1,
        {{ clean_string('URL') }}                           as url,

        -- failure and resolution
        try_strptime(FAILDATE, '%m/%d/%Y')::date            as failure_date,
        FAILYR::int                                         as failure_year,
        try_strptime(RESDATE, '%m/%d/%Y')::date             as resolution_date,
        RESTYPE                                             as resolution_type,
        RESTYPE1                                            as resolution_type_1,
        CLOSCD                                              as closing_code,

        -- acquirer
        BIDNAME                                             as acquirer_name,
        BIDCITY                                             as acquirer_city,
        BIDSTATE                                            as acquirer_state,

        -- money
        QBFDEP                                              as deposits_at_failure,
        QBFASSET                                            as assets_at_failure,
        nullif(UNINSDEP, '')                                as uninsured_deposits,
        COST                                                as estimated_loss,
        
        try_strptime(COSTMOSTRECENTASOF, '%Y-%m-%d')::date  as estimated_loss_as_of_date,

        -- to check
        BSTATUS                                             as bstatus,
        SAVR                                                as savr,
        FIN::int                                            as fin,
        nullif(FSL_PROG, '')                                as fsl_prog,
        try_strptime(TERMI, '%Y-%m-%d')::date               as termi,
        try_strptime(PTRDATE, '%Y-%m-%d')::date             as ptrdate,
        try_strptime(nullif(BRDATE, ''), '%Y-%m-%d')::date  as brdate,

        COMMENTS                                            as comments

    from source
)

select * from renamed









