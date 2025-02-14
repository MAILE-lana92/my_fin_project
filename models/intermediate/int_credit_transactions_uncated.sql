{{
    config(
        materialized='incremental',
        unique_key= ['code', 'trans_date', 'credit'],
        on_schema_change ='fail'
    )
}}

with 
all_trans as (
    select *
    from {{ ref('stg_transaction') }}
),
credit_trans as (
    select  ROW_NUMBER() OVER (ORDER BY trans.trans_date, trans.id) AS  id
    ,trans.trans_date
    ,trans.code
    ,trans.trans_desc
    ,trans.credit
from all_trans trans 
    where trans.credit > 0
)
select * from credit_trans