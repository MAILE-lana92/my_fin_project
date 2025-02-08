with trans as (
    select *
    from {{ ref('int_debit_transactions_cated')}}
    where "debit_transaction_type" <> 'Investment'
)
select 
ROW_NUMBER() OVER (ORDER by trans."id", trans."Date") as id
, trans. "Date"
, trans. "Code"
, trans. "Desc"
, trans. "Debit"
, trans. "debit_transaction_type"
from trans