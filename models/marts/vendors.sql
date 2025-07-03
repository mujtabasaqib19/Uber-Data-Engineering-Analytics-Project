{{ config(
    materialized='table'
) }}

with base as (

    select *
    from {{ ref('int_uber_trip') }}

),

vendor_summary as (

    select
        vendor_name,
        count(*) as total_trips,
        sum(total_amount) as total_revenue,
        avg(total_amount) as avg_trip_amount,
        avg(tip_amount) as avg_tip_amount,
        max(total_amount) as max_trip_amount,
        min(total_amount) as min_trip_amount,
        sum(case when peak_hour_flag = 'Peak Hours' then 1 else 0 end) as peak_hour_trips,
        sum(case when tip_status = 'High Tip' then 1 else 0 end) as high_tip_trips
    from base
    group by vendor_name

)

select * from vendor_summary
