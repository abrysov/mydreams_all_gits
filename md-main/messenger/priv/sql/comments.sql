-- Get comments of resource
-- :collection
SELECT c.id, c.body, c.created_at,
       c.commentable_type AS resource_type,
         c.commentable_id AS resource_id,
                     d.id AS dreamer_id,
             d.avatar,
             d.first_name AS dreamer_first_name,
             d.last_name  AS dreamer_last_name,
             d.gender     AS dreamer_gender,
       date_part('year', age(d.birthday)) AS dreamer_age
     FROM comments c
LEFT JOIN dreamers d ON d.id = c.dreamer_id
    WHERE c.commentable_id = $1
      AND c.commentable_type = $2
      AND c.id > $3
 ORDER BY c.id
    LIMIT $4

-- Get comment by id
-- :find
SELECT c.id, c.body, c.created_at,
       c.commentable_type AS resource_type,
         c.commentable_id AS resource_id,
                     d.id AS dreamer_id,
             d.avatar,
             d.first_name AS dreamer_first_name,
             d.last_name  AS dreamer_last_name,
             d.gender     AS dreamer_gender,
       date_part('year', age(d.birthday)) AS dreamer_age
     FROM comments c
LEFT JOIN dreamers d ON d.id = c.dreamer_id
    WHERE c.id = $1

-- Comment resource
-- :comment_resource
SELECT commentable_type, commentable_id
  FROM comments
 WHERE id = $1

-- Store comment
-- :store
INSERT INTO comments (
  commentable_id, commentable_type,
  dreamer_id, body,
  created_at, updated_at
)
VALUES (
  $1, $2, $3, $4,
  now(), now()
)
RETURNING id

-- Update cache counter
-- :update_dreams_cache_counter
UPDATE dreams SET comments_count = COALESCE(comments_count, 0) + 1 WHERE id = $1

-- Update cache counter
-- :update_posts_cache_counter
UPDATE posts SET comments_count = COALESCE(comments_count, 0) + 1 WHERE id = $1
