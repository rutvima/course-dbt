{{ config(materialized = 'table') }}

with sessions as (
    select * from {{ ref('int_sessions') }}
)
, conversion as (
    select 
        session_id,
        sum(case when checkouts>=1 then 1 else 0 end) as conversion
    from sessions
    group by 1       
)

select * from conversion