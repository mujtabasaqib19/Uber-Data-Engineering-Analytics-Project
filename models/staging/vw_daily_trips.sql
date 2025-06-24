SELECT 
    dd.tpep_pickup_datetime::DATE AS trip_date,
    COUNT(ft.trip_id) AS total_trips
FROM uber_data.uber_uber.fact_trips ft
JOIN uber_data.uber_uber.dim_datetime dd 
    ON ft.tpep_pickup_datetime = dd.tpep_pickup_datetime
GROUP BY trip_date
ORDER BY trip_date