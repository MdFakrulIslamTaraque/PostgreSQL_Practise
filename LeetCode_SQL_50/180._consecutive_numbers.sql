-- https://leetcode.com/problems/consecutive-numbers/description/?envType=study-plan-v2&envId=top-sql-50
"""
Table: Logs

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| num         | varchar |
+-------------+---------+
In SQL, id is the primary key for this table.
id is an autoincrement column.
 

Find all numbers that appear at least three times consecutively.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Logs table:
+----+-----+
| id | num |
+----+-----+
| 1  | 1   |
| 2  | 1   |
| 3  | 1   |
| 4  | 2   |
| 5  | 1   |
| 6  | 2   |
| 7  | 2   |
+----+-----+
Output: 
+-----------------+
| ConsecutiveNums |
+-----------------+
| 1               |
+-----------------+
Explanation: 1 is the only number that appears consecutively for at least three times.
"""

----------------------------------------- pgsql --------------------------------
with cte as(
    select
        id
        , num
        , lag(num) over(order by id) as prev_num
        , lead(num) over(order by id) as next_num
        , lag(id) over(order by id) as prev_id
        , lead(id) over(order by id) as next_id
    from
        Logs
)
, cte2 as(
    select
        num
        ,count(case when cte.num = cte.prev_num and cte.num = cte.next_num and cte.id+1 = cte.next_id and cte.id-1 = cte.prev_id then 1 end) cnt
    from
        cte
    group by
        num
    having
        count(case when cte.num = cte.prev_num and cte.num = cte.next_num then 1 end) > 0
)
select
    num as ConsecutiveNums
from
    cte2
where
    cnt > 0
;
