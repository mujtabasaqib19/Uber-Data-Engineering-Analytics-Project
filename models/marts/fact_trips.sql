{{ config(materialized='table') }}

WITH source_data AS (
    SELECT *
    FROM {{ source('uber', 'UBER_DATASET') }}
    WHERE tpep_pickup_datetime IS NOT NULL
),

fact_base AS (
    SELECT
        -- Generate surrogate trip_id
        ROW_NUMBER() OVER (ORDER BY tpep_pickup_datetime, pickup_latitude, pickup_longitude) AS trip_id,

        TO_TIMESTAMP(tpep_pickup_datetime)       AS tpep_pickup_datetime,
        TO_TIMESTAMP(tpep_dropoff_datetime)      AS tpep_dropoff_datetime,

        passenger_count,
        trip_distance,
        RatecodeID,
        pickup_latitude,
        pickup_longitude,
        dropoff_latitude,
        dropoff_longitude,
        payment_type,

        fare_amount,
        extra,
        mta_tax,
        tip_amount,
        tolls_amount,
        improvement_surcharge,
        total_amount
    FROM source_data
),

joined_fact AS (
    SELECT
        fb.trip_id,
        dd.tpep_pickup_datetime,
        dd.tpep_dropoff_datetime,

        pc.passenger_count_id,
        td.trip_distance_id,
        rc.rate_code_id,
        pl.pickup_location_id,
        dl.dropoff_location_id,
        pt.payment_type_id,

        fb.fare_amount,
        fb.extra,
        fb.mta_tax,
        fb.tip_amount,
        fb.tolls_amount,
        fb.improvement_surcharge,
        fb.total_amount
    FROM fact_base fb

    LEFT JOIN {{ ref('dim_datetime') }} dd
        ON fb.tpep_pickup_datetime = dd.tpep_pickup_datetime
       AND fb.tpep_dropoff_datetime = dd.tpep_dropoff_datetime

    LEFT JOIN {{ ref('dim_passenger_count') }} pc
        ON fb.passenger_count = pc.passenger_count

    LEFT JOIN {{ ref('dim_trip_distance') }} td
        ON fb.trip_distance = td.trip_distance

    LEFT JOIN {{ ref('dim_rate_code') }} rc
        ON fb.RatecodeID = rc.RatecodeID

    LEFT JOIN {{ ref('dim_pickup_location') }} pl
        ON fb.pickup_latitude = pl.pickup_latitude
       AND fb.pickup_longitude = pl.pickup_longitude

    LEFT JOIN {{ ref('dim_dropoff_location') }} dl
        ON fb.dropoff_latitude = dl.dropoff_latitude
       AND fb.dropoff_longitude = dl.dropoff_longitude

    LEFT JOIN {{ ref('dim_payment_type') }} pt
        ON fb.payment_type = pt.payment_type
)

SELECT * FROM joined_fact
