--- drop table

DROP TABLE IF EXISTS rating CASCADE;
DROP TABLE IF EXISTS movie_genre CASCADE;
DROP TABLE IF EXISTS movie_person_role CASCADE;
DROP TABLE IF EXISTS movie CASCADE;
DROP TABLE IF EXISTS person CASCADE;
DROP TABLE IF EXISTS genre CASCADE;
DROP TABLE IF EXISTS role CASCADE;


--- Refrence tables

CREATE TABLE role(
    role_id SMALLSERIAL PRIMARY KEY,
    role_name TEXT NOT NULL UNIQUE CHECK (role_name IN ('actor', 'director', 'writer'))
);

CREATE TABLE genre (
    genre_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);

--- core entities

CREATE TABLE person(
    person_id BIGSERIAL PRIMARY KEY,
    primary_name TEXT NOT NULL,
    birth_year SMALLINT CHECK (birth_year BETWEEN 1850 AND EXTRACT(YEAR FROM CURRENT_DATE))
);

CREATE TABLE movie(
    movie_id BIGSERIAL PRIMARY KEY,
    primary_title TEXT NOT NULL,
    original_title TEXT,
    start_year SMALLINT CHECK (start_year BETWEEN 1888 AND EXTRACT (YEAR FROM CURRENT_DATE)),
    runtime_minutes INTEGER CHECK (runtime_minutes IS NULL OR runtime_minutes >0)
);


-- Relationships
CREATE TABLE movie_genre(
    movie_id BIGINT NOT NULL REFERENCES movie(movie_id) ON DELETE CASCADE,
    genre_id INT NOT NULL REFERENCES genre(genre_id) ON DELETE RESTRICT,
    PRIMARY KEY(movie_id, genre_id)
);


CREATE TABLE movie_person_role(
    movie_id BIGINT NOT NULL REFERENCES movie(movie_id) ON DELETE CASCADE,
    person_id BIGINT NOT NULL REFERENCES person(person_id) ON DELETE CASCADE,
    role_id SMALLINT NOT NULL REFERENCES role(role_id) ON DELETE RESTRICT,
    billing_order INT,
    PRIMARY KEY (movie_id, person_id, role_id)
);

CREATE TABLE rating(
    movie_id BIGINT PRIMARY KEY REFERENCES movie(movie_id) ON DELETE CASCADE,
    average_rating NUMERIC(3,1) NOT NULL CHECK(average_rating BETWEEN 0 AND 10),
    num_votes INTEGER NOT NULL CHECK (num_votes >= 0)
);

-- Helpul domain constrains

ALTER TABLE movie
   ADD CONSTRAINT title_not_empty CHECK(btrim(primary_title)<> '');

ALTER TABLE person
   ADD CONSTRAINT name_not_empty CHECK(btrim(primary_name) <> '');

   -- Basic seed for roles domain

INSERT INTO role(role_name)
VALUES ('actor'), ('director'), ('writer')
ON CONFLICT (role_name) DO NOTHING;
