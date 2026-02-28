with source as (

    select * from {{ source('olist_raw', 'product_category_name_translation') }}

),

stg_product_category_translations as (

    select
        product_category_name as category_name_pt,
        product_category_name_english as category_name_en

    from source

)

select * from stg_product_category_translations