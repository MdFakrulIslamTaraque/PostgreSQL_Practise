-- https://leetcode.com/problems/delete-duplicate-emails/description/?envType=study-plan-v2&envId=top-sql-50

-- Table: Person

-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | id          | int     |
-- | email       | varchar |
-- +-------------+---------+
-- id is the primary key (column with unique values) for this table.
-- Each row of this table contains an email. The emails will not contain uppercase letters.
 

-- Write a solution to delete all duplicate emails, keeping only one unique email with the smallest id.

-- For SQL users, please note that you are supposed to write a DELETE statement and not a SELECT one.

-- For Pandas users, please note that you are supposed to modify Person in place.

-- After running your script, the answer shown is the Person table. The driver will first compile and run your piece of code and then show the Person table. The final order of the Person table does not matter.

-- The result format is in the following example.

 

-- Example 1:

-- Input: 
-- Person table:
-- +----+------------------+
-- | id | email            |
-- +----+------------------+
-- | 1  | john@example.com |
-- | 2  | bob@example.com  |
-- | 3  | john@example.com |
-- +----+------------------+
-- Output: 
-- +----+------------------+
-- | id | email            |
-- +----+------------------+
-- | 1  | john@example.com |
-- | 2  | bob@example.com  |
-- +----+------------------+
-- Explanation: john@example.com is repeated two times. We keep the row with the smallest Id = 1.

-------------------------------------- PostgreSQL query ---------------------------------------
delete
from
    Person
where
    id
    not in
    (
        select
            min(id)
        from
            Person
        group by email
    )

-- The above query deletes all the rows from the Person table where the id is not the minimum id for the same email.
-- The subquery selects the minimum id for each email, and the outer query deletes all the rows where the id is not the minimum id for the email.