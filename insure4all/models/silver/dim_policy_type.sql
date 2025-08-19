
{{ config(
    materialized='incremental',
    unique_key='policy_id',
    incremental_strategy='merge'
) }}

with cleaned_policy as (
  select
    trim(policy_id)   as policy_id,
    trim(customer_id) as customer_id,
    coverage_amount,
    premium_amount,
    policy_type,
    cast(parse_json(policy_type):type as string) as type,
    cast(parse_json(policy_type):brand as string) as brand
  from {{ source('landing_raw', 'policy') }}
),
event_dates as (
  select
    policy_id,
    min(cast(event_timestamp as timestamp)) as first_event_date,
    max(cast(event_timestamp as timestamp)) as last_event_date
  from {{ source('landing_raw', 'event') }}
  group by policy_id
)
select
  p.policy_id,
  p.customer_id,
  p.coverage_amount,
  p.premium_amount,
  p.policy_type,
  cast(p.type as string) as type,
  cast(p.brand as string) as brand,
  e.first_event_date,
  e.last_event_date
from cleaned_policy p
left join event_dates e on p.policy_id = e.policy_id

{% if is_incremental() %}
  where e.last_event_date > (select max(last_event_date) from {{ this }})
{% endif %}
