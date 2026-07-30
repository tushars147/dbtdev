{% macro calculate_customer_metrics(price_column='total_price', order_id_column='order_id') %}
    count(distinct {{ order_id_column }}) as total_orders,
    coalesce(sum({{ price_column }}), 0) as lifetime_value,
    coalesce(
        sum({{ price_column }}) / nullif(count(distinct {{ order_id_column }}), 0), 
        0
    ) as avg_order_value
{% endmacro %}