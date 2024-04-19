--- create table film_bk_skeleton without the data
create table film_bk_skeleton 
	as 
	select * from public.film
	where 1 = 2
	;

-- create table film_bk with the data
create table film_bk 
    as 
    select * from public.film
    ;
