with source as (

    select * from {{ source('olist_raw', 'olist_order_reviews') }}

),

stg_order_reviews as (

    select
        review_id,
        order_id,
        review_score as rating_score, -- Standardizes naming for "Rating" (1-5)
        review_comment_title as comment_title,
        review_comment_message as comment_body,
        
        -- Timing
        review_creation_date as sent_at, -- When the survey was sent to the user
        review_answer_timestamp as answered_at -- When the user actually replied

    from source

)

select * from stg_order_reviews