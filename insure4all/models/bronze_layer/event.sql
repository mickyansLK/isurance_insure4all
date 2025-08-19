
-- Bronze: Raw event ingest with loaded_at for freshness
select *,
	current_timestamp() as loaded_at
from {{ source('landing_raw', 'event') }}
