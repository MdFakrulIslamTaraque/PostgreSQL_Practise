--  top 5 rental rate descending order. must be unique. (don't use default asc, desc fn)

SELECT
     distinct rental_rate
FROM (
    SELECT
        rental_rate,
        DENSE_RANK() OVER (ORDER BY rental_rate DESC) AS row_num
    FROM
        film
) AS ranked_films
WHERE
    row_num <= 5
order by rental_rate;

---------------------------------------- cte approach ----------------------------------
-- here we are partitioning by rental_rate and then ordering by rental_rate, for which all the same rental_rate will have same seq number, and getting new rental_rate will reset the seq number to 1.
-- so we are filtering the seq number = 1 to get the unique rental_rate.
with cte as (
	select rental_rate
	, row_number() over (partition by rental_rate order by rental_rate) as seq
	from film f
)
select *
from cte
where seq = 1;