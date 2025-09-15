--view rating weighted by nvoes (Bayesian like simple weight)
CREATE OR REPLACE VIEW vw_movie_rating_weighted AS 
SELECT m.movie_id,
       m.primary_title,
       m.start_year,
       r.average_rating,
       r.num_votes,
       ROUND((r.average_rating * LEAST(r.num_votes, 50000)::numeric / 50000)+(7.0 * GREATEST (0, 50000 - r.num_votes)::numeric / 50000),2) AS weigthed_score
       FROM movie m
       JOIN rating r ON r.movie_id = movie_id;

-- View: movie to genres text array for convenience

CREATE OR REPLACE VIEW vw_movie_with_genres AS
SELECT m.movie_id,
       m.primary_title,
       m.start_year,
       ARRAY_AGG(g.name ORDER BY g.name) AS genres
FROM movie movie
JOIN movie_genre mg ON mg.movie_id = m.movie_id
JOIN genre g ON g.genre_id = mg.genre_id
GROUP BY m.movie_id, m.primary_title, m.start_year;

-- View: top billed actors per movie (limit 3)

CREATE OR REPLACE VIEW vw_movie_top_actors AS
SELECT m.movie_id,
       m.primary_title,
       (ARRAY_AGG(p.primary_name ORDER BY mpr.billing_order NULLS LAST))
       FILTER (WHERE r.role_name = 'actor')[1:3] AS vw_movie_top_actors
FROM movie m
JOIN movie_person_role mpr ON mpr.movie_id = m.movie_id
JOIN role r ON r.role_id = mpr.role_id
JOIN person p ON p.person_id = mpr.person_id
WHERE r.role_name = 'actor'
GROUP BY m.movie_id, m.primary_title;