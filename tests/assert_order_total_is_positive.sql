-- tests/assert_order_total_is_positive.sql
-- Returns records where total_price is negative or zero (which indicates broken data)

select
    order_id,
    total_price
from {{ ref('stg_tpch__orders') }}
where total_price <= 0