--sample input:
---------------------------------------------------------
--user_firstname	user_lastname	video_id	flag_id
--Richard			Hasson			y6120QOlsfU	0cazx3
--Mark				May				Ct6BUPvE2sM	1cn76u
--Gina				Korman			dQw4w9WgXcQ	1i43zk
--Mark				May				Ct6BUPvE2sM	1n0vef
--Mark				May				jNQXAC9IVRw	1sv6ib
--Gina				Korman			dQw4w9WgXcQ	20xekb
--Mark				May				5qap5aO4i9A	4cvwuv
--Daniel			Bell			5qap5aO4i9A	4sd6dv
--Richard			Hasson			y6120QOlsfU	6jjkvn
--Pauline			Wilks			jNQXAC9IVRw	7ks264
--Courtney							dQw4w9WgXcQ	
--Helen				Hearn			dQw4w9WgXcQ	8946nx
--Mark				Johnson			y6120QOlsfU	8wwg0l
--Richard			Hasson			dQw4w9WgXcQ	arydfd
--Gina				Korman		
--Mark				Johnson			y6120QOlsfU	bl40qw
--Richard			Hasson			dQw4w9WgXcQ	ehn1pt
--Lopez								dQw4w9WgXcQ	hucyzx
--Greg								5qap5aO4i9A	
--Pauline			Wilks			jNQXAC9IVRw	i2l3oo
--Richard			Hasson			jNQXAC9IVRw	i6336w
--Johnson							y6120QOlsfU	iey5vi
--William			Kwan			y6120QOlsfU	kktiwe
--									Ct6BUPvE2sM	
--Loretta			Crutcher		y6120QOlsfU	nkjgku
--Pauline			Wilks			jNQXAC9IVRw	ov5gd8
--Mary				Thompson		Ct6BUPvE2sM	qa16ua
--Daniel			Bell			5qap5aO4i9A	xciyse
--Evelyn			Johnson			dQw4w9WgXcQ	xvhk6d
------------------------------------------------------------
--output:
-----------------------------
--video_id		num_unique_users
--5qap5aO4i9A	2
--Ct6BUPvE2sM	2
--dQw4w9WgXcQ	5
--jNQXAC9IVRw	3
--y6120QOlsfU	5
----------------------------
--For each video, find how many unique users flagged it. A unique user can be identified using the combination of their first name and last name. Do not consider rows in which there is no flag ID


create table public.user_video_flagging (
	user_first_name varchar(50)
	, user_last_name varchar(50)
	, video_id varchar(50)
	, flag_id varchar(50)
)


select * from public.user_video_flagging uvf;

--drop table public.unique_user_project_duration;


insert into public.user_video_flagging
(user_first_name, user_last_name, video_id, flag_id)
values
('Richard',	'Hasson', 'y6120QOlsfU',	'0cazx3'),
('Mark',	'May', 	'Ct6BUPvE2sM',	'1cn76u'),
('Gina',	'Korman',	'dQw4w9WgXcQ',	'1i43zk'),
('Mark',	'May',	'Ct6BUPvE2sM',	'1n0vef'),
('Mark',	'May',	'jNQXAC9IVRw',	'1sv6ib'),
('Gina',	'Korman',	'dQw4w9WgXcQ',	'20xekb'),
('Mark',	'May',	'5qap5aO4i9A',	'4cvwuv'),
('Daniel',	'Bell',	'5qap5aO4i9A',	'4sd6dv'),
('Richard', 'Hasson',	'y6120QOlsfU',	'6jjkvn'),
('Pauline', 'Wilks',	'jNQXAC9IVRw',	'7ks264'),
('Courtney', '',	'dQw4w9WgXcQ', ''),	
('Helen',	'Hearn',	'dQw4w9WgXcQ',	'8946nx'),
('Mark',	'Johnson',	'y6120QOlsfU',	'8wwg0l'),
('Richard',  'Hasson',	'dQw4w9WgXcQ',	'arydfd'),
('Gina',	'Korman', '', ''),		
('Mark',	'Johnson',	'y6120QOlsfU',	'bl40qw'),
('Richard',	'Hasson',	'dQw4w9WgXcQ',	'ehn1pt'),
('', 'Lopez',	'dQw4w9WgXcQ',	'hucyzx'),
('Greg', '',	'5qap5aO4i9A', ''),	
('Pauline',	'Wilks',	'jNQXAC9IVRw',	'i2l3oo'),
('Richard',	'Hasson',	'jNQXAC9IVRw',	'i6336w'),
('Johnson',	'', 'y6120QOlsfU',	'iey5vi'),
('William',	'Kwan', 'y6120QOlsfU',	'kktiwe'),
('', '', 'Ct6BUPvE2sM', ''),	
('Loretta',	'Crutcher',	'y6120QOlsfU',	'nkjgku'),
('Pauline',	'Wilks',	'jNQXAC9IVRw',	'ov5gd8'),
('Mary',	'Thompson',	'Ct6BUPvE2sM',	'qa16ua'),
('Daniel',	'Bell',	 '5qap5aO4i9A',	'xciyse'),
('Evelyn',	'Johnson',	'dQw4w9WgXcQ',	'xvhk6d')
;


---------------------------------- naive -------------------------------------------
with cte1 as(
	select 
		lower(concat(user_first_name, '|', user_last_name)) name
		, video_id
		, flag_id
	from
		public.user_video_flagging
	where 
		flag_id not like ''
)
select 
	video_id
	, count(distinct name)
from
	cte1
group by
	1
;

---------------------------------- optimized -------------------------------------------
select 
	video_id
	, count(distinct lower(concat(user_first_name, '|', user_last_name)))
from
	public.user_video_flagging
where 
	flag_id not like ''
group by
	1
;	






