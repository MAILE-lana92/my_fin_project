with 
all_trans as (
    select trans."Date"
    ,trans."Code"
    ,trans."Desc"
    ,trans."Balance"
    from {{ ref('stg_transaction') }} trans
)
select * from all_trans