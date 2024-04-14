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