-- Given a table: 
-- input:
----
--+---------+---------------+
--|	id	    |	name		|
--+---------+---------------+
--|	1   	|	Fakrul		|		
--| 2   	|	Rafael		|
--|	3   	|	Sadman		|
--|	4   	|	Talha		|
--|	5   	|	Bondhon		|
--+---------+---------------+
-- Find the pair of each entry, where every entry with odd id, will have pair with the immediate next entry
-- and for even entry, the pair will be the immediate previous one
-- if the last entry is with odd id, then then it will pair with itself

-- output table:
-------+----------------+-----------+
--| id |    name        |    pair   |
--+----+----------------+-----------+
--| 1  |	Fakrul      |   Rafayel |
--| 2  |    Rafayel	    |   Fakrul  |
--| 3  |	Sadman	    |   Talha   |
--| 4  |	Talha	    |   Sadman  |
--| 5  |	Bondhon	    |   Bondhon |
--+----+----------------+-----------+



create table public.pair_finding
(
	id int
	, name varchar(40)
);

select * from public.pair_finding pf;

delete from public.pair_finding where id = 6;

insert into public.pair_finding (id, name)
values
(6, 'Jaki')
--, (2, 'Rafayel')
--, (3, 'Sadman')
--, (4, 'Talha')
--, (5, 'Bondhon')
;

with cte as(
	select id from public.pair_finding
)
select 
	pf.id
	, name
	, case
		when (mod(cte.id,2) = 1) then coalesce( (lead(name,1) over()), name)
		when (mod(cte.id,2) = 0) then coalesce( (lag(name,1) over()), name)
	end as "pair"
from 
	public.pair_finding pf
	join cte on cte.id = pf.id
;




