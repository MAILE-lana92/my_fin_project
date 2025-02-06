{%set column_name = 'trans."Desc"' %}
  WITH uncated_credit_trans AS (
      SELECT 
        trans."id"
      , trans."Date"
      , trans."Code"
      , trans."Desc"
      , trans."Credit"
      , trans."Balance"
      ,{{ credit_categorize(column_name) }} AS credit_transaction_type
      FROM {{ ref('int_credit_transactions_uncated') }} trans
  )
  SELECT * FROM uncated_credit_trans