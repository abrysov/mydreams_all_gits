-- psql -d mydreams -U mydreams
CREATE TABLE IF NOT EXISTS dreamers(
  id serial PRIMARY KEY,
  first_name varchar,
  last_name varchar,
  birthday date,
  avatar_new varchar
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

CREATE TABLE IF NOT EXISTS comments(
  id serial PRIMARY KEY,
  commentable_id integer,
  commentable_type varchar,
  dreamer_id integer,
  body text,
  created_at timestamp,
  updated_at timestamp
);

INSERT INTO dreamers (first_name, last_name, birthday) VALUES
  ('Andrew', 'Kumanyaev', '1989-04-02'),
  ('Alex', 'Klyanchin', '1986-04-02');

INSERT INTO conversations (member_ids) VALUES ('{1, 2, 3}');
