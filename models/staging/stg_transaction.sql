with base_transaction as (
    select *
    from {{ ref('stg_base_transaction') }}
    )
select * from base_transaction