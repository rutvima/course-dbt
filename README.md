# Analytics engineering with dbt

Week 1 - Answers to questions

> How many users do we have? 130

````
```
select 
    count(distinct user_id) as num_users
from stg_postgres__users
````
```

> On average, how many orders do we receive per hour? 7.52

````
```
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
````
```

> On average, how long does an order take from being placed to being delivered? 93.4

````
```
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
````
```

> How many users have only made one purchase? Two purchases? Three+ purchases? 1 purchase = 25, 2 purchases = 28, 3+ purchases = 71

````
```
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
````
```

> On average, how many unique sessions do we have per hour? 16.33

````
```
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
````
```

## License
GPL-3.0
