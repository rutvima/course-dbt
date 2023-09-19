{{ config(materialized = 'table') }}

with source as (
    select * from {{ source('postgres', 'addresses') }}
),

stg_addresses as (

    select 
        address_id,
        address,
        zipcode,
        state,
        country

    from source

)

select * from stg_addresses
