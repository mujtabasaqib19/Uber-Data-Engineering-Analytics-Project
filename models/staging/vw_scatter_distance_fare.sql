{{ config(materialized='view') }}

SELECT 
    dtd.trip_distance,
    ft.total_amount
FROM {{ ref('fact_trips') }} ft
JOIN {{ ref('dim_trip_distance') }} dtd 
    ON ft.trip_distance_id = dtd.trip_distance_id
WHERE dtd.trip_distance IS NOT NULL
  AND ft.total_amount IS NOT NULL
