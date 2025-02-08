with 
all_trans as (
    select * from {{ ref('stg_transaction') }}
),
credit_trans as (
    select  ROW_NUMBER() OVER (ORDER BY trans."Date", trans."No") AS  id
    ,trans."Date"
    ,trans."Code"
    ,trans."Desc"
    ,trans."Credit"
from all_trans trans
    where trans."Credit" > 0
)
select * from credit_trans