{%set column_name = 'trans.trans_desc' %}
  WITH credit_trans_1 AS (
      SELECT 
        trans.id
      , trans.trans_date
      , trans.code
      , trans.trans_desc
      , trans.credit
      ,{{ credit_categorize(column_name) }} AS credit_transaction_type
      FROM {{ ref('int_credit_transactions_uncated') }} trans
  ),
  credit_trans_2 as (
  SELECT 
    trans.id
    , trans.trans_date
    , trans.code
    , trans.trans_desc
    , trans.credit
    , case when trans.credit_transaction_type = 'Other' then
          -- case when trans.trans_desc like 'LE XUAN MAI%' or trans.trans_desc like ('MAI LE%') then 
               case when (cast(trans.trans_date as date) <= date'2023-04-01') and trans.credit >= 1000000 then 'Wedding_spending'
               		when (cast(trans.trans_date as date)>= date'2024-01-01' and cast(trans.trans_date as date) <= date'2024-11-01') and trans.credit >= 2000000 then 'House_improvement' else 'Other' end
          -- else trans.credit_transaction_type  end
          else trans.credit_transaction_type end as credit_transaction_type 
  FROM credit_trans_1 trans
  )
  select * from credit_trans_2