{{ config(materialized = 'table') }}

with events as (
    select * from {{ ref('stg_postgres__events') }}
)
, int_user_sessions AS (
    select
        user_id
        , session_id
        , sum(case when event_type = 'page_view' then 1 else 0 end) as page_views
        , sum(case when event_type = 'add_to_cart' then 1 else 0 end) as add_to_carts
        , sum(case when event_type = 'package_shipped' then 1 else 0 end) as package_shippeds
        , sum(case when event_type = 'checkout' then 1 else 0 end) as checkouts
        , min(created_at) AS first_session
        , max(created_at) AS last_session
    from events
    group by all
)

select * from int_user_sessions 