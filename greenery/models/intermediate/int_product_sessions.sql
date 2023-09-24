{{ config(materialized = 'table') }}

with events as (
    select * from {{ ref('stg_postgres__events') }}
)
, int_product_sessions as (
    select 
        product_id
        , date(created_at) as session_date
        , count(distinct session_id) as session_count  
        , sum(case when event_type = 'page_view' then 1 else 0 end) as page_views
        , sum(case when event_type = 'add_to_cart' then 1 else 0 end) as add_to_carts
        , count(distinct user_id) as session_user_count         
    from events
    where product_id is not null
    group by all
)

select * from int_product_sessions