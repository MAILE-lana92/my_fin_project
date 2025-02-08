{%set column_name = 'trans.trans_desc' %}
  WITH uncated_credit_trans AS (
      SELECT 
        trans.id
      , trans.trans_date
      , trans.code
      , trans.trans_desc
      , trans.credit
      ,{{ credit_categorize(column_name) }} AS credit_transaction_type
      FROM {{ ref('int_credit_transactions_uncated') }} trans
  )
  SELECT * FROM uncated_credit_trans