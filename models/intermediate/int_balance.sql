{{
    config(
        materialized='incremental',
        unique_key= ['code', 'trans_date'],
        on_schema_change='fail'
    )
}}

with 
all_trans as (
    select id
    ,trans_date
    ,code
    ,trans_desc
    ,balance
    from {{ ref('stg_transaction') }} trans
)
select * from all_trans