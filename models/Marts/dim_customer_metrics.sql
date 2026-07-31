with customers as (
    select * from {{ ref('stg_tpch__customers') }}
),

orders as (
    select * from {{ ref('stg_tpch__orders') }}
),

customer_aggregations as (
    select
        customer_id,
        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        
        -- Calling our macro here!
        {{ calculate_customer_metrics(price_column='total_price', order_id_column='order_id') }}

    from orders
    group by customer_id
),

final as (
    select
        c.customer_id as CUSTOMER_KEY,
        c.customer_name as FULL_NAME,
        c.market_segment,
        c.account_balance as BANK_BALANCE,
        ca.first_order_date,
        ca.most_recent_order_date,
        coalesce(ca.total_orders, 0) as total_orders_CUSTOMERS,
        coalesce(ca.lifetime_value, 0) as lifetime_value_DOLLARS,
        coalesce(ca.avg_order_value, 0) as avg_order_value_DOLLARS
    from customers c
    left join customer_aggregations ca
        on c.customer_id = ca.customer_id
)

select * from final