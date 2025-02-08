 with income as 
 (select
        income."id"
      , income."Date"
      , income."Code"
      , income."Desc"
      , income."Debit" as Income_Amount
      , debit_transaction_type
 from {{ ref('int_income') }} income
 )
    select 
    ROW_NUMBER() OVER (ORDER by income."Date", income."id") as id
    ,income."Date"
    ,income."Debit_Transaction_Type"
    ,sum(income."income_Amount" ) as income_Amount
    from income
    group by income."id", income."Date", income."Debit_Transaction_Type"