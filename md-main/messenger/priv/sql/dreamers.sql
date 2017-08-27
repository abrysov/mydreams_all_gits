-- Set online
-- :set_online
UPDATE dreamers
   SET online=TRUE, updated_at=now(), last_reload_at=now()
 WHERE id=$1
   AND online IS NOT TRUE;

-- Set offline
-- :set_offline
UPDATE dreamers
   SET online=FALSE, updated_at=now(), last_reload_at=now()
 WHERE id=$1
   AND online IS TRUE
