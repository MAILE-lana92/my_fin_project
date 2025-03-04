with income as (
    select 
    trans_date
    ,sum(income_amount) as amount
    from {{ ref('income') }} income
    group by trans_date
),
spending as (
    select
    trans_date
    ,-1*sum(spending_amount) as amount
    from {{ ref('spending') }} spending
    group by trans_date
),
investment as (
    select 
    trans_date
    ,-1*sum(investment) as amount
    ,sum(investment_return) as return_amount
    from {{ ref('investment')}} investment
    group by trans_date
),
balance as (
    select 
    trans_date
    ,balance
    from {{ ref('balance')}}
),
cte1 as (
    select  case when income.trans_date is not null then income.trans_date
    	else 
    	case when spending.trans_date is not null then spending.trans_date
    	else investment.trans_date
    	end
    	end as trans_date
        ,balance.balance
        ,income.amount as income_amount
        ,spending.amount as spending_amount
        ,investment.amount as investment_amount
        ,investment.return_amount as investment_return_amount
    from income
    full outer join spending
    on income.trans_date = spending.trans_date
    full outer join investment
    on income.trans_date = investment.trans_date
    full outer join balance
    on income.trans_date = balance.trans_date
),
cte as (
select 
cte1.*
,cte1.income_amount + cte1.spending_amount + cte1.investment_amount + cte1.investment_return_amount as net_income
from cte1
)
select ROW_NUMBER() OVER (ORDER by trans_date) as id
,cte.*
from cte