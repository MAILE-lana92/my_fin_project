{%set column_name = 'trans.trans_desc' %}
  WITH uncated_debit_trans AS (
      SELECT 
        trans.id
      , trans.trans_date
      , trans.code
      , trans.trans_desc
      , trans.debit
      ,{{ debit_categorize(column_name) }} AS debit_transaction_type
      FROM {{ ref('int_debit_transactions_uncated') }} trans
  )
  SELECT * FROM uncated_debit_trans