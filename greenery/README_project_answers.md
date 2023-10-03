Week 3
1] What is our overall conversion rate?
From newly created table dim_products in core folder, we see that the overall conversion(form all prodcuts) amounts
to ~62% on the basis of total events with checkout type over the total of unique session ids. The below results 
comes from table dim_products.sql

|PURCHASE_EVENTS |TOTAL_SESSIONS	|TOTAL_CONVERSION_RATE|
|-|-|-|
|361	|578	|62


2] What is our conversion rate by product?
The conversion rate by product is calculated within new model dim_product_performance_details.
In this table we see a variation of conversion rate. The reason why is
multifactor, it could be the price, the marketing of each product, the shipping cost, the to door delivery depending on inventory availability.

```SQL
PRODUCT_ID	PRODUCT_NAME	PRODUCT_PURCHASE_EVENTS	PRODUCT_TOTAL_SESSIONS	PRODUCT_CONVERSION_RATE
fb0e8be7-5ac4-4a76-a1fa-2cc4bf0b2d80	String of pearls	39	64	61
74aeb414-e3dd-4e8a-beef-0fa45225214d	Arrow Head	35	63	56
c17e63f7-0d28-4a95-8248-b01ea354840e	Cactus	30	55	55
689fb64e-a4a2-45c5-b9f2-480c2155624d	Bamboo	36	67	54
b66a7143-c18a-43bb-b5dc-06bb5d1d3160	ZZ Plant	34	63	54
579f4cd0-1f45-49d2-af55-9ab2b72c3b35	Rubber Plant	28	54	52
be49171b-9f72-4fc9-bf7a-9a52e259836b	Monstera	25	49	51
b86ae24b-6f59-47e8-8adc-b17d88cbd367	Calathea Makoyana	27	53	51
e706ab70-b396-4d30-a6b2-a1ccf3625b52	Fiddle Leaf Fig	28	56	50
615695d3-8ffd-4850-bcf7-944cf6d3685b	Aloe Vera	32	65	49
5ceddd13-cf00-481f-9285-8340ab95d06d	Majesty Palm	33	67	49
35550082-a52d-4301-8f06-05b30f6f3616	Devil's Ivy	22	45	49
a88a23ef-679c-4743-b151-dc7722040d8c	Jade Plant	22	46	48
55c6a062-5f4a-4a8b-a8e5-05ea5e6715a3	Philodendron	30	62	48
37e0062f-bd15-4c3e-b272-558a86d90598	Dragon Tree	29	62	47
64d39754-03e4-4fa0-b1ea-5f4293315f67	Spider Plant	28	59	47
5b50b820-1d0a-4231-9422-75e7f6b0cecf	Pilea Peperomioides	28	59	47
d3e228db-8ca5-42ad-bb0a-2148e876cc59	Money Tree	26	56	46
c7050c3b-a898-424d-8d98-ab0aaad7bef4	Orchid	34	75	45
05df0866-1a66-41d8-9ed7-e2bbcddd6a3d	Bird of Paradise	27	60	45
843b6553-dc6a-4fc4-bceb-02cd39af0168	Ficus	29	68	43
80eda933-749d-4fc6-91d5-613d29eb126f	Pink Anthurium	31	74	42
bb19d194-e1bd-4358-819e-cd1f1b401c0c	Birds Nest Fern	33	78	42
6f3a3072-a24d-4d11-9cef-25b0b5f8a4af	Alocasia Polly	21	51	41
e2e78dfc-f25c-4fec-a002-8e280d61a2f2	Boston Fern	26	63	41
e5ee99b6-519f-4218-8b41-62f48f59f700	Peace Lily	27	66	41
e8b6528e-a830-4d03-a027-473b411c7f02	Snake Plant	29	73	40
e18f33a6-b89a-4fbc-82ad-ccba5bb261cc	Ponytail Palm	28	70	40
58b575f2-2192-4a53-9d21-df9a0c14fc25	Angel Wings Begonia	24	61	39
4cda01b9-62e2-46c5-830f-b7f262a58fb1	Pothos	21	61	34
```






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

