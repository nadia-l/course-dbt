--snowflake_warehouse env_var is to demonstrate another config we can apply. In our case we only have 1 size of 
--transformer_dev warehouse but we could have multiple and depending on model requirements
--we could choose to run/deploy against a bigger warehouse
{{ config(
     materialized='table',
     snowflake_warehouse=env_var('SNOWFLAKE_WAREHOUSE_XS'))
}}


{% set event_types = dbt_utils.get_column_values(
    table=ref('int_events_prep'),
    column='event_type'
)
%}

select
    session_id,
    {% for event_type in event_types %}
    {{ events_agg(event_type) }}
    {% if not loop.last %},{% endif %}
    {% endfor %}
from {{ ref('int_events_prep') }}
group by 1
