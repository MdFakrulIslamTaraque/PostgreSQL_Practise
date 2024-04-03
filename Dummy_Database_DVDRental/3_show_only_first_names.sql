-- 3. only first name
select
	title
	, split_part(title, ' ', 1) 
from
	public.film
;
