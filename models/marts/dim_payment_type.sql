{{ config(materialized='table') }}

SELECT
  ROW_NUMBER() OVER (ORDER BY payment_type) - 1 AS payment_type_id,
  payment_type,
  CASE payment_type
    WHEN 1 THEN 'Credit card'
    WHEN 2 THEN 'Cash'
    WHEN 3 THEN 'No charge'
    WHEN 4 THEN 'Dispute'
    WHEN 5 THEN 'Unknown'
    WHEN 6 THEN 'Voided trip'
    ELSE 'Other'
  END AS payment_type_name
FROM (
  SELECT DISTINCT payment_type
  FROM {{ source('uber', 'UBER_DATASET') }}
  WHERE payment_type IS NOT NULL
)
