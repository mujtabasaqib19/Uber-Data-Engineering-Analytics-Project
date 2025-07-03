with base as (

    select
        trip_id,
        vendor_id,
        pickup_datetime as tpep_pickup_datetime,
        dropoff_datetime as tpep_dropoff_datetime,
        passenger_count,
        trip_distance,
        rate_code_id,
        store_and_fwd_flag,
        pickup_longitude,
        pickup_latitude,
        dropoff_longitude,
        dropoff_latitude,
        payment_type,
        fare_amount,
        extra,
        mta_tax,
        tip_amount,
        tolls_amount,
        improvement_surcharge,
        total_amount,

        -- 🌟 Derived Columns 🌟

        -- Classify trip distance
        case
            when trip_distance = 0 then 'Zero Distance'
            when trip_distance <= 2 then 'Very Short'
            when trip_distance <= 5 then 'Short'
            when trip_distance <= 15 then 'Medium'
            else 'Long'
        end as trip_length_category,


        -- Classify payment type
        case payment_type
            when 1 then 'Credit Card'
            when 2 then 'Cash'
            when 3 then 'No Charge'
            when 4 then 'Dispute'
            else 'Other'
        end as payment_method,

        -- Classify vendor
        case vendor_id
            when 1 then 'Creative Mobile Technologies'
            when 2 then 'VeriFone Inc.'
            else 'Unknown Vendor'
        end as vendor_name,

        -- Flag trips with tips
        case
            when tip_amount = 0 then 'No Tip'
            when tip_amount between 0.01 and 5 then 'Low Tip'
            when tip_amount > 5 then 'High Tip'
        end as tip_status,

        -- Classify trip duration
        case
            when datediff(minute, tpep_pickup_datetime, tpep_dropoff_datetime) <= 5 then 'Quick Trip'
            when datediff(minute, tpep_pickup_datetime, tpep_dropoff_datetime) <= 15 then 'Normal Trip'
            when datediff(minute, tpep_pickup_datetime, tpep_dropoff_datetime) <= 60 then 'Extended Trip'
            else 'Very Long Trip'
        end as trip_duration_category,

        -- Passenger count classification
        case
            when passenger_count = 1 then 'Solo'
            when passenger_count = 2 then 'Couple'
            when passenger_count between 3 and 5 then 'Small Group'
            when passenger_count > 5 then 'Large Group'
            else 'Unknown Group'
        end as passenger_category,

        -- Time of day classification
        case
            when extract(hour from tpep_pickup_datetime) between 5 and 11 then 'Morning'
            when extract(hour from tpep_pickup_datetime) between 12 and 16 then 'Afternoon'
            when extract(hour from tpep_pickup_datetime) between 17 and 21 then 'Evening'
            else 'Night'
        end as time_of_day,

        -- Peak hour flag
        case
            when extract(hour from tpep_pickup_datetime) in (7,8,9,17,18,19) then 'Peak Hours'
            else 'Off-Peak Hours'
        end as peak_hour_flag,

        -- Fare category
        case
            when total_amount < 10 then 'Low Fare'
            when total_amount between 10 and 50 then 'Medium Fare'
            else 'High Fare'
        end as fare_category,

        -- Trip Duration (minutes)
        datediff(minute, tpep_pickup_datetime, tpep_dropoff_datetime) as trip_duration_min,

        -- Trip Day and Hour
        date_trunc('day', tpep_pickup_datetime) as trip_date,
        extract(hour from tpep_pickup_datetime) as trip_hour,

        -- Unique row for deduplication
        row_number() over (
            partition by trip_id
            order by tpep_pickup_datetime desc
        ) as row_num

    from {{ ref('stg_uber_trips') }}
),

deduplicated as (
    select *
    from base
    where row_num = 1
),

aggregates as (
    select
        vendor_name,
        trip_date,
        count(*) as total_trips,
        sum(trip_distance) as total_distance,
        sum(total_amount) as total_revenue,
        avg(trip_distance) as avg_trip_distance,
        avg(trip_duration_min) as avg_trip_duration,
        max(total_amount) as max_trip_amount,

        -- Window function: cumulative revenue per vendor
        sum(sum(total_amount)) over (
            partition by vendor_name
            order by trip_date
            rows between unbounded preceding and current row
        ) as cumulative_revenue,

        -- Percentile rank of trip amount
        percent_rank() over (
            partition by vendor_name
            order by sum(total_amount) desc
        ) as trip_revenue_rank

    from deduplicated
    group by vendor_name, trip_date
)

select
    d.*,
    a.total_trips,
    a.total_distance,
    a.total_revenue,
    a.avg_trip_distance,
    a.avg_trip_duration,
    a.max_trip_amount,
    a.cumulative_revenue,
    a.trip_revenue_rank
from deduplicated d
left join aggregates a
on d.vendor_name = a.vendor_name
and d.trip_date = a.trip_date
