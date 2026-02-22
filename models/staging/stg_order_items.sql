with source as (

    select * from {{ source('olist_raw', 'olist_order_items') }}

),

stg_order_items as (

    select
        {{ dbt_utils.generate_surrogate_key(['order_id', 'order_item_id']) }} as order_item_key,
        order_id,
        order_item_id as line_item_number, -- Clarifies this is the 1st, 2nd, or 3rd item in the cart
        product_id,
        seller_id,
    
        -- Logistics & SLAs
        shipping_limit_date as seller_ship_before_at,
    
        -- Financials
        price as item_price_amount,
        freight_value as shipping_fee_amount,
        (price + freight_value) as total_item_cost_amount

    from source

)

select * from stg_order_items