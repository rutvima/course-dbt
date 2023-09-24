{{ config(materialized = 'table') }}

with int_orders as (
    select * from {{ ref('int_orders') }}
)
, t_users as (
    select * from {{ ref('stg_postgres__users') }}
)
, user_order as (
    select 
        user_id
        , count(order_id) as user_order_count
        , sum(order_total) as user_total_cost
        , avg(order_total) as avg_user_total_cost
        , avg(promo_discount) as avg_promo_discounts
        , avg(order_product_count) as avg_order_product_count
        , avg(order_total_items) as avg_order_total_items
        , min(created_at) as first_order
        , max(created_at) as last_order    
    from int_orders
    group by user_id
)
select 
    uo.user_id
    , u.first_name
    , u.last_name
    , uo.user_order_count
    , uo.user_total_cost
    , uo.avg_user_total_cost
    , uo.avg_promo_discounts
    , uo.avg_order_product_count
    , uo.avg_order_total_items
    , uo.first_order
    , uo.last_order  
from user_order uo
inner join t_users u on u.user_id=uo.user_id
