--convert datetime to only date
select
	last_update
	, last_update::date
from
	public.film
;