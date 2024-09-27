--create table public.employee_dept_salaray(
--	id int
--	, dept varchar(50)
--	, salary int
--)


--insert into public.employee_dept_salaray (id, dept, salary)
--values
--(1, 'CSE', 14000)
--, (2, 'CSE', 10000)
--, (3, 'CSE', 8000)
--, (1, 'ME', 9000)
--, (2, 'ME', 11000)
--, (3, 'ME', 12000)
;

select * from public.employee_dept_salaray eds;


select
	id
	, dept
	, salary
	, min(salary) over(partition by dept) min_sal
	, max(salary) over(partition by dept) max_sal
	, first_value(salary) over(partition by dept) first_value
	, last_value(salary) over(partition by dept) last_value
	, nth_value(salary, 2) over(partition by dept order by salary desc) third_dept_sal
from
	public.employee_dept_salaray eds
;


select
	id
	, dept
	, salary
	, sum(salary) over(partition by dept order by id) dept_cum_sum
	, avg(salary) over(partition by dept order by id) dept_cum_avg
	, max(salary) over(partition by dept order by id) dept_running_max
from
	employee_dept_salaray eds
;
























