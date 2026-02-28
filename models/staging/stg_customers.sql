with source as (

    select 
        {{ trim_quotes_all(source('olist_raw', 'olist_customers')) }}

    from {{ source('olist_raw', 'olist_customers') }}

),

stg_customers as (

    select
        -- In Olist, customer_id is basically a "per-order" ID
        customer_id as order_customer_key,

        -- This is the actual unique identifier for the person
        customer_unique_id as user_id,
        
        -- Geography
        customer_zip_code_prefix as zip_code_prefix,
        {{ clean_city_names('customer_city') }} as city,
        customer_state as state_code

    from source

)

select * from stg_customers