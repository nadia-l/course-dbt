--snowflake_warehouse env_var is to demonstrate another config we can apply. In our case we only have 1 size of 
--transformer_dev warehouse but we could have multiple and depending on model requirements
--we could choose to run/deploy against a bigger warehouse
{{ config(
     materialized='table',
     snowflake_warehouse=env_var('SNOWFLAKE_WAREHOUSE_XS'))
}}

--Calculating the conversion rate per product
--Note in this case we do not use 'checkout' event_type but add_to_cart to come up with the rate
--Although this is not correct, we should be using checkout, the source data is insufficient for this
--as STG_EVENTS only contains null product_ids for event types checkout
select
    e.product_id,
    p.product_name,
    sum(case when e.event_type = 'checkout' then 1 else 0 end) as product_purchase_events,
    count(distinct e.session_id) as product_total_sessions,
    round(100*(product_purchase_events / product_total_sessions),0) as product_conversion_rate
from {{ ref('int_events_prep')}} as e
join {{ ref('stg_products') }} as p
    on e.product_id = p.product_id
group by 1,2
order by product_conversion_rate desc
