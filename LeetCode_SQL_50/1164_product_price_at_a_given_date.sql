-- https://leetcode.com/problems/product-price-at-a-given-date/description/?envType=study-plan-v2&envId=top-sql-50
"""
Table: Products

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| product_id    | int     |
| new_price     | int     |
| change_date   | date    |
+---------------+---------+
(product_id, change_date) is the primary key (combination of columns with unique values) of this table.
Each row of this table indicates that the price of some product was changed to a new price at some date.
 

Write a solution to find the prices of all products on 2019-08-16. Assume the price of all products before any change is 10.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Products table:
+------------+-----------+-------------+
| product_id | new_price | change_date |
+------------+-----------+-------------+
| 1          | 20        | 2019-08-14  |
| 2          | 50        | 2019-08-14  |
| 1          | 30        | 2019-08-15  |
| 1          | 35        | 2019-08-16  |
| 2          | 65        | 2019-08-17  |
| 3          | 20        | 2019-08-18  |
+------------+-----------+-------------+
Output: 
+------------+-------+
| product_id | price |
+------------+-------+
| 2          | 50    |
| 1          | 35    |
| 3          | 10    |
+------------+-------+
"""
--------------------------------------------------- pgsql ----------------------------------------
with initial_price as(
    select
        distinct product_id
        , case when 1=1 then 10 end as price
    from
        Products
), on_date as(
    select
        *
        ,  RANK() OVER (partition by product_id ORDER BY change_date DESC) AS rank
    from
        Products
    where
        change_date <= '2019-08-16'
)
, changed_prince as(
    select
        product_id
        , new_price as price
    from
        on_date
    where
        rank = 1
    order by
        product_id
)
, not_changed as (
    select
        initial_price.product_id
        , initial_price.price
    from
       changed_prince 
       full outer join initial_price on initial_price.product_id = changed_prince.product_id
    where
        changed_prince.product_id is null or initial_price.product_id is null
)
(
    select
    *
    from
        not_changed
)
union
(
    select
        *
    from
        changed_prince
)