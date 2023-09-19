{{ config(materialized = 'table' ) }}

with source as (
    select * from {{ source('postgres', 'promos') }}
),

stg_promos as (

    select
        promo_id,
        discount,
        status

    from source
)

select * from stg_promos
