with source as (

    select * from {{ source('olist_raw', 'olist_order_items') }}

),

stg_order_items as (

    select
        {{ dbt_utils.generate_surrogate_key(['order_id', 'order_item_id']) }} as order_item_key,
        order_id,
        cast(order_item_id as number) as line_item_number, -- Clarifies this is the 1st, 2nd, or 3rd item in the cart
        product_id,
        seller_id,
    
        -- Logistics & SLAs
        cast(shipping_limit_date as timestamp) as seller_ship_before_at,
    
        -- Financials
        cast(price as number(10,2)) as item_price_amount,
        cast(freight_value as number(10,2)) as shipping_fee_amount,
        cast((price + freight_value)as number(10,2)) as total_item_cost_amount

    from source

)

select * from stg_order_items