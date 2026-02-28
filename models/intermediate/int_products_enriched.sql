with products as (
    select
        product_id,
        case 
            when category_name = 'pc_gamer' then 'pcs'
            when category_name = 'portateis_cozinha_e_preparadores_de_alimentos' then 'utilidades_domesticas'
            else category_name
        end as category_name,

        name_character_count,
        description_character_count,
        photo_count,

        weight_grams,
        length_cm,
        height_cm,
        width_cm

    from {{ ref('stg_products') }}
),

translations as (
    select * from {{ ref('stg_product_category_translations') }}
),

int_products_enriched as (
    select
        prod.product_id,
        trans.category_name_en as category_name,
        
        -- Physical Metrics
        prod.weight_grams,
        prod.length_cm,
        prod.height_cm,
        prod.width_cm,
        (prod.length_cm * prod.height_cm * prod.width_cm) as volume_cm3,
        
        -- Metadata
        prod.photo_count,
        prod.name_character_count

    from products as prod
    left join translations as trans 
        on prod.category_name = trans.category_name_pt
)

select * from int_products_enriched