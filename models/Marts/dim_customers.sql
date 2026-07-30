with
    customers as (select * from {{ ref("stg_tpch__customers") }}),

    nations as (select * from {{ ref("stg_tpch__nations") }}),

    orders as (select * from {{ ref("stg_tpch__orders") }}),

    customer_orders as (
        select
            customer_id,
            min(order_date) as first_order_date,
            max(order_date) as most_recent_order_date,
            count(order_id) as number_of_orders,
            sum(total_price) as lifetime_value
        from orders
        group by customer_id
    ),

    final as (
        select
            customers.customer_id,
            customers.customer_name,
            nations.nation_name,
            customers.market_segment,
            customers.account_balance,
            coalesce(customer_orders.number_of_orders, 0) as number_of_orders,
            customer_orders.first_order_date,
            customer_orders.most_recent_order_date,
            coalesce(customer_orders.lifetime_value, 0) as lifetime_value
        from customers
        left join nations on customers.nation_id = nations.nation_id
        left join customer_orders on customers.customer_id = customer_orders.customer_id
    )

select *
from final
