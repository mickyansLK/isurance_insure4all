-- Gold: Claims per region
select
  c.region,
  count(*) as total_claims
from {{ ref('fact_event') }} f
left join {{ ref('dim_policy_type') }} p on f.policy_id = p.policy_id
left join {{ ref('dim_customers') }} c on p.customer_id = c.customer_id
group by c.region
