with orders_enriched as (

    select * from {{ ref('int_orders_enriched') }}

),

dim_dates as (

    select * from {{ ref('dim_dates') }}

),

fct_orders as (

    select
        -- Foreign Keys
        ord.order_id,
        ord.user_id,
        dim_dates.sk_date as order_date_key, -- Surrogate key from dim_dates
        ord.customer_zip_code,

        -- Status & Logistics Attributes
        ord.order_status,
        ord.actual_delivery_time_days,
        ord.delivery_sla_delta_days,
        ord.is_late_delivery,

        -- Financial Measures
        ord.total_payment_amount as gmv, -- Gross Merchandise Value
        ord.payment_method_count,
        ord.max_installments,
        ord.has_voucher_payment,

        -- Sentiment Measures
        ord.avg_rating_score as satisfaction_score,
        ord.total_reviews,

        -- Derived Business Logic (The "Perfect Order")
        case 
            when ord.order_status = 'delivered' 
             and ord.is_late_delivery = 0 
             and ord.avg_rating_score = 5 
            then 1 
            else 0 
        end as is_perfect_order

    from orders_enriched as ord
    left join dim_dates
        on cast(ord.purchased_at as date) = dim_dates.date_actual

)

select * from fct_orders