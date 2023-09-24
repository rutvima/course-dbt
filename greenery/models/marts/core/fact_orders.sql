{{ config(materialized = 'table') }}

with int_orders as (
    select * from {{ ref('int_orders') }}
)
, addresses as (
    select * from {{ ref('stg_postgres__addresses') }}
)
select 
    orders.order_id
    , orders.user_id
    , orders.order_cost
    , orders.shipping_cost
    , orders.order_total
    , orders.promo_discount
    , orders.order_product_count
    , orders.order_total_items
    , addresses.zipcode as user_zipcode
    , addresses.state as user_state
    , addresses.country as user_country
    , orders.tracking_id
    , orders.shipping_service
    , orders.estimated_delivery_at
    , orders.delivered_at
    , orders.order_status
    , orders.created_at
from int_orders orders
left join addresses on addresses.address_id=orders.address_id