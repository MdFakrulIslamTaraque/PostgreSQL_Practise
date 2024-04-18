-- insert into the film table if the provided_time from user input is greater than the max last_update timestamp in the film table
DO $$
DECLARE
    current_ts TIMESTAMP :=  CURRENT_TIMESTAMP; -- '2014-05-26 14:50:58.951';
BEGIN
    WITH cte AS (
        SELECT MAX(last_update) AS max_date FROM film
    )
    INSERT INTO film (
        title, description, release_year, language_id, rental_duration, 
        rental_rate, length, replacement_cost, rating, last_update, 
        special_features, fulltext
    )
    SELECT 
        'Zorro Ark'
        ,'A Intrepid Panorama of a Mad Scientist And a Boy who must Redeem a Boy in A Monastery' 
        ,2006
        ,1 
        ,3
        ,4.99 
        ,50
        ,18.99
        ,'NC-17'
        ,current_ts
        ,'{Trailers,Commentaries,"Behind the Scenes"}' 
        ,'''ark'':2 ''boy'':12,17 ''intrepid'':4 ''mad'':8 ''monasteri'':20 ''must'':14 ''panorama'':5 ''redeem'':15 ''scientist'':9 ''zorro'':1'
    WHERE 
        current_ts > (SELECT max_date FROM cte);
END $$;

 -- insert into the film table if the current timestamp is greater than the max last_update timestamp in the film table
INSERT INTO film (
    title, description, release_year, language_id, rental_duration, 
    rental_rate, length, replacement_cost, rating, last_update, 
    special_features, fulltext
)
SELECT 
    'Zorro Ark 2'
    ,'A Intrepid Panorama of a Mad Scientist And a Boy who must Redeem a Boy in A Monastery' 
    ,2006
    ,1 
    ,3
    ,4.99 
    ,50
    ,18.99
    ,'NC-17'
	,'2014-05-26 14:50:58.951'
--    , current_timestamp
    ,'{Trailers,Commentaries,"Behind the Scenes"}' 
    ,'''ark'':2 ''boy'':12,17 ''intrepid'':4 ''mad'':8 ''monasteri'':20 ''must'':14 ''panorama'':5 ''redeem'':15 ''scientist'':9 ''zorro'':1'
WHERE 
    current_timestamp  > (SELECT MAX(last_update) FROM film);