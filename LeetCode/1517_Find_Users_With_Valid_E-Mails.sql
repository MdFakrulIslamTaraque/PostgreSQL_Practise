-- https://leetcode.com/problems/find-users-with-valid-e-mails/description/?envType=study-plan-v2&envId=top-sql-50

-- Table: Users

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | user_id       | int     |
-- | name          | varchar |
-- | mail          | varchar |
-- +---------------+---------+
-- user_id is the primary key (column with unique values) for this table.
-- This table contains information of the users signed up in a website. Some e-mails are invalid.
 

-- Write a solution to find the users who have valid emails.

-- A valid e-mail has a prefix name and a domain where:

-- The prefix name is a string that may contain letters (upper or lower case), digits, underscore '_', period '.', and/or dash '-'. The prefix name must start with a letter.
-- The domain is '@leetcode.com'.
-- Return the result table in any order.

-- The result format is in the following example.

 

-- Example 1:

-- Input: 
-- Users table:
-- +---------+-----------+-------------------------+
-- | user_id | name      | mail                    |
-- +---------+-----------+-------------------------+
-- | 1       | Winston   | winston@leetcode.com    |
-- | 2       | Jonathan  | jonathanisgreat         |
-- | 3       | Annabelle | bella-@leetcode.com     |
-- | 4       | Sally     | sally.come@leetcode.com |
-- | 5       | Marwan    | quarz#2020@leetcode.com |
-- | 6       | David     | david69@gmail.com       |
-- | 7       | Shapiro   | .shapo@leetcode.com     |
-- +---------+-----------+-------------------------+
-- Output: 
-- +---------+-----------+-------------------------+
-- | user_id | name      | mail                    |
-- +---------+-----------+-------------------------+
-- | 1       | Winston   | winston@leetcode.com    |
-- | 3       | Annabelle | bella-@leetcode.com     |
-- | 4       | Sally     | sally.come@leetcode.com |
-- +---------+-----------+-------------------------+
-- Explanation: 
-- The mail of user 2 does not have a domain.
-- The mail of user 5 has the # sign which is not allowed.
-- The mail of user 6 does not have the leetcode domain.
-- The mail of user 7 starts with a period.

--------------------------------------------------- postgresql query -------------------------------------------
select
    *
from
    Users
where
    1=1
    and split_part(mail, '@', 2) like 'leetcode.com'
    and substring(split_part(mail, '@', 1) from 1 for 1) ~ '[a-zA-Z]'    -- means that the string should start with a letter 
    and substring(split_part(mail, '@', 1) from 2) ~ '^[a-zA-Z0-9_.-]*$' -- means that the string should contain only letters, digits, underscore '_', period '.', and/or dash '-' or nothing

-- The split_part() function is used to split the mail into two parts using the '@' symbol. The first part is the prefix name and the second part is the domain.
-- The first part is then checked to see if it starts with a letter using the regular expression '[a-zA-Z]'.
-- The second part is then checked to see if it contains only letters, digits, underscore '_', period '.', and/or dash '-' using the regular expression '^[a-zA-Z0-9_.-]*$'.

