{{ config(materialized='table') }}

SELECT
  ROW_NUMBER() OVER (ORDER BY trip_distance) - 1 AS trip_distance_id,
  trip_distance
FROM (
  SELECT DISTINCT trip_distance
  FROM {{ source('uber', 'UBER_DATASET') }}
  WHERE trip_distance IS NOT NULL
)
