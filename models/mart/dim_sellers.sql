with sellers as (
    select * from {{ ref('stg_sellers') }}
),

geolocation as (
    select
        geolocation_zip_code_prefix as zip_code_prefix,
        avg(geolocation_lat) as lat,
        avg(geolocation_lng) as lng
    from {{ source('olist_raw', 'olist_geolocation') }}
    group by 1
),

dim_sellers as (
    select
        seller.seller_id,
        seller.seller_zip_code,
        seller.seller_city,
        seller.seller_state,
        geo.lat as seller_lat,
        geo.lng as seller_lng

    from sellers as seller

    left join geolocation as geo
        on seller.seller_zip_code = geo.zip_code_prefix
)

select * from dim_sellers