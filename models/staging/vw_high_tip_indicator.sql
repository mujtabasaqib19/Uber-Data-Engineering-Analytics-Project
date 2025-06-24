{{ config(materialized='view') }}

SELECT 
    CASE 
        WHEN ft.tip_amount >= 5 THEN 'High Tip'
        WHEN ft.tip_amount BETWEEN 1 AND 4.99 THEN 'Medium Tip'
        WHEN ft.tip_amount < 1 THEN 'Low/No Tip'
        ELSE 'Unknown'
    END AS tip_bracket,
    COUNT(ft.trip_id) AS total_trips
FROM {{ ref('fact_trips') }} ft
GROUP BY 
    CASE 
        WHEN ft.tip_amount >= 5 THEN 'High Tip'
        WHEN ft.tip_amount BETWEEN 1 AND 4.99 THEN 'Medium Tip'
        WHEN ft.tip_amount < 1 THEN 'Low/No Tip'
        ELSE 'Unknown'
    END
ORDER BY total_trips DESC
