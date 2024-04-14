-- 4. all records avg(rental duration) > rental_duration

-------------------------------------- with cte --------------------------------------
explain analyze
with cte as (
	select avg(rental_duration) avg_rental_duration from public.film
),
result as (
	select rental_duration, ct.avg_rental_duration from public.film ff, cte ct where ff.rental_duration > ct.avg_rental_duration 
)
select * from result


-------------------------------------- with subquery --------------------------------------
explain analyse
select
	rental_duration
from
	public.film ff
where
	rental_duration > (
		select
			avg(f2.rental_duration)
		from
			public.film f2
	)