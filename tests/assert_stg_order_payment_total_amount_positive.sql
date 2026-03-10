select
    payments.order_id,
    sum(payments.payment_amount) as total_amount

from {{ ref('stg_order_payments') }} as payments

left join {{ ref('stg_orders') }} as orders
    on payments.order_id = orders.order_id

where orders.order_status != 'canceled'
group by 1

having sum(payments.payment_amount) <= 0