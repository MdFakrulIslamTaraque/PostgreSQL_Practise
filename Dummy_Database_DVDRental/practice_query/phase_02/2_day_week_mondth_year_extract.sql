-- 2. last update col: extract year, month, day, week
SELECT
    EXTRACT(YEAR FROM last_update) AS year,
    EXTRACT(MONTH FROM last_update) AS month,
    EXTRACT(DAY FROM last_update) AS day,
    EXTRACT(WEEK FROM last_update) AS week
FROM
    film;