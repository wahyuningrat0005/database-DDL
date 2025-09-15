

--- core lookup indexes

CREATE INDEX IF NOT EXISTS idx_movie_start_year ON movie(start_year);
CREATE INDEX IF NOT EXISTS idx_movie_runtime ON movie(runtime_minutes);
CREATE INDEX IF NOT EXISTS idx_person_name ON person USING gin (to_tsvector('simple', primary_name));

CREATE INDEX IF NOT EXISTS idx_movie_genre_genre_id ON movie_genre(genre_id);
CREATE INDEX IF NOT EXISTS idx_movie_genre_movie_id ON movie_genre(movie_id);

CREATE INDEX IF NOT EXISTS idx_movie_person_role_person ON movie_person_role(person_id);
CREATE INDEX IF NOT EXISTS idx_movie_person_role_role ON movie_person_role(role_id);
CREATE INDEX IF NOT EXISTS idx_movie_person_role_movie ON movie_person_role(movie_id);

CREATE INDEX IF NOT EXISTS idx_rating_avg ON rating(average_rating DESC);
CREATE INDEX IF NOT EXISTS idx_rating_votes ON rating(num_votes DESC);

-- cONVERING EXAMPLE FOR FREQUEN JOIN + FILTER PATTERNS

CREATE INDEX IF NOT EXISTS idx_mpr_role_movie_person ON movie_person_role(role_id, movie_id, person_id);