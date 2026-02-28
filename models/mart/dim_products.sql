with products_enriched as (
    select * from {{ ref('int_products_enriched') }}
),

dim_products as (

    select
        product_id,
        category_name,
        weight_grams,
        volume_cm3,
        
        -- Business Logic: Logistics Categorization
        case 
            when weight_grams > 5000 or volume_cm3 > 30000 then 'heavy/bulky'
            when weight_grams between 1000 and 5000 then 'medium'
            else 'light'
        end as shipping_category,
        
        -- Quality Score (Example: based on photos and description)
        case 
            when photo_count > 3 then 'high_quality_listing'
            else 'basic_listing'
        end as listing_quality

    from products_enriched
)

select * from dim_products