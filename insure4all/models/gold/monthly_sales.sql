-- Gold: Monthly sales
select
  f.month,
  sum(p.coverage_amount) as total_sales
from {{ ref('fact_event') }} f
left join {{ ref('dim_policy_type') }} p on f.policy_id = p.policy_id
group by f.month
