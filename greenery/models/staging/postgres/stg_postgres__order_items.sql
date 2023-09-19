{{ config(materialized = 'table' ) }}

with source as (
    select * from {{ source('postgres', 'order_items') }}
),

stg_order_items as (

    select
        order_id,
        product_id,
        quantity

    from source

)

select * from stg_order_items
