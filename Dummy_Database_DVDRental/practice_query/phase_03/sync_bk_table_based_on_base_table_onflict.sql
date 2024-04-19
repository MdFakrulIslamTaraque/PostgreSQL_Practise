merge into film_bk as tgt 
using film as src
  on src.film_id = tgt.film_id
when matched then 
  update set
    	title = src.title, 
		description = src.description, 
		release_year = src.release_year, 
		language_id = src.language_id, 
	    rental_duration = src.rental_duration, 
	    rental_rate = src.rental_rate, 
	    length = src.length, 
	    replacement_cost = src.replacement_cost, 
	    rating = src.rating, 
	    last_update = src.last_update, 
	    special_features = src.special_features, 
	    fulltext = src.fulltext
when not matched then
  insert ( film_id, title, description, release_year, language_id, rental_duration, 
    rental_rate, length, replacement_cost, rating, last_update, 
    special_features, fulltext )
  values (
  src.film_id,
  		src.title, 
		src.description, 
		src.release_year, 
		src.language_id, 
	    src.rental_duration, 
	    src.rental_rate, 
	    src.length, 
	     src.replacement_cost, 
	     src.rating, 
	    src.last_update, 
	    src.special_features, 
	    src.fulltext
	    )
;