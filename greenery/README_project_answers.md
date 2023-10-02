Week 3
1] What is our overall conversion rate?
From newly created table dim_products in core folder, we see that the overall conversion(form all prodcuts) amounts
to ~62% on the basis of total events with checkout type over the total of unique session ids

2] What is our conversion rate by product?
The conversion rate by product is calculated within new model dim_product_performance_details.
In this table we see a variation of conversion rate between the products from 68% to 38%. The reason why is
multifactor, it could be the price, the marketing of each product, the shipping cost, the to door delivery depending on inventory availability.

3] how did the snapshot change since last week?
The same items as last week Pothos, Philodendron, Monstera and String of Pearls have been updated to a lower inventory plus two additional items Bamboo and ZZ plant. It seems that these items are trending.




Week_2
1] What is our user repeat rate?
76.2%

with cte_orders_per_user as (
select
    user_id,
    count(distinct order_id) as total_orders
from DEV_DB.DBT_KLYMPERIFLEXPORTCOM.STG_ORDERS
group by 1
having total_orders >= 2
),

cte_total_users as(
select count(distinct user_id) as total_users
from DEV_DB.DBT_KLYMPERIFLEXPORTCOM.STG_USERS
)

select 
    round(100*(count(user_id) / (select total_users from cte_total_users)),1) as repeat_rate_pct
from cte_orders_per_user;

2] What are good indicators of a user who will likely purchase again? What about indicators of users who are likely NOT to purchase again? If you had more data, what features would you want to look into to answer this question?

Metrics to look at to asses this question would be: users who have purchased more than 2 times in the span of the last 3 months. We would have to look at specific timeframes to assess what constitues a healthy frequency of bying.
Clients who add products to their cart instead of just viewing in combination with nr of purchaces. F.e. clients who haven't bought anything in the past year or cients who only bought once in the past 6 months would not be likely to purchace again.

3] how did the snapshot change since last week?
We can see that the items Pothos, Philodendron, Monstera and String of Pearls have been updated in the snapshot table with new entries that reflect the change in the inventory's availability.


Week_1
1] How many users do we have?
    - We have 130 distinct users
    select count(distinct user_id)
    from DEV_DB.DBT_KLYMPERIFLEXPORTCOM.STG_USERS

2] On average, how many orders do we receive per hour?
    - On average receive 7.5 orders per hour
    with 
    cte_orders_per_hour as (
    select
    date_trunc('hour', created_at) as order_hour,
    count(distinct order_id) as total_hourly_orders
    from DEV_DB.DBT_KLYMPERIFLEXPORTCOM.stg_orders
    group by 1
    )
    select 
        round(avg(total_hourly_orders),1) as avg_hourly_orders
    from cte_orders_per_hour;

3] On average, how long does an order take from being placed to being delivered?
    - On average we take 3.9 days to deliver the goods from the time of placing the order
    select
    round(avg(datediff(days, created_at, delivered_at)),1) as days_to_delivery
    from DEV_DB.DBT_KLYMPERIFLEXPORTCOM.stg_orders

4] How many users have only made one purchase? Two purchases? Three+ purchases?
   - In our historical data we have 25 users that placed 1 order, 28 users with 2 orders while 71 ordered more than 3.
   with order_count as (
    select
        user_id,
        count(order_id) as total_orders
    from DEV_DB.DBT_KLYMPERIFLEXPORTCOM.stg_orders
    group by 1)

    select
        sum(case when total_orders = 1 then 1 else 0 end) as nr_users_1_order,
        sum(case when total_orders = 2 then 1 else 0 end) as nr_users_2_order,
        sum(case when total_orders >= 3 then 1 else 0 end) as nr_users_3_order
    from order_count;

5] On average, how many unique sessions do we have per hour?
    -We average at 61.3 sessions per hour
    with
        cte_hourly_sessions as (
        select
        date_trunc('hour', created_at) as hourly_session,
        count(session_id) as total_sessions
    from DEV_DB.DBT_KLYMPERIFLEXPORTCOM.stg_events
    group by 1)

    select 
        round(avg(total_sessions),1) as avg_hourly_sessions
    from cte_hourly_sessions;

