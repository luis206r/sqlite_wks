-- CREATE TABLE movies (
--   id INTEGER PRIMARY KEY,
--   name TEXT DEFAULT NULL,
--   year INTEGER DEFAULT NULL,
--   rank REAL DEFAULT NULL
-- );

-- CREATE TABLE actors (
--   id INTEGER PRIMARY KEY,
--   first_name TEXT DEFAULT NULL,
--   last_name TEXT DEFAULT NULL,
--   gender TEXT DEFAULT NULL
-- );

-- CREATE TABLE roles (
--   actor_id INTEGER,
--   movie_id INTEGER,
--   role_name TEXT DEFAULT NULL
-- );

--Año de nacimiento
SELECT name, year FROM movies WHERE year = 2001;

--1982
SELECT COUNT(*) FROM movies WHERE year = 1982;

--Stacktors
SELECT * FROM actors WHERE last_name LIKE "%Stack%";

--10 nombres mas populares
SELECT COUNT(*), first_name FROM actors 
GROUP BY first_name 
ORDER BY count(*) DESC
LIMIT 0, 10 ;

--10 apellidos mas populares
SELECT COUNT(*), last_name FROM actors 
GROUP BY last_name 
ORDER BY count(*) DESC
LIMIT 0, 10 ;

--10 full names mas populares
SELECT COUNT(*) as ocurrences, 
first_name || ' ' || last_name as full_name 
FROM actors 
GROUP BY full_name
ORDER BY ocurrences DESC
LIMIT 0, 10 ;

--prolifico
SELECT COUNT(*) as role_count,
first_name , last_name
FROM roles INNER JOIN actors
ON roles.actor_id = actors.id
GROUP BY actor_id
ORDER BY role_count DESC
LIMIT 0, 100 ;

--barril
SELECT COUNT(*) as num_movies_by_genres, genre FROM 
movies_genres INNER JOIN movies
ON movies_genres.movie_id = movies.id
GROUP BY movies_genres.genre 
ORDER BY count(*) ASC;

--braveheart
SELECT first_name, last_name
FROM (roles INNER JOIN (SELECT id FROM movies 
WHERE name = "Braveheart"
AND year = 1995) as movieB
ON roles.movie_id = movieB.id) as movieBXroles
INNER JOIN actors 
ON actors.id = movieBXroles.actor_id 
ORDER BY last_name;

--noir bisiesto
SELECT directors.first_name, directors.last_name, 
mov.name, mov.year FROM directors 
INNER JOIN (SELECT * FROM movies_directors 
INNER JOIN (SELECT * FROM (movies 
INNER JOIN(SELECT movie_id FROM movies_genres 
WHERE genre = "Film-Noir") as movID
ON movies.id = movID.movie_id) as movXgen
WHERE movXgen.year % 4 = 0) as movXelse
ON movXelse.id = movies_directors.movie_id) as mov
ON mov.director_id = directors.id;

-- kevin bacon
SELECT first_name, last_name, abcd2.name 
FROM actors INNER JOIN 
(SELECT * FROM movies
INNER JOIN
(SELECT * FROM roles
WHERE movie_id IN
(SELECT movie_id FROM roles
WHERE actor_id IN 
(SELECT id FROM actors
WHERE first_name = "Kevin" AND 
last_name = "Bacon")
AND movie_id IN (SELECT movie_id FROM movies_genres
WHERE genre = "Drama")) 
AND actor_id NOT IN 
(SELECT id FROM actors
WHERE first_name = "Kevin" AND 
last_name = "Bacon")) as abcd
ON movies.id = abcd.movie_id) as abcd2
ON actors.id = abcd2.actor_id
ORDER BY name;

--actores inmortales

SELECT first_name, last_name, id FROM actors
WHERE id IN
(SELECT actor_id FROM roles 
WHERE movie_id IN(
SELECT id FROM movies
WHERE year<1900)) 
AND id IN
(SELECT actor_id FROM roles 
WHERE movie_id IN(
SELECT id FROM movies
WHERE year>2000));

--ocupados

SELECT first_name, last_name, comp.name,
comp.year, comp.n_roles FROM actors 
INNER JOIN (SELECT * FROM (SELECT COUNT(DISTINCT role) as n_roles,                                                                 
actor_id, movie_id, movs.name , movs.year FROM roles 
INNER JOIN (SELECT * FROM movies
WHERE year > 1990) AS movs
ON roles.movie_id = movs.id
AND roles.role is not null
GROUP BY actor_id, movie_id) as bank
WHERE bank.n_roles > 4) as comp
ON actors.id = comp.actor_id;

--♀ falta


SELECT year, COUNT(actor_id) AS femaleOnlyOrNoCast FROM (SELECT * FROM movies INNER JOIN (SELECT * FROM roles INNER JOIN
(SELECT * FROM actors
WHERE gender = "F") as women
ON roles.actor_id = women.id
-- AND roles.role LIKE "%Herself%"
-- OR roles.role LIKE "%herself%"
AND roles.movie_id NOT IN(
SELECT movie_id FROM roles
WHERE actor_id IN 
(SELECT id FROM actors
WHERE gender = "M"))) as womanXroles
WHERE movies.id = womanXroles.movie_id) as evr
GROUP BY evr.year
LIMIT 0,100;

