with payments as (

    select * from {{ ref('stg_order_payments') }}

),

int_order_payments_aggregated as (

    select
        order_id,
        
        -- Financial Aggregations
        sum(payment_amount) as total_payment_amount,
        
        -- Installment Logic: We want to know the maximum plan chosen for the order
        max(installment_count) as max_installments,
        
        -- Payment Method Diversity
        count(payment_method_sequence) as payment_method_count,
        
        -- Creating flags for specific payment methods (High business value)
        max(case when payment_method = 'credit_card' then 1 else 0 end) as has_credit_card_payment,
        max(case when payment_method = 'voucher' then 1 else 0 end) as has_voucher_payment,
        max(case when payment_method = 'boleto' then 1 else 0 end) as has_boleto_payment

    from payments
    group by 1

)

select * from int_order_payments_aggregated