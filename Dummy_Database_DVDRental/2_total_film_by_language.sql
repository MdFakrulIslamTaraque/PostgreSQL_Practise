-- 2. total films by language
select
	language_id
	, count(film_id) number_of_films
from 
	public.film
group by 
	language_id 
;