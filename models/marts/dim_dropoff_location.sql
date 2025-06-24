{{ config(materialized='table') }}

SELECT
  ROW_NUMBER() OVER (ORDER BY dropoff_latitude, dropoff_longitude) - 1 AS dropoff_location_id,
  dropoff_latitude,
  dropoff_longitude
FROM (
  SELECT DISTINCT dropoff_latitude, dropoff_longitude
  FROM {{ source('uber', 'UBER_DATASET') }}
  WHERE dropoff_latitude IS NOT NULL AND dropoff_longitude IS NOT NULL
)
