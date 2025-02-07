with 
all_trans as (
    select * from {{ ref('stg_transaction') }}
),
debit_trans as (
    select  ROW_NUMBER() OVER (ORDER BY trans."Date", trans."No") AS  id
    ,trans."Date"
    ,trans."Code"
    ,trans."Desc"
    ,trans."Debit"
    ,trans."Balance"
from all_trans trans
    where trans."Debit" > 0
)
select * from debit_trans