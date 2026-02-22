with source as (

    select * from {{ source('olist_raw', 'olist_order_payments') }}

),

stg_order_payments as (

    select
        order_id,
        payment_sequential as payment_method_sequence, -- e.g., 1st payment, 2nd payment
        payment_type as payment_method,
        CAST(IFF(payment_installments = 0, 1, payment_installments) AS INTEGER) as installment_count,
        payment_value as payment_amount

    from source

)

select * from stg_order_payments