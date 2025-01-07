-- sample input:
-- | filename | contents |
-- | --- | --- |
-- | draft1.txt | The stock exchange predicts a bull market which would make many investors happy. |
-- | draft2.txt | The stock exchange predicts a bull market which would make many investors happy, but analysts warn of possibility of too much optimism and that in fact we are awaiting a bear market. |
-- | final.txt | The stock exchange predicts a bull market which would make many investors happy, but analysts warn of possibility of too much optimism and that in fact we are awaiting a bear market. As always predicting the future market is an uncertain game and all investors should follow their instincts and best practices. |

-- sample output:
-- | word | nentry |
-- | --- | --- |
-- a	3
-- market	3
-- bull	2
-- exchange	2
-- happy	2
-- investors	2
-- make	2
-- many	2
-- of	2
-- predicts	2
-- stock	2
-- The	2
-- which	2
-- would	2
-- analysts	1
-- and	1
-- are	1
-- awaiting	1
-- bear	1
-- but	1
-- fact	1
-- in	1
-- much	1
-- optimism	1
-- possibility	1
-- that	1
-- too	1
-- warn	1
-- we	1

-- requirements: Find the number of times each word appears in drafts.
-- Output the word along with the corresponding number of occurrences.



------------------------------------------------- regexp_split_to_table() in select block + replace(), trim() ------------------------------
with agg_str as(
	select
		regexp_split_to_table(replace(replace(trim(contents), ',', ''), '.', ''), '\s') as WORD
	from
		file_contents
	where
		file_name like '%draft%'
)
select
	WORD
	, count(WORD)
from
	agg_str
group by
	WORD
having
	length(WORD) > 0
order by 
	2 desc, 1
	;

------------------------------------------------- string_to_table() in from block + translate() ------------------------------
with cte as (
	select 
		translate(word, '.,', '') as word
	from 
		file_contents
		, string_to_table(contents, ' ') as word
	where 1=1
		and file_name <> 'final.txt'
)
select 
	word 
	, count(1) as n_count
from 
	cte
where 1=1
	and length(word) > 0
group by 1
;




------------------------------------------------- string_to_table() in select block + translate() ------------------------------
with cte as(
	select 
		translate(string_to_table(contents, ' '), '.,', '') as word
	from 
		file_contents
	where 1=1
		and file_name <> 'final.txt'
)
select 
	word 
	, count(1) as n_count
from 
	cte
where 1=1
	and length(word) > 0
group by 1
order by 2 desc, 1
;
