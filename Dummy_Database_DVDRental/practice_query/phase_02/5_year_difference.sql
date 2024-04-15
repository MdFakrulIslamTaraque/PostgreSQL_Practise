-- 5. calculate how many years from current date. use last_update col.
select
    ff.film_id
    , ff.title
    , extract(year from ff.last_update) as year
    , extract(year from current_timestamp) - extract(year from ff.last_update) year_difference
    , age(current_timestamp, ff.last_update)
from
    film ff