-- 3.  rating col:
		-- one col: no string
		-- another co: no int 

with cte as (
	select rating
    , unnest(regexp_match(rating::text, '([a-zA-Z]+)')) as string_value
    , unnest(regexp_match(rating::text, '(\d+)'))::numeric as numeric_value
FROM
    film
)
select rating
	,coalesce(string_value, 'N/A')
	, coalesce (numeric_value, 0)
from cte;