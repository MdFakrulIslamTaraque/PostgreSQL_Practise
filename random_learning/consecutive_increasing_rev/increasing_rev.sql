--I have 1 table, `company_revenue` table. Find out the company whose revenue increases increamentally over the year range 2018-2020.
--
--Given sampe input table:
--+---------+---------------+-----------+
--|	Year	|	company		| revenue	|
--+---------+---------------+-----------+
--|	2018	|	Apple		|	75		|		
--| 2019	|	Apple		|	35		|
--|	2020	|	Apple		|	45		|
--|	2018	|	Samsung		|	15		|
--|	2019	|	Samsung		|	20		|
--|	2020	|	Samsung		|	25		|
--| 2018	|	Tesla		|	22		|
--|	2019	|	Tesla		|	25		|
--|	2020	|	Tesla		|	10		|
--+---------+---------------+-----------+
--
-- sample output:
--+-----------------+
--|		company		+
--+-----------------+
--|		Samsung		|
--+-----------------+



create table public.company_revenue (
	year year
	, company varchar(20)
	, revenue int
);


insert into public.company_revenue (year, company, revenue)
values 
  (2018, 'Apple', 75)
, (2019, 'Apple', 35)
, (2020, 'Apple', 45)
, (2021, 'Apple', 55)

, (2018, 'Samsung', 15)
, (2019, 'Samsung', 20)
, (2020, 'Samsung', 25)

, (2018, 'Tesla', 22)
, (2019, 'Tesla', 25)
, (2020, 'Tesla', 10)
;


select * from public.company_revenue;

--truncate table public.company_revenue;
--
--drop table public.company_revenue;
--delete from public.company_revenue where company = 'Apple' and year = '2021';


---------------------------------------------- solution (naive) --------------------------------
with company_entry_count as(
	select
		company
		, count(2) cnt 
	from
		public.company_revenue
	group by
		company
)
, cnt_rank_nxt_year_rev_raw as(
	select
		cr.year _year
		, cr.company
		, cr.revenue
		, coalesce((lead(cr.revenue, 1) over()), 0)	as next_yr_rev_diff
		, row_number() over(partition by cr.company) _rank
		, cec.cnt
	from
		public.company_revenue cr 
		join company_entry_count cec on lower(cr.company) = lower(cec.company)
)
, rev_furnished as(
	select
		crnyr._year
		, crnyr.company
		, crnyr.revenue
		, case 
			when crnyr._rank < crnyr.cnt then crnyr.next_yr_rev_diff
			else crnyr.revenue
		end as next_yr_rev
		, crnyr.cnt
		, crnyr._rank
	from
		cnt_rank_nxt_year_rev_raw crnyr
), rev_increased_flag as(
	select
		*
		, case 
			when next_yr_rev > revenue then 1
			else 0
		end as ref_increased
	from
		rev_furnished
	where
		_rank < cnt
)
select
	company
from
	rev_increased_flag
group by
	company, cnt
having
	SUM(ref_increased) = cnt - 1
;



-- -------------------------------------------------- solutioin (optimized) -----------------------------------------------------

with cte as (
	select 
		* 
		, case when revenue < lead(revenue, 1, revenue+1) over(partition by company order by year) then 1 else 0 end as rnk
	from public.company_revenue
)
select
	distinct company
from cte
where 1=1
	and company not in (select company from cte where rnk=0)
;