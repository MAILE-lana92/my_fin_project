 with spending as 
 (select
        spending."id"
      , spending."Date"
      , spending."Code"
      , spending."Desc"
      , spending."Credit" as Spending_Amount
      , spending.credit_transaction_type
 from {{ ref('int_spending') }} spending
 )
    select 
    ROW_NUMBER() OVER (ORDER by spending."Date", spending."id") as id
    ,spending."Date"
    ,spending."credit_transaction_type"
    ,sum(spending."spending_amount" ) as Spending_Amount
    from spending
    group by spending."id", spending."Date", spending."credit_transaction_type"