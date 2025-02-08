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
    ,sum(spending_amount) as amount
    from {{ ref('spending') }} spending
    group by trans_date
),
investment as (
    select 
    trans_date
    , sum(investment) as amount
    from {{ ref('investment')}} investment
    group by trans_date
),
cte as (
    select  case when income.trans_date is not null then income.trans_date
    	else 
    	case when spending.trans_date is not null then spending.trans_date
    	else investment.trans_date
    	end
    	end as trans_date
        ,income.amount as income_amount
        ,spending.amount as spending_amount
        ,investment.amount as investment_amount
    from income
    full outer join spending
    on income.trans_date = spending.trans_date
    full outer join investment
    on income.trans_date = investment.trans_date
)
select ROW_NUMBER() OVER (ORDER by trans_date) as id
,cte.*
from cte
    