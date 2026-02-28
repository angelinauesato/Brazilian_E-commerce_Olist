with sellers as (
    select * from {{ ref('stg_sellers') }}
),

geolocation as (
    select
        zip_code_prefix,
        avg(latitude) as avg_latitude,
        avg(longitude) as avg_longitude

    from {{ ref('stg_geolocation') }}

    group by 1
),

dim_sellers as (
    select
        seller.seller_id,
        seller.zip_code_prefix,
        seller.city,
        seller.state_code,
        geo.avg_latitude as seller_lat,
        geo.avg_longitude as seller_lng

    from sellers as seller

    left join geolocation as geo
        on seller.zip_code_prefix = geo.zip_code_prefix
)

select * from dim_sellers