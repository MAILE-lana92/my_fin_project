-- base transitions that were manually converted from the pass 3 years.
with source as (
    select *
    from {{ ref('base_transaction') }}
    )
select * from source