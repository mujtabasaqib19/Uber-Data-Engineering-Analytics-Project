{{ config(materialized='view') }}

SELECT 
    TO_VARCHAR(ROUND(SUM(dtd.trip_distance), 2), '999,999,999.99') AS total_km
FROM {{ ref('fact_trips') }} ft
JOIN {{ ref('dim_trip_distance') }} dtd 
    ON ft.trip_distance_id = dtd.trip_distance_id
WHERE dtd.trip_distance IS NOT NULL
