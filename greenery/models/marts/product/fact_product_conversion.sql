{{ config(materialized = 'table') }}

with int_session as (
    select * from {{ ref('int_sessions') }}
)
, int_conversion as (
    select * from {{ ref('int_session_conversions') }}
)
select 
    product_id,
    s.session_id,
    page_views,
    add_to_carts,
    c.conversion
from int_sessions s
left join int_conversion c on c.session_id=s.session_id
where product_id is not null