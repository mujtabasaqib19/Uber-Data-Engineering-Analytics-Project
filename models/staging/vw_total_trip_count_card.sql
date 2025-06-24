{{ config(materialized='view') }}

SELECT 
    TO_VARCHAR(COUNT(ft.trip_id), '999,999,999') AS total_trips
FROM {{ ref('fact_trips') }} ft
WHERE ft.trip_id IS NOT NULL
