with credit_invest as (
    select 
    ROW_NUMBER() OVER (ORDER by credit.trans_date, credit.id) as id
    ,credit.trans_date
    ,credit.code
    ,credit.trans_desc
    , 'C' as cashflow_type
    ,credit.credit as amount
    ,credit.credit_transaction_type as transaction_type
    ,{{ investment_categorize('credit.trans_desc') }} as "investment_category"
    from {{ ref('int_credit_transactions_cated') }} credit 
    where credit_transaction_type = 'Investment'
),
debit_invest as (
    select 
    ROW_NUMBER() OVER (ORDER by debit.trans_date, debit.id) as id
    ,debit.trans_date
    ,debit.code
    ,debit.trans_desc
    , 'D' as cashflow_type
    ,debit.debit as amount
    ,debit.debit_transaction_type  as transaction_type
    ,{{ investment_categorize('debit.trans_desc') }} as "investment_category"
    from {{ ref('int_debit_transactions_cated') }} debit 
    where debit_transaction_type = 'Investment'
),
cte as (
select * from credit_invest
union all
select * from debit_invest
)
select 
ROW_NUMBER() OVER (ORDER by cte.trans_date, cte.id) as id
,cte.trans_date
,cte.code
,cte.trans_desc
,cte.cashflow_type
,cte.amount
,cte.transaction_type
,cte.investment_category
from cte