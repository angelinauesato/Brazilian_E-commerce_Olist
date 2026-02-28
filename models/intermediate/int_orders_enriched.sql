with orders as (
    select * from {{ ref('stg_orders') }}
),

payments as (
    select * from {{ ref('int_order_payments_aggregated') }}
),

reviews as (
    -- We aggregate reviews in case one order has multiple review entries
    select 
        order_id,
        avg(rating_score) as avg_rating_score,
        count(review_id) as total_reviews
    from {{ ref('stg_order_reviews') }}
    group by 1
),

customers_orders as (
    select * from {{ ref('stg_customers') }}
),

int_orders_enriched as (
    select
        -- Identifiers
        o.order_id,
        o.order_status,
        c.user_id,
        c.zip_code_prefix as customer_zip_code,

        -- Timestamps
        o.purchased_at,
        o.approved_at,
        o.shipped_at,
        o.delivered_at,
        o.estimated_delivery_at,

        -- Financials
        p.total_payment_amount,
        p.payment_method_count,
        p.max_installments,
        p.has_voucher_payment,

        -- Sentiment
        r.avg_rating_score,
        r.total_reviews,

        -- Logistics Business Logic
        datediff('day', o.purchased_at, o.delivered_at) as actual_delivery_time_days,
        datediff('day', o.delivered_at, o.estimated_delivery_at) as delivery_sla_delta_days,
        case 
            when o.delivered_at > o.estimated_delivery_at then 1 
            else 0 
        end as is_late_delivery

    from orders o
    left join payments p on o.order_id = p.order_id
    left join reviews r on o.order_id = r.order_id
    left join customers_orders c on o.customer_id = c.order_customer_key
)

select * from int_orders_enriched