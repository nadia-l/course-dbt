--snowflake_warehouse env_var is to demonstrate another config we can apply. In our case we only have 1 size of 
--transformer_dev warehouse but we could have multiple and depending on model requirements
--we could choose to run/deploy against a bigger warehouse
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
where 
     event_type = 'page_view'