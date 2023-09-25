{{ config(
     materialized='table',
     snowflake_warehouse=env_var('SNOWFLAKE_WAREHOUSE_XS'))
}}

select
    users.user_id,
    users.first_name,
    users.last_name,
    users.email,
    users.phone_number,
    users.created_at,
    users.updated_at,
    users.address_id,
    addresses.address,
    addresses.zipcode,
    addresses.state,
    addresses.country
from {{ ref('stg_users') }} as users
LEFT JOIN {{ ref('stg_addresses') }} as addresses
  ON u.address_id = a.address_id 