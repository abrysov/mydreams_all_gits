-- Create reaction
-- :store
INSERT INTO reactions (
  reactable_id, reactable_type,
  dreamer_id, reaction,
  created_at, updated_at
)
VALUES (
  $1, $2, $3, $4, now(), now()
)
RETURNING id

-- :find
    SELECT r.id, r.reactable_id, r.reactable_type, r.reaction,
           d.first_name AS dreamer_first_name,
           d.last_name  AS dreamer_last_name
      FROM reactions r
INNER JOIN dreamers d
        ON d.id = r.dreamer_id
     WHERE r.id = $1

-- :for_comments
    SELECT r.id,
           r.reaction,
           r.reactable_id AS comment_id,
           d.first_name AS dreamer_first_name,
           d.last_name  AS dreamer_last_name
      FROM reactions r
INNER JOIN dreamers d
        ON d.id = r.dreamer_id
     WHERE r.reactable_type = $1
       AND r.reactable_id = ANY($2)
