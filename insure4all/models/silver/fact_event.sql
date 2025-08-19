
{{ config(
    materialized='incremental',
    unique_key='policy_id',
    incremental_strategy='merge'
) }}

select
  policy_id,
  event_timestamp,
  event_type,
  extract(month from cast(event_timestamp as timestamp)) as month,
  extract(year from cast(event_timestamp as timestamp)) as year,
  to_char(cast(event_timestamp as timestamp), 'MM-YYYY') as month_year
from {{ source('landing_raw', 'event') }}

{% if is_incremental() %}
  where cast(event_timestamp as timestamp) > (select max(cast(event_timestamp as timestamp)) from {{ this }})
{% endif %}
