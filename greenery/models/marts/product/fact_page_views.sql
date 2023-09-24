{{ config(materialized = 'table') }}

with int_product_sessions as (
    select * from {{ ref('int_product_sessions') }}
)
, int_product_orders as (
    select * from {{ ref('int_product_orders') }}
)
select
    ps.product_id
    , ps.session_date 
    , ps.session_count
    , ps.page_views
    , ps.add_to_carts
    , ps.session_user_count
    , po.order_count
    , po.order_product_count
    , po.order_user_count
from int_product_sessions ps 
left join int_product_orders po on po.product_id=ps.product_id and po.order_date=ps.session_date 
