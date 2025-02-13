-- base transitions that were manually converted from the pass 3 years.
with source as (
    select 
    trans. "No" as id
    ,trans."Date" as trans_date
    ,trans."Code" as code
    ,trans."Desc" as trans_desc
    ,cast(trans."Credit" as int) as credit
    ,cast(trans."Debit" as int) as debit
    ,cast(trans."Balance" as int) as balance
    from {{ ref('base_transaction') }} trans
    ) 
select * from source