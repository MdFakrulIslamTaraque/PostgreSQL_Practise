-- 3.  rating col:
		-- one col: no string
		-- another co: no int 

SELECT
    rating
    , unnest(regexp_match(rating::text, '([a-zA-Z]+)')) as string_value
    , unnest(regexp_match(rating::text, '(\d+)')) as string_value

FROM
    film;