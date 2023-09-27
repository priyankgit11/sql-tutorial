USE MOVIES_W3
SELECT * FROM movie;
SELECT * FROM movie_cast;
SELECT * FROM movie_direction;
SELECT * FROM movie_genres;
SELECT * FROM actor;
SELECT * FROM director;
SELECT * FROM genres;
SELECT * FROM rating;
SELECT * FROM reviewer;
-- 1. Write a SQL query to find the name and year of the movies. Return movie title, movie release year.
SELECT mov_title,mov_year FROM movie;
-- 2. write a SQL query to find when the movie ‘American Beauty’ released. Return movie release year.
SELECT mov_year FROM movie WHERE mov_title ='American Beauty';
-- 3.  write a SQL query to find the movie, which was made in the year 1999. Return movie title.
SELECT mov_title FROM movie WHERE mov_year =1999;
-- 4.  write a SQL query to find those movies, which was made before 1998. Return movie title.
SELECT mov_title FROM movie WHERE mov_year < 1998 ;
-- 5. write a SQL query to find the name of all reviewers and movies together in a single list.
SELECT mov_title, rev_name FROM movie, reviewer,rating WHERE movie.mov_id = rating.mov_id AND rating.rev_id = reviewer.rev_id;

-- 6. write a SQL query to find all reviewers who have rated 7 or more stars to their rating. Return reviewer name
SELECT rev_name FROM rating INNER JOIN reviewer ON rating.rev_id = reviewer.rev_id WHERE rev_stars > 7;
-- 7. write a SQL query to find the movies without any rating. Return movie title.
SELECT mov_title FROM movie LEFT JOIN rating ON movie.mov_id = rating.mov_id WHERE rating.rev_stars IS NULL;
-- 8. write a SQL query to find the movies with ID 905 or 907 or 917. Return movie title.
SELECT mov_title FROM movie WHERE mov_id IN (905,907,917);
-- 9. write a SQL query to find those movie titles, which include the words 'Boogie Nights'. Sort the result-set in ascending order by movie year. Return movie ID, movie title and movie release year.
SELECT mov_id, mov_title,mov_year FROM movie WHERE mov_title LIKE '%Boogie Nights%' ORDER BY mov_year;
-- 10. write a SQL query to find those actors whose first name is 'Woody' and the last name is 'Allen'. Return actor ID
SELECT act_id FROM actor WHERE act_fname = 'Woody' AND act_lname = 'Allen';

-- SUBQUERIES
-- 1. Find the actors who played a role in the movie 'Annie Hall'. Return all the fields of actor table.
--SELECT A.* FROM movie M INNER JOIN movie_cast C ON M.mov_id = C.mov_id INNER JOIN actor A ON C.act_id = A.act_id WHERE M.mov_title = 'Annie Hall';
SELECT * FROM actor AS A INNER JOIN 
(
SELECT act_id FROM movie_cast INNER JOIN movie ON movie_cast.mov_id = movie.mov_id WHERE movie.mov_title = 'Annie Hall'
) AS B
ON A.act_id = B.act_id;

-- 2. write a SQL query to find the director who directed a movie that casted a role for 'Eyes Wide Shut'. Return director first name, last name.
--SELECT dir_fname,dir_lname FROM director D INNER JOIN movie_direction MD ON D.dir_id = MD.dir_id INNER JOIN movie M ON MD.mov_id = M.mov_id WHERE M.mov_title = 'Eyes Wide Shut';
SELECT dir_fname,dir_lname FROM director AS A INNER JOIN 
(
SELECT dir_id FROM movie_direction INNER JOIN movie ON movie_direction.mov_id= movie.mov_id WHERE movie.mov_title = 'Eyes Wide Shut'
) AS B
ON A.dir_id = B.dir_id;

-- 3. write a SQL query to find those movies, which released in the country besides UK. Return movie title, movie year, movie time, date of release, releasing country.
SELECT mov_title,mov_time,mov_dt_rel, mov_rel_country FROM movie WHERE mov_rel_country <> 'UK';
-- 4. write a SQL query to find those movies where reviewer is unknown. Return movie title, year, release date, director first name, last name, actor first name, last name.
SELECT mov_title, mov_year,mov_dt_rel,dir_fname,dir_lname,act_fname,act_lname FROM
(
SELECT rating.mov_id,mov_title,mov_year,mov_dt_rel FROM rating INNER JOIN reviewer ON rating.rev_id = reviewer.rev_id INNER JOIN movie 
	ON movie.mov_id = rating.mov_id WHERE rev_name = ''
) AS A 
INNER JOIN 
(
	SELECT mov_id,director.dir_id,dir_lname,dir_fname FROM director INNER JOIN movie_direction ON director.dir_id = movie_direction.dir_id 
) AS B
ON A.mov_id = B.mov_id
INNER JOIN 
(
	SELECT movie_cast.mov_id,movie_cast.act_id,act_fname,act_lname FROM movie_cast INNER JOIN actor ON movie_cast.act_id = actor.act_id
) AS C
ON A.mov_id = C.mov_id;

-- 5. write a SQL query to find those movies directed by the director whose first name is ‘Woddy’ and last name is ‘Allen’. Return movie title. 
SELECT mov_title FROM 
(
SELECT dir_id FROM director WHERE dir_fname = 'Woody' AND dir_lname = 'Allen'
) AS A 
INNER JOIN
(
SELECT dir_id, mov_title,movie_direction.mov_id FROM movie_direction INNER JOIN movie ON movie_direction.mov_id = movie.mov_id
)AS B
ON A.dir_id = B.dir_id;

-- 6. write a SQL query to find those years, which produced at least one movie and that, received a rating of more than three stars. Sort the result-set in ascending order by movie year. Return movie year.
SELECT A.mov_year FROM
(
SELECT mov_year FROM movie INNER JOIN rating ON rating.mov_id = movie.mov_id WHERE rating.rev_stars>3 GROUP BY mov_year,mov_title HAVING COUNT(*)>0
)AS A
 ORDER BY A.mov_year 
;

-- 7. write a SQL query to find those movies, which have no ratings. Return movie title.
SELECT mov_title FROM movie INNER JOIN rating ON movie.mov_id = rating.mov_id WHERE rev_stars IS NULL;
-- 8. write a SQL query to find those reviewers who have rated nothing for some movies. Return reviewer name.
SELECT rev_name FROM rating INNER JOIN reviewer ON rating.rev_id = reviewer.rev_id WHERE rating.rev_stars IS NULL;
-- 9. write a SQL query to find those movies, which reviewed by a reviewer and got a rating. Sort the result-set in ascending order by reviewer name, movie title, review Stars. Return reviewer name, movie title, review Stars.
SELECT rev_name,mov_title,rev_stars FROM 
(
SELECT rev_stars,mov_id,rev_name FROM rating INNER JOIN reviewer ON rating.rev_id = reviewer.rev_id WHERE rev_name <> ''
) AS A
INNER JOIN movie ON movie.mov_id = A.mov_id
ORDER BY rev_name,mov_title,rev_stars;
-- 10. write a SQL query to find those reviewers who rated more than one movie. Group the result set on reviewer’s name, movie title. Return reviewer’s name, movie title.
SELECT rev_name,mov_title FROM 
(
SELECT rev_id,COUNT(*) AS tot_reviews FROM rating GROUP BY rev_id HAVING COUNT(*)> 1
)AS A
INNER JOIN
(
SELECT rev_name,reviewer.rev_id,mov_id FROM reviewer INNER JOIN rating ON reviewer.rev_id = rating.rev_id
)AS B 
ON A.rev_id = B.rev_id
INNER JOIN 
(
SELECT mov_title,mov_id FROM movie 
)AS C
ON B.mov_id = C.mov_id;
-- 11. write a SQL query to find those movies, which have received highest number of stars. Group the result set on movie title and sorts the result-set in ascending order by movie title. Return movie title and maximum number of review stars. 
SELECT mov_title,rev_stars FROM
	(
		SELECT movie.mov_id,mov_title,rev_stars FROM movie INNER JOIN rating ON movie.mov_id = rating.mov_id 
	)AS A
	INNER JOIN
	(
		SELECT MAX(rev_stars)AS max_rating FROM rating 
	)AS B
ON A.rev_stars = B.max_rating;
-- 12. write a SQL query to find all reviewers who rated the movie 'American Beauty'. Return reviewer name.
SELECT rev_name FROM
(
SELECT rev_id FROM rating INNER JOIN movie ON rating.mov_id = movie.mov_id WHERE mov_title = 'American Beauty'
) AS A
INNER JOIN
(
SELECT rev_name,reviewer.rev_id FROM reviewer INNER JOIN rating ON reviewer.rev_id = rating.rev_id
)AS B
ON A.rev_id = B.rev_id;
-- 13. write a SQL query to find the movies, which have reviewed by any reviewer body except by 'Paul Monks'. Return movie title.
SELECT mov_title FROM
(
	SELECT movie.mov_id,mov_title
	FROM movie
	left JOIN rating
	ON movie.mov_id = rating.mov_id
)AS A
INNER JOIN
(
	SELECT mov_id 
	FROM rating
	INNER JOIN reviewer
	ON rating.rev_id = reviewer.rev_id
	WHERE reviewer.rev_name <> 'Paul Monks'
)AS B
ON A.mov_id = B.mov_id;

-- 14. write a SQL query to find the lowest rated movies. Return reviewer name, movie title, and number of stars for those movies. 
SELECT rev_name,mov_title,rev_stars 
FROM
(
	SELECT rev_stars, rev_name, mov_title FROM rating INNER JOIN movie ON  rating.mov_id = movie. mov_id INNER JOIN reviewer ON  rating.rev_id = reviewer.rev_id
) AS A 
INNER JOIN
(
SELECT MIN(rev_stars) AS min_rating FROM rating
)AS B
ON A.rev_stars = B.min_rating;
-- 15. write a SQL query to find the movies directed by 'James Cameron'. Return movie title. 
SELECT mov_title
FROM 
movie
INNER JOIN
(
SELECT mov_id
FROM movie_direction INNER JOIN director
ON movie_direction.dir_id = director.dir_id
WHERE dir_fname = 'James' AND dir_lname = 'Cameron'
)AS A
ON movie.mov_id = A.mov_id;

-- 16. Write a query in SQL to find the name of those movies where one or more actors acted in two or more movies.
SELECT mov_title
FROM 
(
SELECT mov_title, movie_cast.mov_id,act_id FROM movie INNER JOIN movie_cast ON movie.mov_id = movie_cast.mov_id
)AS A
INNER JOIN
(
	SELECT movie_cast.act_id, COUNT(mov_id)AS more_mov  FROM movie_cast INNER JOIN actor ON movie_cast.act_id = actor.act_id GROUP BY movie_cast.act_id
	HAVING COUNT(mov_id)>1
)AS B
ON A.act_id = B.act_id;


-------- JOINS ---------------

-- 1. write a SQL query to find the name of all reviewers who have rated their ratings with a NULL value. Return reviewer name.
SELECT A.rev_name 
FROM reviewer A 
INNER JOIN rating AS B 
ON A.rev_id = B.rev_id 
WHERE rev_stars IS NULL
-- 2. write a SQL query to find the actors who were cast in the movie 'Annie Hall'. Return actor first name, last name and role. 
SELECT act_fname, act_lname 
FROM actor A 
INNER JOIN movie_cast B 
ON A.act_id = B.act_id 
INNER JOIN movie C 
ON B.mov_id = C.mov_id 
WHERE mov_title = 'Annie Hall';
-- 3. write a SQL query to find the director who directed a movie that casted a role for 'Eyes Wide Shut'. Return director first name, last name and movie title.
SELECT dir_fname,dir_lname, mov_title 
FROM movie A 
INNER JOIN movie_direction B
ON A.mov_id = B.mov_id
INNER JOIN director C
ON C.dir_id = B.dir_id
WHERE A.mov_title = 'Eyes Wide Shut';
-- 4. write a SQL query to find who directed a movie that casted a role as ‘Sean Maguire’. Return director first name, last name and movie title.
SELECT dir_fname, dir_lname,mov_title
FROM movie A
INNER JOIN movie_direction B
ON A.mov_id = B.mov_id
INNER JOIN director C
ON B.dir_id = C.dir_id
INNER JOIN movie_cast D
ON A.mov_id = D.mov_id
INNER JOIN actor E
ON D.act_id = E.act_id
WHERE D.role = 'Sean Maguire';
-- 5. write a SQL query to find the actors who have not acted in any movie between1990 and 2000 (Begin and end values are included.). Return actor first name, last name, movie title and release year.
SELECT act_fname, act_lname, mov_title, mov_year 
FROM actor A
INNER JOIN movie_cast B
ON A.act_id = B.act_id
INNER JOIN movie C
ON C.mov_id = B.mov_id
WHERE NOT mov_year BETWEEN 1999 AND 2000;
-- 6. write a SQL query to find the directors with number of genres movies. Group the result set on director first name, last name and generic title. Sort the result-set in ascending order by director first name and last name. Return director first name, last name and number of genres movies.
SELECT dir_fname,dir_lname,COUNT(E.gen_title)AS tot_gen
FROM director A
INNER JOIN movie_direction B
ON A.dir_id = B.dir_id
INNER JOIN movie C
ON B.mov_id = C.mov_id
INNER JOIN movie_genres D
ON C.mov_id = D.mov_id
INNER JOIN genres E
ON D.gen_id = E.gen_id
GROUP BY dir_lname,dir_fname,E.gen_title
ORDER BY dir_fname,dir_lname
-- 7. write a SQL query to find the movies with year and genres. Return movie title, movie year and generic title.
SELECT mov_title, mov_year, gen_title 
FROM movie A
INNER JOIN movie_genres B
ON A.mov_id = B.mov_id
INNER JOIN genres C
ON B.gen_id = C.gen_id;
-- 8. write a SQL query to find all the movies with year, genres, and name of the director.
SELECT mov_year,gen_title,CONCAT_WS(' ',dir_fname,dir_lname) AS dir_name
FROM movie A
INNER JOIN movie_genres B
ON A.mov_id = B.mov_id
INNER JOIN genres C
ON C.gen_id = B.gen_id
INNER JOIN movie_direction D
ON D.mov_id = A.mov_id
INNER JOIN director E
ON D.dir_id = E.dir_id;
-- 9. write a SQL query to find the movies released before 1st January 1989. Sort the result-set in descending order by date of release. Return movie title, release year, date of release, duration, and first and last name of the director.
SELECT mov_title,mov_year,mov_dt_rel,mov_time,dir_fname,dir_lname
FROM movie A
INNER JOIN movie_direction B
ON A.mov_id = B.mov_id
INNER JOIN director
ON B.dir_id = director.dir_id
ORDER BY mov_dt_rel DESC;
-- 10. write a SQL query to compute the average time and count number of movies for each genre. Return genre title, average time and number of movies for each genre.
SELECT gen_title,AVG(mov_time) AS avg_time,COUNT(mov_title)AS num_of_mov
FROM genres A
INNER JOIN movie_genres B
ON A.gen_id = B.gen_id
INNER JOIN  movie C
ON C.mov_id = B.mov_id
GROUP BY gen_title;
-- 11. write a SQL query to find movies with the lowest duration. Return movie title, movie year, director first name, last name, actor first name, last name and role.
SELECT mov_title,mov_year, dir_fname,dir_lname,act_fname,act_lname,role
FROM movie A
INNER JOIN movie_direction B
ON A.mov_id = B.mov_id
INNER JOIN director C
ON B.dir_id = C.dir_id
INNER JOIN movie_cast D
ON D.mov_id = A.mov_id
INNER JOIN actor E
ON E.act_id = D.act_id 
WHERE A.mov_time = (SELECT MIN(mov_time) FROM movie);
-- 12. write a SQL query to find those years when a movie received a rating of 3 or 4. Sort the result in increasing order on movie year. Return move year. 
SELECT mov_year
FROM movie
INNER JOIN rating
ON movie.mov_id = rating.mov_id
WHERE rev_stars = 3 OR rev_stars = 4
ORDER BY mov_year;
-- 13. write a SQL query to get the reviewer name, movie title, and stars in an order that reviewer name will come first, then by movie title, and lastly by number of stars.
SELECT rev_name, mov_title, rev_stars
FROM reviewer A
INNER JOIN rating B
ON A.rev_id = B.rev_id
INNER JOIN movie C
ON C.mov_id = B.mov_id
ORDER BY rev_name, mov_title,rev_stars;
-- 14. write a SQL query to find those movies that have at least one rating and received highest number of stars. Sort the result-set on movie title. Return movie title and maximum review stars
SELECT mov_title
FROM movie
INNER JOIN rating
ON movie.mov_id = rating.mov_id
WHERE rev_stars = (SELECT MAX(rev_stars) FROM rating)
GROUP BY mov_title
HAVING COUNT(rev_stars)>0 
-- 15. write a SQL query to find those movies, which have received ratings. Return movie title, director first name, director last name and review stars.
SELECT mov_title, dir_fname,dir_lname,rev_stars
FROM movie
INNER JOIN rating 
ON movie.mov_id = rating.mov_id
INNER JOIN movie_direction
ON movie_direction.mov_id= movie.mov_id
INNER JOIN director
ON director.dir_id = movie_direction.dir_id
WHERE rev_stars IS NOT NULL;
-- 16. Write a query in SQL to find the movie title, actor first and last name, and the role for those movies where one or more actors acted in two or more movies. 
SELECT mov_title,act_fname,act_lname,role
FROM movie
INNER JOIN movie_cast
ON movie.mov_id = movie_cast.mov_id
INNER JOIN actor
ON actor.act_id = movie_cast.act_id
WHERE actor.act_id = (SELECT act_id FROM movie_cast GROUP BY act_id HAVING COUNT(mov_id)>1)
