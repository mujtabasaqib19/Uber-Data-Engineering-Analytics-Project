{{ config(materialized='view') }}
-- models/staging/vw_trip_distance_bucketed.sql

SELECT 
    dtd.trip_distance,
    COUNT(ft.trip_id) AS total_trips,
    ROUND(AVG(ft.total_amount), 2) AS avg_amount,
    CASE 
        WHEN dtd.trip_distance < 2 THEN 'Short'
        WHEN dtd.trip_distance BETWEEN 2 AND 5 THEN 'Medium'
        ELSE 'Long'
    END AS distance_category
FROM {{ ref('fact_trips') }} ft
JOIN {{ ref('dim_trip_distance') }} dtd 
    ON ft.trip_distance_id = dtd.trip_distance_id
GROUP BY dtd.trip_distance

