with source as (

    select * from {{ source('olist_raw', 'olist_geolocation') }}

),

stg_geolocation as (

    select
        geolocation_zip_code_prefix as zip_code_prefix,
        geolocation_lat as latitude,
        geolocation_lng as longitude,
        geolocation_city as city,
        geolocation_state as state_code

    from source

)

select * from stg_geolocation