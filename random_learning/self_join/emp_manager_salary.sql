-- Find employees who are earning more than their managers. Output the employee's first name along with the corresponding salary.

-- sample input: file
-- output: 
-- | employee_name | employee_salary |
-- | --- | --- |
-- | Richerd | 250000 |


-- subquery
explain analyze
select
	first_name
	, salary
from
	emp_manager_salary ems
where
	salary > (
		select
			salary
		from
			emp_manager_salary ems2
		where
			ems2.id = ems.manager_id
	)
;

-- cte + cartesian join
explain analyze
with emp_sal as(
	select
		id
		, salary
	from
		emp_manager_salary
)
select
	first_name
	, ems.salary
from
	emp_manager_salary ems
	, emp_sal
where
	emp_sal.id = ems.manager_id
 	and ems.salary > emp_sal.salary
 ;


-- self join
explain analyze
select 
	e1.id
	, e1.salary
	, e1.first_name
from 
	emp_manager_salary as e1
left join emp_manager_salary as e2 on e1.manager_id = e2.id 
where 1=1
	and e1.salary > e2.salary
;
	
	
	
	
	
	