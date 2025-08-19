
{{ config(
    materialized='incremental',
    unique_key='customer_id',
    incremental_strategy='merge'
) }}

with cleaned_policy as (
  select
    customer_id,
    cast(parse_json(policy_type):type as string) as policy_type,
    cast(parse_json(policy_type):brand as string) as brand
  from {{ source('landing_raw', 'policy') }}
  qualify row_number() over (partition by customer_id, policy_type, brand order by customer_id) = 1
)
select
  trim(c.customer_id) as customer_id,
  case
    when coalesce(c.age, 0) < 18 then 'Under 18'
    when c.age between 18 and 25 then '18-25'
    when c.age between 26 and 35 then '26-35'
    when c.age between 36 and 50 then '36-50'
    when c.age > 50 then 'Over 50'
    else 'Unknown'
  end as age_range,
  upper(c.region) as region,
  cast(p.policy_type as string) as policy_type,
  cast(p.brand as string) as brand
from {{ source('landing_raw', 'customer') }} c
left join cleaned_policy p on c.customer_id = p.customer_id

{% if is_incremental() %}
  where c.customer_id not in (select customer_id from {{ this }})
{% endif %}
