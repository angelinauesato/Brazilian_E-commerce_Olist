with customers as (
    select * from {{ ref('stg_customers') }}
),

geolocation as (
    -- Take the average lat/lng for each zip code to avoid duplicates
    select
        zip_code_prefix,
        avg(latitude) as lat,
        avg(longitude) as lng,
        max(city) as city,
        max(state_code) as state

    from {{ ref('stg_geolocation') }}

    group by 1
),

dim_customers as (
    select
        customer.user_id,
        customer.zip_code_prefix,
        geo.city,
        geo.state,
        geo.lat,
        geo.lng

        /*
        TODO customer:
        lifetime_value - total_amount spent
        number_of_orders
        Days_Since_Last_Purchase
        first_order_date
        most_recent_order_date
        */

    from customers as customer

    left join geolocation as geo
        on customer.zip_code_prefix = geo.zip_code_prefix
)

select * from dim_customers