{{ config(materialized = 'table') }}

with t_users as (
    select * from {{ ref('stg_postgres__users') }}
)
, addresses as (
    select * from {{ ref('stg_postgres__addresses') }}
)
, dim_users as (  
    select 
         u.user_id
        , u.first_name
        , u.last_name
        , email as user_email
        , u.phone_number as user_phone_number
        , a.address as user_address
        , a.zipcode as user_zipcode
        , a.state as user_state
        , a.country as user_country
        , u.created_at
        , u.updated_at
    from t_users u 
    inner join addresses a on a.address_id=u.address_id
)
select * from dim_users