--
-- :find
SELECT dreamer_id, initiator_id, resource_id, resource_type
  FROM feedbacks
 WHERE id = $1
