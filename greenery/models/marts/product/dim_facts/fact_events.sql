{{ config(
     materialized='table',
     snowflake_warehouse=env_var('SNOWFLAKE_WAREHOUSE_XS'))
}}


select
     event_id,
     session_id,
     user_id,
     created_at,
     event_type,
     product_id,
     product_name,
     product_price
from {{ ref('int_events_prep') }}