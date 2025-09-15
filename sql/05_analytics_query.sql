-- 1. Average rating per genre (with movie count)

WITH movie_genre_ratings AS(
    SELECT g.name AS genre,
           r.average_rating,
    FROM genre genre
    JOIN movie_genre mg ON mg.genre_id = g.genre_id
    JOIN rating r ON r.movie_id = mg.movie_id
)
SELECT genre,
       ROUND (AVG(average_rating)::numeric, 2) AS avg_rating,
       COUNT(*) AS movie_count
FROM movie_genre_ratings
GROUP BY genre
ORDER BY average_rating DESC, movie_count DESC;

-- 2. Top actors by movie count (top 10)

WITH actors AS(
    SELECT p.primary_name AS actor_name,
           COUNT (DISTINCT mpr.movie_id) AS movie_count
    FROM movie_person_role_mpr
    JOIN role r ON r.role_id = mpr.role_id AND r.role_name = 'actor'
    JOIN person p ON p.person_id = mpr.person_id
    GROUP BY p.primary_name
)
SELECT actor_name, movie_count
FROM actors
ORDER BY movie_count DESC, actor_name
LIMIT 10;

-- 3. Year-over year production count with growth rate

WITH prod AS(
     SELECT M.start_year AS year,
            COUNT(*) AS movie_count
     FROM movie M
     GROUP BY m.start_year
),
prod_with_growth AS (
    SELECT year,
           movie_count,
           LAG(movie_count) OVER (ORDER BY year) AS prev_count,
           CASE WHEN LAG(movie_count) OVER (ORDER BY year) IS NULL OR LAG(movie_count)
OVER (ORDER BY year) = 0
               THEN NULL
                  ELSE ROUND(((movie_count - LAG(movie_count) OVER (ORDER BY year))::numeric / NULLIF(LAG(movie_count) OVER (ORDER BY year),0)) * 100, 2)
           END AS yoy_growth_pct
    FROM prod
)
SELECT *
FROM prod_with_growth
ORDER BY year
