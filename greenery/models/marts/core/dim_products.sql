{{ config(materialized = 'table') }}

with products as (
    select * from {{ ref('stg_postgres__products') }}
)
, dim_products as (
    select 
        product_id
        , name as product_name
        , price as product_price
        , inventory as product_inventory
    from products
)

select * from dim_products

