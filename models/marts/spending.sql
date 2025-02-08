 with spending as 
 (select
        spending.id
      , spending.trans_date
      , spending.code
      , spending.trans_desc
      , spending.credit as spending_amount
      , spending.credit_transaction_type
 from {{ ref('int_spending') }} spending
 )
 ,cte as (
    select 
     spending.trans_date
    ,spending.credit_transaction_type
    ,sum(spending.spending_amount ) as spending_amount
    from spending
    group by spending.trans_date, spending.credit_transaction_type
 )
    select 
    ROW_NUMBER() OVER (ORDER by cte.trans_date, cte.credit_transaction_type) as id
    ,cte.*
    from cte