{{ config(
    materialized='table'
) }}

with base as (

    select *
    from {{ ref('int_uber_trip') }}

),

payment_summary as (

    select
        payment_method,
        count(*) as total_trips,
        sum(total_amount) as total_revenue,
        avg(tip_amount) as avg_tip_amount,
        max(tip_amount) as max_tip_amount,
        sum(case when tip_status = 'High Tip' then 1 else 0 end) as high_tip_trips
    from base
    group by payment_method

)

select * from payment_summary
