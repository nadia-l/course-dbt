--snowflake_warehouse env_var is to demonstrate another config we can apply. In our case we only have 1 size of 
--transformer_dev warehouse but we could have multiple and depending on model requirements
--we could choose to run/deploy against a bigger warehouse
{{ config(
     materialized='table',
     snowflake_warehouse=env_var('SNOWFLAKE_WAREHOUSE_XS'))
}}

-- This table leverages staging tables to expose information
-- on created orders and products for all event types, irrelevant to whether the order
-- has been completed or not.

select 
    events.event_id,
    events.session_id,
    events.user_id,
    events.order_id,
    events.event_type,
    events.created_at,
    events.product_id,
    orders.promo_id,
    orders.created_at as order_created_at,
    orders.order_cost,
    orders.shipping_cost,
    orders.order_total,
    orders.tracking_id,
    products.product_name,
    products.product_price
from {{ ref('stg_events')}} as events
--left join will only bring in info from orders for the events that were checked out
left join {{ ref('stg_orders')}} as orders
    on events.order_id = orders.order_id
--left join will bring in info for all products included in events, assumming no product is missing from the stg_product inventory table
left join {{ ref('stg_products')}} as products
    on events.product_id = products.product_id