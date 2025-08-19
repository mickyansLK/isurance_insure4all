# Insure4All dbt Project

**Author:** Michael Ansah <mickyansk@gmail.com>

## Overview

Insure4All is a production-grade dbt project implementing the medallion architecture (bronze, silver, gold) for insurance analytics on Databricks. It is designed for scalability, robustness, and data quality, following senior data engineering best practices.

## Architecture

- **Bronze Layer:** Raw ingestion from source tables (`landing_raw.customer`, `policy`, `event`). Adds a generated `loaded_at` column for freshness monitoring.
- **Silver Layer:** Dimensional and fact models with incremental logic for efficient upserts. Includes:
  - `dim_customers`: Customer dimension with age range and region.
  - `dim_policy_type`: Policy dimension with type, brand, coverage, premium, and event dates.
  - `fact_event`: Transactional event fact table (incremental).
- **Gold Layer:** Reporting and analytics models (claims per region, monthly retention, sales).

## Data Quality & Testing

- Comprehensive dbt tests: `not_null`, `unique`, `accepted_values`, `relationships`, and `dbt_expectations`.
- Source freshness checks on bronze-layer models using the `loaded_at` column.
- All tests pass and models are idempotent.

## Documentation

- Rich model and column documentation in `schema.yml` for dbt docs.
- To generate and view docs:

  ```bash
  dbt docs generate
  dbt docs serve
  ```

## Incremental Models

- `fact_event`, `dim_customers`, and `dim_policy_type` use dbt incremental materializations for scalable, efficient loads.

## Source Freshness

- Freshness checks are configured for all raw tables. Run:

  ```bash
  dbt source freshness
  ```
- Custom tests monitor model-level freshness if source tables lack a timestamp.

## CI/CD & Automation

- Recommended: Integrate with GitHub Actions, Azure DevOps, or similar for automated dbt runs, tests, and docs.
- Example workflow:
  - On commit: run `dbt build`, `dbt test`, and `dbt docs generate`.
  - Alert on test or freshness failures.

## Getting Started

1. Install dependencies and activate your Python environment.
2. Configure your Databricks connection in `profiles.yml`.
3. Run:

   ```bash
   dbt deps
   dbt build
   dbt test
   dbt docs generate
   dbt docs serve
   ```

## Project Structure

```
insure4all/
  models/
    bronze_layer/
    silver/
    gold/
  dbt_project.yml
  README.md
  ...
```

## Advanced Features

- Supports incremental loads, source freshness, and robust testing.
- Easily extensible for new sources, models, and analytics.
- Follows best practices for modularity, documentation, and maintainability.

## Support & Resources

- [dbt Documentation](https://docs.getdbt.com/docs/introduction)
- [dbt Discourse](https://discourse.getdbt.com/)
- [dbt Community Slack](https://community.getdbt.com/)
- [dbt Events](https://events.getdbt.com)
- [dbt Blog](https://blog.getdbt.com/)

---
For questions or enhancements, contact Michael Ansah <mickyansk@gmail.com>.
