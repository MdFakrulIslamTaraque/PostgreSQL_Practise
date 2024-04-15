-- 4. top 5 lengthy movie (use film id, length) (desc order). (don't use default asc, desc fn)
select
     film_id
    , title
    , length
    , row_num
from
(
    select
        ff.film_id
       , ff.length
       , ff.title
       , dense_rank() over (order by ff.length) as row_num
    from film ff
    order by row_num
) as tb
where row_num <= 5
order by row_num


------------------------------------- cte approach ----------------------------------
with cte as (
	select
		f.length
		, dense_rank() over (order by f.length) as seq
	from
		film f
)
select
	*
from
	cte
where
	seq <= 5
