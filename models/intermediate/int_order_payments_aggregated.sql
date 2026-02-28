with payments as (

    select 
        order_id,
        cast(
            payment_method_sequence as number
        ) as payment_method_sequence,
        payment_method,
        cast(
            installment_count as number
        ) as installment_count,
        cast(
            payment_amount as number(10,2)
        ) as payment_amount

    from {{ ref('stg_order_payments') }}

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
        max(case when payment_method = 'invoice' then 1 else 0 end) as has_invoice_payment

    from payments
    group by 1

)

select * from int_order_payments_aggregated