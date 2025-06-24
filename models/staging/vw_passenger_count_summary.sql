{{ config(materialized='view') }}

SELECT 
    dpc.passenger_count,
    COUNT(ft.trip_id) AS total_trips,
    ROUND(AVG(ft.total_amount), 2) AS avg_fare,
    CASE 
        WHEN dpc.passenger_count = 1 THEN 'Solo'
        WHEN dpc.passenger_count BETWEEN 2 AND 3 THEN 'Small Group'
        WHEN dpc.passenger_count > 3 THEN 'Large Group'
        ELSE 'Unknown'
    END AS group_type
FROM {{ ref('fact_trips') }} ft
JOIN {{ ref('dim_passenger_count') }} dpc 
    ON ft.passenger_count_id = dpc.passenger_count_id
GROUP BY dpc.passenger_count
