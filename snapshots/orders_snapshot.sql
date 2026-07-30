{% snapshot orders_snapshot %}

{{
    config(
      target_database='ANALYTICS_DEV',
      target_schema='snapshots',
      unique_key='o_orderkey',
      strategy='check',
      check_cols=['o_orderstatus', 'o_totalprice']
    )
}}

select * from {{ source('tpch', 'raw_orders') }}

{% endsnapshot %}