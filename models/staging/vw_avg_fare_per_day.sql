SELECT 
    ft.tpep_pickup_datetime::DATE AS trip_date,
    ROUND(AVG(ft.total_amount), 2) AS avg_fare,
    ROUND(AVG(ft.tip_amount), 2) AS avg_tip,
    COUNT(ft.trip_id) AS total_trips
FROM {{ ref('fact_trips') }} ft
GROUP BY trip_date
ORDER BY trip_date
