with source as (

    select * from {{ source('olist_raw', 'olist_customers') }}

),

renamed as (

    select
        customer_unique_id as user_id,
        customer_zip_code_prefix as zip_code_prefix,
        {{ clean_city_names('customer_city') }} as city,
        customer_state as state_code
    from source

),

stg_users as (

    select
        *
    from renamed
    -- This ensures exactly one row per user_id for the snapshot
    qualify row_number() over (
        partition by user_id 
        order by zip_code_prefix desc -- A consistent tie-breaker
    ) = 1

)

select * from stg_users