{{ config(materialized='view') }}

SELECT 
    dd.pick_hour,
    COUNT(ft.trip_id) AS total_trips,
    ROUND(AVG(ft.fare_amount), 2) AS avg_total_amount,
    ROUND(SUM(ft.tip_amount), 2) AS total_tips,
    CASE 
        WHEN dd.pick_hour BETWEEN 0 AND 5 THEN 'Late Night'
        WHEN dd.pick_hour BETWEEN 6 AND 11 THEN 'Morning'
        WHEN dd.pick_hour BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS time_of_day
FROM {{ ref('fact_trips') }} ft
JOIN {{ ref('dim_datetime') }} dd 
    ON ft.tpep_pickup_datetime = dd.tpep_pickup_datetime
GROUP BY dd.pick_hour
