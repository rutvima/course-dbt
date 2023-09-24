{{ config(materialized = 'table') }}

with orders as (
    select * from {{ ref('stg_postgres__orders') }}
)
,order_items as (
    select * from {{ ref('stg_postgres__order_items') }}
)
, int_product_orders as (
    select 
        i.product_id
        , date(o.created_at) as order_date
        , count(distinct o.order_id) as order_count
        , sum(i.quantity) as order_product_count
        , count(distinct o.user_id) as order_user_count   
    from stg_postgres__orders o
    inner join stg_postgres__order_items i on i.order_id=o.order_id
    group by all
)

select * from int_product_orders
