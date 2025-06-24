{{ config(materialized='table') }}

SELECT
  ROW_NUMBER() OVER (ORDER BY pickup_latitude, pickup_longitude) - 1 AS pickup_location_id,
  pickup_latitude,
  pickup_longitude
FROM (
  SELECT DISTINCT pickup_latitude, pickup_longitude
  FROM {{ source('uber', 'UBER_DATASET') }}
  WHERE pickup_latitude IS NOT NULL AND pickup_longitude IS NOT NULL
)
