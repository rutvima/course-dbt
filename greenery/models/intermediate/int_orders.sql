{{ config(materialized = 'table') }}

with order_items as (
    select * from {{ ref('stg_postgres__order_items') }}
)
, orders as (
    select * from {{ ref('stg_postgres__orders') }}
)
, promos as (
    select * from {{ ref('stg_postgres__promos') }}
)
, order_items_agg as (
    select 
        order_id
        , count(distinct product_id) as order_product_count
        , sum(quantity) as order_total_items
    from order_items
    group by 1

)
, int_orders as (
select 
    orders.order_id
    , orders.user_id
    , orders.order_cost
    , orders.shipping_cost
    , orders.order_total
    , promos.discount as promo_discount
    , items.order_product_count
    , items.order_total_items
    , orders.address_id
    , orders.tracking_id
    , orders.shipping_service
    , orders.estimated_delivery_at
    , orders.delivered_at
    , orders.status as order_status
    , orders.created_at
from orders 
inner join order_items_agg items on items.order_id=orders.order_id
left join promos on promos.promo_id=orders.promo_id
)

select * from int_orders