with source as (

    select * from {{ source('olist_raw', 'olist_order_reviews') }}

),

stg_order_reviews as (

    select
        review_id,
        order_id,
        cast(review_score as number) as rating_score, -- Standardizes naming for "Rating" (1-5)
        review_comment_title as comment_title,
        review_comment_message as comment_body,
        
        -- Timing
        to_date(review_creation_date) as sent_at, -- When the survey was sent to the user
        cast(review_answer_timestamp as timestamp) as answered_at -- When the user actually replied

    from source

)

select * from stg_order_reviews