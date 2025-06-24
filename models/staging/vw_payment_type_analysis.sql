{{ config(materialized='view') }}

SELECT 
    dpt.payment_type_name,
    COUNT(ft.trip_id) AS total_trips,
    ROUND(SUM(ft.total_amount), 2) AS total_earnings,
    ROUND(AVG(ft.tip_amount), 2) AS avg_tip_amount,
    CASE 
        WHEN dpt.payment_type_name = 'Credit card' THEN 'Cashless'
        WHEN dpt.payment_type_name = 'Cash' THEN 'Cash'
        ELSE 'Other'
    END AS payment_category
FROM {{ ref('fact_trips') }} ft
JOIN {{ ref('dim_payment_type') }} dpt 
    ON ft.payment_type_id = dpt.payment_type_id
GROUP BY dpt.payment_type_name
