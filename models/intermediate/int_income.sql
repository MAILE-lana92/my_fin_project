with trans as (
    select *
    from {{ ref('int_debit_transactions_cated')}}
    where "debit_transaction_type" <> 'Investment'
)
select * from trans