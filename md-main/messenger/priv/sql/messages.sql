-- Get messages of conversation
-- :initial_collection
SELECT m.id, m.conversation_id, m.message, m.created_at,
       (m.viewed_ids @> ARRAY[$1::integer]) as read,
       d.id AS dreamer_id,
       d.avatar,
       d.first_name AS dreamer_first_name,
       d.last_name  AS dreamer_last_name,
       d.gender     AS dreamer_gender,
       date_part('year', age(d.birthday)) AS dreamer_age
     FROM messages m
LEFT JOIN dreamers d ON d.id = m.sender_id
    WHERE conversation_id = $2
 ORDER BY m.id DESC
    LIMIT $3

-- Get prev messages of conversation
-- :previous_collection
SELECT m.id, m.conversation_id, m.message, m.created_at,
       (m.viewed_ids @> ARRAY[$1::integer]) as read,
       d.id AS dreamer_id,
       d.avatar,
       d.first_name AS dreamer_first_name,
       d.last_name  AS dreamer_last_name,
       d.gender     AS dreamer_gender,
       date_part('year', age(d.birthday)) AS dreamer_age
     FROM messages m
LEFT JOIN dreamers d ON d.id = m.sender_id
    WHERE conversation_id = $2
      AND m.id < $3
 ORDER BY m.id DESC
    LIMIT $4

-- Get message by id
-- witchcraft for 'read' field
-- :find
SELECT m.id, m.conversation_id, m.sender_id, m.message, m.created_at,
       false as read,
       d.id AS dreamer_id,
       d.avatar,
       d.first_name AS dreamer_first_name,
       d.last_name  AS dreamer_last_name,
       d.gender     AS dreamer_gender,
       date_part('year', age(d.birthday)) AS dreamer_age
     FROM messages m
LEFT JOIN dreamers d ON d.id = m.sender_id
    WHERE m.id = $1

-- Store message
-- :store
INSERT INTO messages (conversation_id, sender_id, message, viewed_ids, created_at, updated_at)
VALUES ($1, $2, $3, ARRAY[$2::integer], now(), now())
RETURNING id

--
-- :viewed_ids_with_lock
SELECT viewed_ids FROM messages WHERE id = $1 FOR UPDATE

--
-- :update_viewed_ids
UPDATE messages SET viewed_ids = viewed_ids || $1::integer WHERE id = $2 AND (NOT viewed_ids @> ARRAY[$1::integer])
