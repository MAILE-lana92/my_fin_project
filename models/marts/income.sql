 with income as 
 (select
        income.id
      , income.trans_date
      , income.code
      , income.trans_desc
      , income.debit as income_amount
      , income.debit_transaction_type
 from {{ ref('int_income') }} income
 )
 ,cte as (
    select 
     income.trans_date
    ,income.debit_transaction_type
    ,sum(income.income_amount ) as income_Amount
    from income
    group by income.trans_date, income.debit_transaction_type
 )
    select 
    ROW_NUMBER() OVER (ORDER by cte.trans_date, cte.debit_transaction_type) as id
    ,cte.*
    from cte