-- Get messages of conversation
-- :collection
SELECT c.id, c.body, c.dreamer_id,
d.avatar_new, d.first_name || ' ' || d.last_name AS from,
date_part('year', age(d.birthday)) AS dreamer_age
FROM comments c
LEFT JOIN dreamers d ON d.id = c.dreamer_id
WHERE commentable_type = $1
AND commentable_id = $2
AND c.id > $3
ORDER BY c.id DESC LIMIT $4

-- Get message by id
-- :find
SELECT c.id, c.body, c.dreamer_id,
d.avatar_new, d.first_name || ' ' || d.last_name AS from,
date_part('year', age(d.birthday)) AS dreamer_age
FROM comments c
LEFT JOIN dreamers d ON d.id = c.dreamer_id
WHERE c.id = $1

-- Store message
-- :store
INSERT INTO comments (
  commentable_id, commentable_type,
  dreamer_id, body,
  created_at, updated_at
)
VALUES (
  $2, $1, $3, $4,
  now(), now()
)
RETURNING id
