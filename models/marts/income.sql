 with income as 
 (select
        income."id"
      , income."Date"
      , income."Code"
      , income."Desc"
      , income."Debit" as Income_Amount
      , income.debit_transaction_type
 from {{ ref('int_income') }} income
 )
    select 
    ROW_NUMBER() OVER (ORDER by income."Date", income."id") as id
    ,income."Date"
    ,income."debit_transaction_type"
    ,sum(income."income_amount" ) as income_Amount
    from income
    group by income."id", income."Date", income."debit_transaction_type"