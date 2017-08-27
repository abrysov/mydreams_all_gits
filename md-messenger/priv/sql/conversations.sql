-- Find conversation
-- :find
SELECT * FROM conversations WHERE id = $1

-- Check user belonging to conversation
-- :belongs
SELECT $1 = ANY(member_ids) AS result FROM conversations WHERE id = $2
