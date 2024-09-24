--I have 1 table, `employee_group` table. Find out a table group of each consecutive 2 employees in a same group and show each gorup's 2 member in same row with `{id1}{name1},{id2}{name2}` 
--
--Given sampe input table:
--+-----+-----------+
--|	id	|	name	|
--+-----+-----------+
--| 1	|	emp1	|
--| 2	|	emp2	|
--|	3	|	emp3	|
--|	4	|	emp4	|
--|	5	|	emp5	|
--|	6	|	emp6	|
--|	7	|	emp7	|
--|	8	|	emp8	|
--|	9	|	emp9	|
--+-----+-----------+
	
-- sample output:
--+---------------------+
--|		output			|
--+---------------------+
--|		1emp1,2emp2		|
--|		3emp3,4emp4		|
--|		5emp5,6emp6		|
--|		7emp7,8emp8		|
--|		9emp9,null		|
--+---------------------+

--create table public.employee_group(
--	id int
--	, name varchar(20)
--);

select * from public.employee_group eg;


--insert into public.employee_group 
--(id, "name")
--values
--(1,		'emp1')
--,(2,	'emp2')
--,(3,	'emp3')
--,(4,	'emp4')
--,(5,	'emp5')
--,(6,	'emp6')
--,(7,	'emp7')
--,(8,	'emp8')
--,(9,	'emp9')
--;


with next1 as(
	select
		*
		, lead(id, 1) over() as next_id
		, lead(name, 1) over() as next_name
		, rank() over(order by id) rnk
	from
		employee_group eg
)
select
	rnk
	, concat(id, name, ',', next_id, next_name) as output
from
	next1
where 
	mod(rnk,2) = 1
;