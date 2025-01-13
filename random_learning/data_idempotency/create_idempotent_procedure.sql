drop table financial_data_refined;


select * from financial_data_refined fdr;


create or replace procedure data_idempotency()
language plpgsql
as $$
begin

	-- create table if not exists
	create table IF NOT EXISTS financial_data_refined 
	as
	select 
		*
		, CURRENT_DATE as created_at 
	from
		financial_raw fr
	where 1 = 2
	;

	-- delete entries of the current_Date as created_at 
	-- Using `created_at` as unique Identifiers	
	delete from financial_data_refined 
	where created_at = CURRENT_DATE
	;

	-- Deduplication
	-- insert into the entries with the current_date again
	-- ensuring no duplicate entries for a single day
	insert into financial_data_refined
	select
		*
		, CURRENT_DATE as created_at
	from
		financial_raw
	;

end; $$


call data_idempotency();

update financial_data_refined 
set created_at = CURRENT_DATE -1;
	




