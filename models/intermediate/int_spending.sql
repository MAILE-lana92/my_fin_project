with trans as (
    select *
    from {{ ref('int_credit_transactions_cated')}}
    where "credit_transaction_type" <> 'Investment'
)
select * from trans