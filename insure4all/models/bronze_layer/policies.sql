-- Bronze: Raw policy ingest
{{ config(materialized='table') }}
select * from {{ source('landing_raw', 'policy') }}
