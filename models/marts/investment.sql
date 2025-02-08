 with investment as 
 (select
        investment.id
      , investment.trans_date
      , investment.code
      , investment.trans_desc
      , investment.cashflow_type
      , investment.amount as investment_amount
      , investment.transaction_type
      , investment.investment_category
 from {{ ref('int_investment') }} investment
 ),
 cte1 as (
    select 
    investment.trans_date
    ,investment.cashflow_type
    ,investment.transaction_type
    ,investment.investment_category
    ,sum(investment.investment_amount ) as investment_amount
    from investment
    group by investment.trans_date, investment.cashflow_type, investment.transaction_type, investment.investment_category
 ),
 cte2 as (
      select
      cte1.trans_date
      ,cte1.transaction_type
      ,case when cte1.cashflow_type = 'C' then investment_amount else 0 end as investment
      ,case when cte1.cashflow_type = 'D' then investment_amount else 0 end as investment_return
      ,cte1.investment_category
      from cte1
 )
    select 
    ROW_NUMBER() OVER (ORDER by cte2.trans_date, cte2.investment_category) as id
    ,cte2.*
    from cte2