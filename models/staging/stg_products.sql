with source as (

    select * from {{ source('olist_raw', 'olist_products') }}

),

stg_products as (
    select
        product_id,
        product_category_name as category_name,

        -- Fixing typos and clarifying metadata
        cast(product_name_lenght as number) as name_character_count,
        cast(product_description_lenght as number) as description_character_count,
        cast(product_photos_qty as number) as photo_count,

        -- Physical dimensions (Crucial for logistics)
        cast(product_weight_g as number) as weight_grams,
        cast(product_length_cm as number) as length_cm,
        cast(product_height_cm as number) as height_cm,
        cast(product_width_cm as number) as width_cm

    from source
)

select * from stg_products