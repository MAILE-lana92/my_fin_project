{%set column_name = 'trans."Desc"' %}
  WITH uncated_debit_trans AS (
      SELECT 
        trans."id"
      , trans."Date"
      , trans."Code"
      , trans."Desc"
      , trans."Debit"
      , trans."Balance"
      ,{{ debit_categorize(column_name) }} AS debit_transaction_type
      FROM {{ ref('int_debit_transactions_uncated') }} trans
  )
  SELECT * FROM uncated_debit_trans