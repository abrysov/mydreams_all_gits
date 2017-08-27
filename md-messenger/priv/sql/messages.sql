-- Get messages of conversation
-- :collection
SELECT m.id, m.conversation_id, m.sender_id, m.message AS text,
d.id AS dreamer_id, d.avatar_new,
d.first_name || ' ' || d.last_name AS from,
date_part('year', age(d.birthday)) AS dreamer_age
FROM messages m
LEFT JOIN dreamers d ON d.id = m.sender_id
WHERE conversation_id = $1
AND m.id > $2
ORDER BY m.id DESC LIMIT $3

-- Get message by id
-- :find
SELECT m.id, m.conversation_id, m.sender_id, m.message AS text,
d.id AS dreamer_id, d.avatar_new,
d.first_name || ' ' || d.last_name AS from,
date_part('year', age(d.birthday)) AS dreamer_age
FROM messages m
LEFT JOIN dreamers d ON d.id = m.sender_id
WHERE m.id = $1

-- Store message
-- :store
INSERT INTO messages (conversation_id, sender_id, message)
VALUES ($1, $2, $3)
RETURNING id

--
-- :viewed_ids_with_lock
SELECT viewed_ids FROM messages WHERE id = $1 FOR UPDATE

--
-- :update_viewed_ids
UPDATE messages SET viewed_ids = $1 WHERE id = $2
