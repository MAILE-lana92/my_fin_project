with trans as (
    select *
    from {{ ref('int_debit_transactions_cated')}}
    where debit_transaction_type <> 'Investment'
)
select 
ROW_NUMBER() OVER (ORDER by trans."id", trans.trans_date) as id
, trans. trans_date
, trans. code
, trans. trans_desc
, trans. debit
, trans. debit_transaction_type
from trans