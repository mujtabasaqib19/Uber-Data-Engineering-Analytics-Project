{{ config(materialized='table') }}

SELECT
  ROW_NUMBER() OVER (ORDER BY RatecodeID) - 1 AS rate_code_id,
  RatecodeID,
  CASE RatecodeID
    WHEN 1 THEN 'Standard rate'
    WHEN 2 THEN 'JFK'
    WHEN 3 THEN 'Newark'
    WHEN 4 THEN 'Nassau or Westchester'
    WHEN 5 THEN 'Negotiated fare'
    WHEN 6 THEN 'Group ride'
    ELSE 'Unknown'
  END AS rate_code_name
FROM (
  SELECT DISTINCT RatecodeID
  FROM {{ source('uber', 'UBER_DATASET') }}
  WHERE RatecodeID IS NOT NULL
)
