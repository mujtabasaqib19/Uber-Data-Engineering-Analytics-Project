{{ config(materialized='table') }}

SELECT
  ROW_NUMBER() OVER (ORDER BY passenger_count) - 1 AS passenger_count_id,
  passenger_count
FROM (
  SELECT DISTINCT passenger_count
  FROM {{ source('uber', 'UBER_DATASET') }}
  WHERE passenger_count IS NOT NULL
)
