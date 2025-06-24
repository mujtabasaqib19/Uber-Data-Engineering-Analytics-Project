{{ config(materialized='table') }}

SELECT DISTINCT
  TO_TIMESTAMP(tpep_pickup_datetime)       AS tpep_pickup_datetime,
  TO_TIMESTAMP(tpep_dropoff_datetime)      AS tpep_dropoff_datetime,
  DATE_PART('HOUR', tpep_pickup_datetime)  AS pick_hour,
  DATE_PART('DAY', tpep_pickup_datetime)   AS pick_day,
  DATE_PART('MONTH', tpep_pickup_datetime) AS pick_month,
  DATE_PART('YEAR', tpep_pickup_datetime)  AS pick_year,
  DATE_PART('DOW', tpep_pickup_datetime)   AS pick_weekday
FROM {{ source('uber', 'UBER_DATASET') }}
