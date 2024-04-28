-- https://leetcode.com/problems/triangle-judgement/description/?envType=study-plan-v2&envId=top-sql-50

"""
Table: Triangle

+-------------+------+
| Column Name | Type |
+-------------+------+
| x           | int  |
| y           | int  |
| z           | int  |
+-------------+------+
In SQL, (x, y, z) is the primary key column for this table.
Each row of this table contains the lengths of three line segments.
 

Report for every three line segments whether they can form a triangle.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Triangle table:
+----+----+----+
| x  | y  | z  |
+----+----+----+
| 13 | 15 | 30 |
| 10 | 20 | 15 |
+----+----+----+
Output: 
+----+----+----+----------+
| x  | y  | z  | triangle |
+----+----+----+----------+
| 13 | 15 | 30 | No       |
| 10 | 20 | 15 | Yes      |
+----+----+----+----------+
"""

--------------------------- pgsql -------------------------------------
with sorted_val as(
    SELECT
        x
        , y
        , z
        , LEAST(x, y, z) AS min_value
        , GREATEST(LEAST(x, y), LEAST(x, z), LEAST(y, z)) AS second_min_value
        , GREATEST(x,y,z) as max_value
    FROM Triangle
)
select
    tr.x
    , tr.y
    , tr.z
    , case when sv.min_value + sv.second_min_value > sv.max_value then 'Yes' else 'No' end as  triangle
from
    Triangle tr join sorted_val sv on tr.x = sv.x and tr.y = sv.y and tr.z = sv.z
