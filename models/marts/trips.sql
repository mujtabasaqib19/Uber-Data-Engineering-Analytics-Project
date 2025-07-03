{{ config(
    materialized='table'
) }}

with base as (

    select *
    from {{ ref('int_uber_trip') }}

),

trips as (

    select
        -- All base columns
        trip_id,
        vendor_id,
        vendor_name,
        tpep_pickup_datetime,              -- ✅ fixed column name
        tpep_dropoff_datetime,             -- ✅ fixed column name
        passenger_count,
        trip_distance,
        rate_code_id,
        store_and_fwd_flag,
        pickup_longitude,
        pickup_latitude,
        dropoff_longitude,
        dropoff_latitude,
        payment_type,
        payment_method,
        fare_amount,
        extra,
        mta_tax,
        tip_amount,
        tolls_amount,
        improvement_surcharge,
        total_amount,
        trip_length_category,
        trip_duration_category,
        passenger_category,
        time_of_day,
        peak_hour_flag,
        fare_category,
        tip_status,
        trip_duration_min,
        trip_date,
        trip_hour,

        -- Windowed aggregates
        sum(total_amount) over (
            partition by vendor_name
            order by trip_date
            rows between unbounded preceding and current row
        ) as vendor_cumulative_revenue,

        sum(total_amount) over (
            partition by payment_method
            order by trip_date
            rows between unbounded preceding and current row
        ) as payment_method_cumulative_revenue,

        count(*) over (
            partition by vendor_name
            order by trip_date
            rows between unbounded preceding and current row
        ) as vendor_cumulative_trip_count,

        percent_rank() over (
            partition by vendor_name
            order by total_amount desc
        ) as vendor_trip_revenue_rank

    from base

)

select * from trips