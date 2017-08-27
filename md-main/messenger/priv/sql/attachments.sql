-- Bind attachments to message
-- :bind_to_message
UPDATE attachments
   SET attachmentable_id = $1,
       attachmentable_type = 'Message',
       updated_at = now()
 WHERE id = ANY($2)
   AND attachmentable_id IS NULL
   AND attachmentable_type IS NULL

-- Find avatasrs collection
-- :collection
SELECT id, file_new AS file, created_at
  FROM attachments
 WHERE id = ANY($1)
   AND attachmentable_id = $2
   AND attachmentable_type = 'Message'
