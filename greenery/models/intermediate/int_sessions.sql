{{ config(materialized = 'table') }}

with events as (
    select * from {{ ref('stg_postgres__events') }}
)
, sessions as (
    select
        session_id
        , product_id
        {{event_types('stg_postgres__events','event_type') }} 
    from events
    group by all
)

select * from sessions