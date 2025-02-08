
{{
    config(
        materialized='incremental',
        unique_key= ['code', 'trans_date', 'debit'],
        on_schema_change='fail'
    )
}}

with 
all_trans as (
    select * from {{ ref('stg_transaction') }}
),
debit_trans as (
    select  ROW_NUMBER() OVER (ORDER BY trans.trans_date, trans.id) AS  id
    ,trans.trans_date
    ,trans.code
    ,trans.trans_desc
    ,trans.debit
from all_trans trans
    where trans.debit > 0
)
select * from debit_trans