--I have 2 table, `src` and `target` with values like:
--
--`src`:
--+-----+-----------+
--| id  | name		|
--+-----+-----------+
--|	1	|	a		|
--|	2	|	b		|
--|	3	|	c		|
--|	4	|	c		|	
--+----+------------+
--
--`target`:
--+-----+-----------+
--| id  | name		|
--+-----+-----------+
--| 1 	|	a		|
--| 2	|	b		|
--|	4	|	x		|
--|	5	|	z		|
--+----+------------+
--
--the output query will be like:
--
--+----+--------------+
--| id | remarks      |
--+----+--------------+
--| 3  | new in src   |
--| 5  | new in target|
--| 4  | mismatch     |
--+----+--------------+

------------------------------------------------- DDL -----------------------------------------

create table public.src (
	id int
	, name varchar(20)
);

create table public.target (
	id int
	, name varchar(20)
);


insert into public.src
values (1, 'a'), (2,'b'), (3,'c'), (4, 'c')
;

insert into public.target 
values (1, 'a'), (2,'b'), (4,'x'), (5, 'z')
;


select * from public.src;

select * from public.target;



---------------------------------------------------- naive --------------------------------------
with get_src_new as (
	select
		sr.id new_src
	from
		public.src sr
		left join public.target tr on sr.id = tr.id 
	where
		tr.id is null
), get_tr_new as (
	select
		tr.id new_tr
	from
		public.src sr
		right join public.target tr on sr.id = tr.id 
	where
		sr.id is null
), get_joined_mismatch as (
	select
		sr.id mismatch
	from
		public.src sr
		join public.target tr on sr.id = tr.id 
	where
		lower(tr.name) not like lower(sr.name)
)
(
	select 
		new_src as id
		, 'new in src' as remarks 
	from 
		get_src_new
)
union all
(
	select 
		new_tr as id 
		, 'mitmatch' as remarks 
	from 
		get_tr_new
)
union all
(
	select 
		mismatch as id
		, 'new in target' as remarks 
	from 
		get_joined_mismatch
)
;

---------------------------------------------- optimized-1 --------------------------------
with cte as(
	select
		sr.id as src_id
		, sr.name as src_name
		, tr.id as tr_id
		, tr.name as tr_name
	from
		public.src sr
		full outer join public.target tr on sr.id = tr.id
)
, cte_final as(
	select
		case
			when tr_id is null then src_id
			when src_id is null then tr_id
			when src_id = tr_id and lower(src_name) not like lower(tr_name) then src_id
		end as id
		,
		case 
			when tr_id is null then 'new in src' 
			when src_id is null then 'new in targe' 
			when src_id = tr_id and lower(src_name) not like lower(tr_name) then 'mismatch' 
		end as remakrs
	from
		cte
)
select
	*
from
	cte_final
where
	id is not null
;

----------------------------------------------- optimized-2 --------------------------------
select coalesce (s.id, t.id) as id,
	case
		when s.id is null then 'new in target'
		when t.id is null then 'new in source'
		when s.name <> t.name then 'mismatch'
	end as remarks
from public.src s 
full outer join public.target t 
on s.id = t.id
where s.id is null or t.id is null or s.name <> t.name
;