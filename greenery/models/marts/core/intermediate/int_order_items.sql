{{ config(
     materialized='table',
     snowflake_warehouse=env_var('SNOWFLAKE_WAREHOUSE_XS'))
}}

--In this table we are calculating the total of items per order
--from the staging order items table.

select
    --primary key
    order_id,
    --total items per orders
    sum(quantity) as total_order_items
from {{ ref('stg_order_items') }}
group by 1