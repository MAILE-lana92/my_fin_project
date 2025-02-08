with cte as (
    select 
    trans_date
    ,balance
    ,ROW_NUMBER() OVER (partition by trans_date ORDER by id) as row_num
    from {{ref('int_balance')}}
),
last_balance as (
    select *
    from cte
    where row_num = 1
)
select row_number() OVER (ORDER BY trans_date) as id
,trans_date
,balance
from last_balance