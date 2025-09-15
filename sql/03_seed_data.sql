INSERT INTO genre(name) VALUES

 ('Action'),
 ('Drama'),
 ('KOmedi'),
 ('Sci-fi'),
 ('Adventure')
 ON CONFLICT (name) DO NOTHING;


 --PEOPLE

 INSERT INTO person (primary_name, birth_year) VALUES
  
    ('Robert Downy Jr', 1965),
    ('Scarlett Johanson', 1985),
    ('Chris Evans', 1981),
    ('Christopher Nolan', 1970),
    ('Quentin Tarantino', 1963),
    ('Leonardo DiCaprio', 1974),
    ('Margot Robbie', 1990),
    ('Keanu Reeves', 1964),
    ('Carrie-Anne Moss', 1967),
    ('Lana Wachowski', 1965),
    ('Lilly Wachowski', 1967)
ON CONFLICT DO NOTHING;

--Movies

INSERT INTO movie (primary_title, original_title, start_year, runtime_minutes) VALUES
    ('iron Man', 'Iron Man', 2008, 126),
    ('The Avengers', 'The Avengers', 2012, 143),
    ('Avengers: Endgame', 'Avengers: Endgame', 2019, 181),
    ('Inception', 'Inception', 2010, 148),
    ('Once Upon a Time in Hollywood', 'Once Upon a Time in Hollywood', 2019, 161),
    ('The Matrix', 'The Matrix', 1999, 136)
ON CONFLICT DO NOTHING;

-- Bridge : movie_genre
INSERT INTO movie_genre (movie_id, genre_id) SELECT m.movie_id, g.genre_id FROM movie m JOIN genre g ON (m.primary_title, g.name) IN(
    (('Iron Man'),('Action')),
    (('Iron Man'), ('Sci-Fi')),
    (('The Avengers'), ('Action')),
    (('The Avengers'), ('Adventure')),
    (('Avengers: Endgame'), ('Action')),
    (('Avengers: Endgame'), ('Adventure')),
    (('Inception'), ('Sci-Fi')),
    (('Inception'), ('Action')),
    (('Once Upon a Time in Hollywood'), ('Drama')),
    (('Once Upon a Time in Hollywood'), ('Comedy')),
    (('The Matrix'), ('Sci-Fi')),
    (('The Matrix'), ('Action'))(('Iron Man'), ('Sci-Fi')),
    (('The Avengers'), ('Action')),
    (('The Avengers'), ('Adventure')),
    (('Avengers: Endgame'), ('Action')),
    (('Avengers: Endgame'), ('Adventure')),
    (('Inception'), ('Sci-Fi')),
    (('Inception'), ('Action')),
    (('Once Upon a Time in Hollywood'), ('Drama')),
    (('Once Upon a Time in Hollywood'), ('Comedy')),
    (('The Matrix'), ('Sci-Fi')),
    (('The Matrix'), ('Action'))
);

--Ratings

INSERT INTO rating (movie_id, average_rating, num_votes)
SELECT movie_id,
       CASE primary_title
            WHEN 'Iron Man' THEN 7.9
            WHEN 'The Avengers' THEN 8.0
            WHEN 'Avengers: Endgame' THEN 8.4
            WHEN 'Inception' THEN 8.8
            WHEN 'Once Upon a Time in Hollywood' THEN 7.6
            WHEN 'The Matrix' THEN 8.7
        END AS average_rating,
        CASE primary_title
            WHEN 'Iron Man' THEN 1050000
            WHEN 'The Avengers' THEN 1400000
            WHEN 'Avengers: Endgame' THEN 1200000
            WHEN 'Inception' THEN 2500000
            WHEN 'Once Upon a Time in Hollywood' THEN 800000
            WHEN 'The Matrix' THEN 2000000
        END AS num_votes
FROM movie 
ON CONFLICT (movie_id) DO NOTHING;

-- Roles helper
WITH x AS (SELECT role_id, role_name FROM role)

-- Credits (movie_person_role)

INSERT INTO movie_person_role(movie_id, person_id, role_id, billing_id)
SELECT m.movie_id, p.person_id,
       (SELECT role_id FROM role WHERE role_name = rname) AS role_id, b_order
FROM(
    VALUES
    -- Iron Man
    ('Iron Man', 'Robert Downey Jr.', 'actor', 1),
    ('Iron Man', 'Scarlett Johansson', 'actor', 2),
    -- The Avengers
    ('The Avengers', 'Robert Downey Jr.', 'actor', 1),
    ('The Avengers', 'Scarlett Johansson', 'actor', 2),
    ('The Avengers', 'Chris Evans', 'actor', 3),
    -- Endgame
    ('Avengers: Endgame', 'Robert Downey Jr.', 'actor', 1),
    ('Avengers: Endgame', 'Scarlett Johansson', 'actor', 2),
    ('Avengers: Endgame', 'Chris Evans', 'actor', 3),
    -- Inception
    ('Inception', 'Leonardo DiCaprio', 'actor', 1),
    -- OUATIH
    ('Once Upon a Time in Hollywood', 'Leonardo DiCaprio', 'actor', 1),
    ('Once Upon a Time in Hollywood', 'Margot Robbie', 'actor', 2),
    -- The Matrix
    ('The Matrix', 'Keanu Reeves', 'actor', 1),
    ('The Matrix', 'Carrie-Anne Moss', 'actor', 2),
    -- Directors
    ('Inception', 'Christopher Nolan', 'director', NULL),
    ('Once Upon a Time in Hollywood', 'Quentin Tarantino', 'director', NULL),
    ('The Matrix', 'Lana Wachowski', 'director', NULL),
    ('The Matrix', 'Lilly Wachowski', 'director', NULL)
) AS credits(title, name, rnmae, b_order)
JOIN movie m ON m.primary_title = credits.title,
JOIN person p ON m.primary_name = credits.name,
ON CONFLICT DO NOTHING
