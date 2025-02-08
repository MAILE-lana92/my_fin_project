with trans as (
    select *
    from {{ ref('int_credit_transactions_cated')}}
    where "credit_transaction_type" <> 'Investment'
)
select 
ROW_NUMBER() OVER (ORDER by trans."id", trans."Date") as id
, trans. "Date"
, trans. "Code"
, trans. "Desc"
, trans. "Credit"
, trans. "credit_transaction_type"
from trans