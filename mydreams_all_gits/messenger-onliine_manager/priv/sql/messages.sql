-- Get last N messages of conversation
-- :last_messages
SELECT m.id, m.conversation_id, m.sender_id, m.viewed_ids, m.message AS text,
d.first_name || ' ' || d.last_name AS from
FROM messages m
LEFT JOIN dreamers d ON d.id = m.sender_id
WHERE conversation_id = $1 ORDER BY m.id DESC LIMIT $2

-- Get message by id
-- :find_message
SELECT m.id, m.conversation_id, m.sender_id, m.viewed_ids, m.message AS text,
d.first_name || ' ' || d.last_name AS from
FROM messages m
LEFT JOIN dreamers d ON d.id = m.sender_id
WHERE m.id=$1

-- Store message
-- :store_message
INSERT INTO messages (conversation_id, sender_id, message)
VALUES ($1, $2, $3)
RETURNING id

--
-- :viewed_ids_with_lock
SELECT viewed_ids FROM messages WHERE id = $1 FOR UPDATE

--
-- :update_viewed_ids
UPDATE messages SET viewed_ids = $1 WHERE id = $2
