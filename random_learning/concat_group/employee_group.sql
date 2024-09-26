-- I have 1 table, `employee_group` table. The output table will be of 4 rows(4 group) max, where each row will be of equal members, if not possible, 
-- then, uneven members will be distibuted to the groups from group 1 equally
-- each consecutive 2 employees in a same group and show each gorup's 2 member in same 
-- e.g, if there are 10 members, then in 4 consecutive group, there will be 3,3,2,2 members
-- row with `{id1}{name1},{id2}{name2},{id3}{name3}.....` 
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
--+-------------------------+
--|		output				|
--+-------------------------+
--|		1emp1,2emp2,3emp3	|
--|		4emp4,5emp5			|
--|		6emp6,7emp7			|
--|		8emp8,9emp9			|
--+-------------------------+
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


with cte as (
select
	concat(cast(id as text),',',"name") as emp
	, ntile(4) over(order by id) as grp
from
	employee_group
)
select
	grp
	, string_agg(emp,',') as emp
from
	cte
group by 
	1
order by 
	1
;
