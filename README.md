# Analytics engineering with dbt
***Week 2 - Answers to questions***

> What is our user repeat rate? 79.8%

```sql
with order_per_user as (
    select 
        user_id
        , count(distinct order_id) as order_count
    from stg_postgres__orders
    group by 1
)
, order_range as (
    select 
        user_id
        , (case when order_count=1 then 1 else 0 end) as one_order
        , (case when order_count>1 then 1 else 0 end) as more_one_order
    from order_per_user
)

select round(sum(more_one_order) / count(distinct user_id),3) 
from order_range 
```
> What are good indicators of a user who will likely purchase again? What about indicators of users who are likely NOT to purchase again?

Good indicators of users who are more likely to purchase:
* High repeat rate
* Recency: days after the last order (If they made an order recently, the likelihood of them making another order is high).
* High quality experience: no issues with the order, receive the order without delay, etc.
* Have promo discounts

> Explain the product mart models you added. Why did you organize the models in the way you did?
There are 3 marts: product, core, marketing.
* *Core*: I have created two dimensions (users and products) and one fact table (fact_order). I have created an intermediate table "int_orders" to calculate the number of products included in each order. This intermediate table is used to create the fact_orders table.
* *Marketing*: The fact_user_orders used the intermediate table "int_orders" and calculates several metrics such as how many orders each user made, total amount, etc.
* *Product*: I have created two intermediate tables: int_product_session (aggregations of number of events, sessions, etc. per product and day) and int_product_orders (aggregations of number of orders, quantity, etc. per product and day). These two tables are joined to created the fact table fact_page_views to analyze how different products perform.

> Tests performed.

The main tests performed have been for uniqueness and not being null in the primary keys.
Also I created some tests for ensuring positive values in user_order_count and order_total and for referential integrity in product_id with dim_products.

> Snapshot. Which products had their inventory change from week 1 to week 2? 

Four products had their inventory changed: Pothos, Philodendron, Monstera and String of pearls.


***Week 1 - Answers to questions***

> How many users do we have? 130

```sql
select 
    count(distinct user_id) as num_users
from stg_postgres__users
```

> On average, how many orders do we receive per hour? 7.52

```sql
with orders_per_hour as
(
    select 
        date_trunc('hour', created_at) as hour
        , count(order_id) as num_orders_per_hour
    from stg_postgres__orders
    group by 1
)
select 
    avg(num_orders_per_hour) as avg_orders_per_hour
from orders_per_hour
```

> On average, how long does an order take from being placed to being delivered? 93.4

```sql
with delivered_hours as
(
    select 
        order_id
        , created_at
        , delivered_at
        , datediff('hour', created_at, delivered_at) as diff_hours
    from stg_postgres__orders
    where delivered_at is not null
)
select 
    avg(diff_hours) as avg_created_to_delivered_hours
from delivered_hours
```

> How many users have only made one purchase? Two purchases? Three+ purchases? 1 purchase = 25, 2 purchases = 28, 3+ purchases = 71

```sql
with orders_per_user as 
(
select 
    u.user_id
    , count(order_id) as orders_per_user
from stg_postgres__orders o
join stg_postgres__users u on o.user_id = u.user_id
group by 1
)
select 
    (case when orders_per_user >= 3 then 3 else orders_per_user end) as orders_per_user
    , count(user_id) as num_users
from orders_per_user
group by 1
order by 1
```

> On average, how many unique sessions do we have per hour? 16.33

```sql
with sessions_per_hour as 
(
    select 
        date_trunc('hour', created_at) as sessions_per_hour
        , count(distinct session_id) as num_sessions    
    from stg_postgres__events
    group by 1
    
)
select 
    avg(num_sessions) as avg_sessions
from sessions_per_hour
```

## License
GPL-3.0
