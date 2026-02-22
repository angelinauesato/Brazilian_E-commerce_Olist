with source as (

    select * from {{ source('olist_raw', 'olist_sellers') }}

),

stg_sellers as (

    select
        seller_id,
        seller_zip_code_prefix as zip_code_prefix,
        seller_city as city,
        seller_state as state_code

    from source

)

select * from stg_sellers