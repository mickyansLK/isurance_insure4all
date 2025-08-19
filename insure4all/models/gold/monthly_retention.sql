-- Gold: Monthly retention
select
  f.month,
  count(distinct c.customer_id) as retained_customers
from {{ ref('fact_event') }} f
left join {{ ref('dim_policy_type') }} p on f.policy_id = p.policy_id
left join {{ ref('dim_customers') }} c on p.customer_id = c.customer_id
group by f.month
