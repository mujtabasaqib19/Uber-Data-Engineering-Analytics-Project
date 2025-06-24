{{ config(materialized='view') }}

SELECT 
    TO_VARCHAR(ROUND(SUM(ft.total_amount), 2), '999,999,999.99') AS total_revenue_usd
FROM {{ ref('fact_trips') }} ft
WHERE ft.total_amount IS NOT NULL
