with source as (

    select * from {{ source('olist_raw', 'olist_products') }}

),

stg_products as (

    select
        product_id,
        product_category_name as category_name,
        
        -- Fixing typos and clarifying metadata
        product_name_lenght as name_character_count,
        product_description_lenght as description_character_count,
        product_photos_qty as photo_count,
        
        -- Physical dimensions (Crucial for logistics)
        product_weight_g as weight_grams,
        product_length_cm as length_cm,
        product_height_cm as height_cm,
        product_width_cm as width_cm

    from source

)

select * from stg_products