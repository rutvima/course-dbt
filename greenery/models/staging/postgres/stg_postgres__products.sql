{{ config(materialized = 'table' ) }}

with source as (
    select * from {{ source('postgres', 'products') }}
),

stg_products as (

    select
        product_id,
        name,
        price,
        inventory

    from source

)

select * from stg_products

