{{ config(
     materialized='table',
     snowflake_warehouse=env_var('SNOWFLAKE_WAREHOUSE_XS'))
}}

select
    orders.order_id,
    orders.user_id,
    orders.promo_id,
    orders.address_id,
    orders.created_at,
    orders.order_cost,
    orders.shipping_cost,
    orders.order_total,
    orders.tracking_id,
    orders.shipping_service,
    orders.estimated_delivery_at,
    orders.delivered_at,
    orders.order_status,
    promos.promo_code_discount,
    total_items.total_order_items
from {{ ref('stg_orders') }} as orders
left join {{ ref('stg_promos') }} as promos
  on orders.promo_id = promos.promo_id
left join {{ ref('stg_users') }} as users
  on orders.user_id = users.user_id
left join {{ ref('int_order_items') }} as total_items
  on orders.order_id = total_items.order_id