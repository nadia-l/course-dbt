--snowflake_warehouse env_var is to demonstrate another config we can apply. In our case we only have 1 size of 
--transformer_dev warehouse but we could have multiple and depending on model requirements
--we could choose to run/deploy against a bigger warehouse
{{ config(
     materialized='table',
     snowflake_warehouse=env_var('SNOWFLAKE_WAREHOUSE_XS'))
}}

select
    sum(case when event_type = 'checkout' then 1 else 0 end) as purchase_events,
    count(distinct session_id) as total_sessions,
    round(100*(purchase_events / total_sessions),0) as total_conversion_rate
from {{ ref('stg_events')}}

