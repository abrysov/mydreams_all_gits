-- psql -d mydreams -U mydreams
CREATE TABLE IF NOT EXISTS dreamers(
  id serial PRIMARY KEY,
  first_name varchar(40),
  last_name varchar(40)
);

CREATE TABLE IF NOT EXISTS conversations(
  id serial PRIMARY KEY,
  member_ids integer[] UNIQUE
);

CREATE TABLE IF NOT EXISTS messages(
  id serial PRIMARY KEY,
  conversation_id integer,
  sender_id integer,
  viewed_ids integer[],
  message text
);

INSERT INTO dreamers (first_name, last_name) VALUES
  ('Andrew', 'Kumanyaev'),
  ('Alex', 'Klyanchin');

INSERT INTO conversations (member_ids) VALUES ('{1, 2}');
