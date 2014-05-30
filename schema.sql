CREATE table articles (
  id serial PRIMARY KEY,
  title varchar(1000) NOT NULL,
  url varchar(2000) NOT NULL,
  description varchar(10000) NOT NULL,
  created_at timestamp NOT NULL
);

INSERT INTO articles (
  title,
  url,
  description,
  created_at)

VALUES (
  'Learning by Thinking: How Reflection Aids Performance',
  'http://www.farnamstreetblog.com/2014/05/learning-by-thinking/',
  'An article about reflection.',
  NOW()
);
