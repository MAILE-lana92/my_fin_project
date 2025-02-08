with credit_invest as (
    select 
    ROW_NUMBER() OVER (ORDER by credit."Date", credit."id") as id
    ,credit."Date"
    ,credit."Code"
    ,credit."Desc"
    , 'C' as trans_type
    ,credit."Credit" as amount
    ,credit."credit_transaction_type" as transaction_type
    ,{{ investment_categorize('credit."Desc"') }} as "investment_category"
    from {{ ref('int_credit_transactions_cated') }} credit 
    where "credit_transaction_type" = 'Investment'
),
debit_invest as (
    select 
    ROW_NUMBER() OVER (ORDER by debit."Date", debit."id") as id
    ,debit."Date"
    ,debit."Code"
    ,debit."Desc"
    , 'D' as trans_type
    , debit."Debit" as amount
    ,debit."debit_transaction_type"  as transaction_type
    ,{{ investment_categorize('debit."Desc"') }} as "investment_category"
    from {{ ref('int_debit_transactions_cated') }} debit 
    where "debit_transaction_type" = 'Investment'
)
select * from credit_invest
union all
select * from debit_invest