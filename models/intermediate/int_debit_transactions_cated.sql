{%set column_name = 'trans."Desc"' %}
  WITH uncated_debit_trans AS (
      SELECT 
        trans."id"
      , trans."Date"
      , trans."Code"
      , trans."Desc"
      , trans."Debit"
      ,{{ debit_categorize(column_name) }} AS Debit_Transaction_Type
      FROM {{ ref('int_debit_transactions_uncated') }} trans
  )
  SELECT * FROM uncated_debit_trans