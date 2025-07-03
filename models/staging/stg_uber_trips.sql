with source as (

    select * 
    from {{ source('uber_data', 'UBERDATASET') }}

),

renamed as (

    select
        row_number() over (order by tpep_pickup_datetime) as trip_id,  -- ✅ Synthetic trip_id
        cast(VendorID as int) as vendor_id,
        cast(tpep_pickup_datetime as timestamp) as pickup_datetime,
        cast(tpep_dropoff_datetime as timestamp) as dropoff_datetime,
        cast(passenger_count as int) as passenger_count,
        cast(trip_distance as float) as trip_distance,
        cast(pickup_longitude as float) as pickup_longitude,
        cast(pickup_latitude as float) as pickup_latitude,
        cast(dropoff_longitude as float) as dropoff_longitude,
        cast(dropoff_latitude as float) as dropoff_latitude,
        cast(RatecodeID as int) as rate_code_id,
        store_and_fwd_flag,
        cast(payment_type as int) as payment_type,
        cast(fare_amount as float) as fare_amount,
        cast(extra as float) as extra,
        cast(mta_tax as float) as mta_tax,
        cast(tip_amount as float) as tip_amount,
        cast(tolls_amount as float) as tolls_amount,
        cast(improvement_surcharge as float) as improvement_surcharge,
        cast(total_amount as float) as total_amount
    from source

)

select * from renamed
