-- https://leetcode.com/problems/customer-who-visited-but-did-not-make-any-transactions/description/?envType=study-plan-v2&envId=top-sql-50

-- Table: Visits

-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | visit_id    | int     |
-- | customer_id | int     |
-- +-------------+---------+
-- visit_id is the column with unique values for this table.
-- This table contains information about the customers who visited the mall.
 

-- Table: Transactions

-- +----------------+---------+
-- | Column Name    | Type    |
-- +----------------+---------+
-- | transaction_id | int     |
-- | visit_id       | int     |
-- | amount         | int     |
-- +----------------+---------+
-- transaction_id is column with unique values for this table.
-- This table contains information about the transactions made during the visit_id.
 

-- Write a solution to find the IDs of the users who visited without making any transactions and the number of times they made these types of visits.

-- Return the result table sorted in any order.

-- The result format is in the following example.

 

-- Example 1:

-- Input: 
-- Visits
-- +----------+-------------+
-- | visit_id | customer_id |
-- +----------+-------------+
-- | 1        | 23          |
-- | 2        | 9           |
-- | 4        | 30          |
-- | 5        | 54          |
-- | 6        | 96          |
-- | 7        | 54          |
-- | 8        | 54          |
-- +----------+-------------+
-- Transactions
-- +----------------+----------+--------+
-- | transaction_id | visit_id | amount |
-- +----------------+----------+--------+
-- | 2              | 5        | 310    |
-- | 3              | 5        | 300    |
-- | 9              | 5        | 200    |
-- | 12             | 1        | 910    |
-- | 13             | 2        | 970    |
-- +----------------+----------+--------+
-- Output: 
-- +-------------+----------------+
-- | customer_id | count_no_trans |
-- +-------------+----------------+
-- | 54          | 2              |
-- | 30          | 1              |
-- | 96          | 1              |
-- +-------------+----------------+
-- Explanation: 
-- Customer with id = 23 visited the mall once and made one transaction during the visit with id = 12.
-- Customer with id = 9 visited the mall once and made one transaction during the visit with id = 13.
-- Customer with id = 30 visited the mall once and did not make any transactions.
-- Customer with id = 54 visited the mall three times. During 2 visits they did not make any transactions, and during one visit they made 3 transactions.
-- Customer with id = 96 visited the mall once and did not make any transactions.
-- As we can see, users with IDs 30 and 96 visited the mall one time without making any transactions. Also, user 54 visited the mall twice and did not make any transactions.

-- PostgreSQL query

 -- create a table with transactions to find out the customers who made transactions
with with_tr as (                      
    select 
        vt.visit_id as visit_visit_id
        , tt.visit_id as trans_visit_id
        , tt.amount
        , vt.customer_id
    from Transactions as tt
    join Visits as vt on tt.visit_id = vt.visit_id
),
 -- create a table with no transactions to find out the customers who did not make transactions
      --here we are using left join to find out the customers 
      --who did not make any transactions by comparing the visit_id from Visits table with visit_visit_id from with_tr table
no_trx as (                            
    select                         
        vt.customer_id
        , vt.visit_id
    from Visits as vt
    left join with_tr as wt on wt.visit_visit_id = vt.visit_id
    where 1=1
        and vt.visit_id not in (select visit_visit_id from with_tr)
)
select                                  -- select the customer_id and count of visits where no transactions were made
    customer_id
    , count(visit_id) as count_no_trans
from no_trx
group by 1                              -- group by customer_id, the first column in the select statement, so here we group by 1
;
