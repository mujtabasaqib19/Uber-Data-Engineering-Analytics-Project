{{ config(materialized='view') }}

SELECT 
    CASE 
        WHEN drc.ratecodeid = 1 THEN 'Standard Rate'
        WHEN drc.ratecodeid = 2 THEN 'JFK'
        WHEN drc.ratecodeid = 3 THEN 'Newark'
        WHEN drc.ratecodeid = 4 THEN 'Nassau or Westchester'
        WHEN drc.ratecodeid = 5 THEN 'Negotiated Fare'
        WHEN drc.ratecodeid = 6 THEN 'Group Ride'
        ELSE 'Other'
    END AS rate_code_label,
    COUNT(ft.trip_id) AS total_trips
FROM {{ ref('fact_trips') }} ft
JOIN {{ ref('dim_rate_code') }} drc 
    ON ft.rate_code_id = drc.rate_code_id
GROUP BY rate_code_label
ORDER BY total_trips DESC
