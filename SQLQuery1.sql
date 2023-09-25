CREATE DATABASE temp;
USE temp;
CREATE TABLE customers (
    id INT PRIMARY KEY IDENTITY(1,1),
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(50)
);

CREATE TABLE orders (
    id INT PRIMARY KEY IDENTITY(1,1),
    order_date DATE,
    amount DECIMAL(8,2),
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

INSERT INTO customers (first_name, last_name, email) 
VALUES ('Boy', 'George', 'george@gmail.com'),
       ('George', 'Michael', 'gm@gmail.com'),
       ('David', 'Bowie', 'david@gmail.com'),
       ('Blue', 'Steele', 'blue@gmail.com'),
       ('Bette', 'Davis', 'bette@aol.com');
       
       
INSERT INTO orders (order_date, amount, customer_id)
VALUES ('2016-02-10', 99.99, 1),
       ('2017-11-11', 35.50, 1),
       ('2014-12-12', 800.67, 2),
       ('2015-01-03', 12.50, 2),
       ('1999-04-11', 450.25, 5);
SELECT * FROM customers,orders;
SELECT first_name, last_name, order_date, amount FROM customers RIGHT JOIN orders ON orders.customer_id = customers.id;
SELECT *  FROM orders RIGHT JOIN customers ON customers.id = orders.customer_id;
INSERT INTO orders(order_date,amount) VALUES('2020-11-12',23.50);
SELECT * FROM orders FULL OUTER JOIN customers ON orders.customer_id = customers.id;
DROP TABLE orders;
DROP TABLE customers;

CREATE TABLE customers (
    id INT PRIMARY KEY IDENTITY(1,1),
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(50)
);
CREATE TABLE orders (
    id INT PRIMARY KEY IDENTITY(1,1),
    order_date DATE,
    amount DECIMAL(8,2),
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE
);

DELETE FROM customers WHERE last_name = 'George';
SELECT * FROM orders;

-- Exercise
CREATE TABLE students(id INT PRIMARY KEY IDENTITY(1,1), first_name VARCHAR(100));
CREATE TABLE papers(title VARCHAR(100),grade INT, student_id INT, FOREIGN KEY(student_id) REFERENCES students(id) ON DELETE CASCADE);

INSERT INTO students (first_name) VALUES 
('Caleb'), ('Samantha'), ('Raj'), ('Carlos'), ('Lisa');

INSERT INTO papers (student_id, title, grade ) VALUES
(1, 'My First Book Report', 60),
(1, 'My Second Book Report', 75),
(2, 'Russian Lit Through The Ages', 94),
(2, 'De Montaigne and The Art of The Essay', 98),
(4, 'Borges and Magical Realism', 89);

SELECT first_name,title,grade FROM students INNER JOIN papers ON students.id = papers.student_id ORDER BY grade DESC;
SELECT first_name,AVG(
CAST((CASE
WHEN grade IS NULL THEN 0 
ELSE grade
END)
AS DECIMAL )) AS average,
CASE
WHEN (AVG(
CAST((CASE
WHEN grade IS NULL THEN 0 
ELSE grade
END)
AS DECIMAL )))>=75 THEN 'PASSING'
ELSE 'FAILING'
END AS passing_status
FROM students LEFT JOIN papers ON students.id = papers.student_id GROUP BY first_name ORDER BY average DESC;
SELECT AVG(NULL);

SELECT 
    first_name,
    COALESCE(AVG(grade), 0) AS average,
    CASE
        WHEN COALESCE(AVG(grade), 0) >= 75 THEN 'passing'
        ELSE 'failing'
    END AS passing_status
FROM
    students
        LEFT JOIN
    papers ON students.id = papers.student_id
GROUP BY first_name
ORDER BY average DESC;


--tv_db
CREATE DATABASE tv_db;
USE tv_db;

CREATE TABLE reviewers (
    id INT PRIMARY KEY IDENTITY(1,1),
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL
);

CREATE TABLE series (
    id INT PRIMARY KEY IDENTITY(1,1),
    title VARCHAR(100),
    released_year INT,
    genre VARCHAR(100)
);

CREATE TABLE reviews (
    id INT PRIMARY KEY IDENTITY(1,1),
    rating DECIMAL(2 , 1 ),
    series_id INT,
    reviewer_id INT,
    FOREIGN KEY (series_id)
        REFERENCES series (id),
    FOREIGN KEY (reviewer_id)
        REFERENCES reviewers (id)
);

INSERT INTO series (title, released_year, genre) VALUES
    ('Archer', 2009, 'Animation'),
    ('Arrested Development', 2003, 'Comedy'),
    ('Bob''s Burgers', 2011, 'Animation'),
    ('Bojack Horseman', 2014, 'Animation'),
    ('Breaking Bad', 2008, 'Drama'),
    ('Curb Your Enthusiasm', 2000, 'Comedy'),
    ('Fargo', 2014, 'Drama'),
    ('Freaks and Geeks', 1999, 'Comedy'),
    ('General Hospital', 1963, 'Drama'),
    ('Halt and Catch Fire', 2014, 'Drama'),
    ('Malcolm In The Middle', 2000, 'Comedy'),
    ('Pushing Daisies', 2007, 'Comedy'),
    ('Seinfeld', 1989, 'Comedy'),
    ('Stranger Things', 2016, 'Drama');
 
 
INSERT INTO reviewers (first_name, last_name) VALUES
    ('Thomas', 'Stoneman'),
    ('Wyatt', 'Skaggs'),
    ('Kimbra', 'Masters'),
    ('Domingo', 'Cortes'),
    ('Colt', 'Steele'),
    ('Pinkie', 'Petit'),
    ('Marlon', 'Crafford');
    
 
INSERT INTO reviews(series_id, reviewer_id, rating) VALUES
    (1,1,8.0),(1,2,7.5),(1,3,8.5),(1,4,7.7),(1,5,8.9),
    (2,1,8.1),(2,4,6.0),(2,3,8.0),(2,6,8.4),(2,5,9.9),
    (3,1,7.0),(3,6,7.5),(3,4,8.0),(3,3,7.1),(3,5,8.0),
    (4,1,7.5),(4,3,7.8),(4,4,8.3),(4,2,7.6),(4,5,8.5),
    (5,1,9.5),(5,3,9.0),(5,4,9.1),(5,2,9.3),(5,5,9.9),
    (6,2,6.5),(6,3,7.8),(6,4,8.8),(6,2,8.4),(6,5,9.1),
    (7,2,9.1),(7,5,9.7),
    (8,4,8.5),(8,2,7.8),(8,6,8.8),(8,5,9.3),
    (9,2,5.5),(9,3,6.8),(9,4,5.8),(9,6,4.3),(9,5,4.5),
    (10,5,9.9),
    (13,3,8.0),(13,4,7.2),
    (14,2,8.5),(14,3,8.9),(14,4,8.9);

SELECT * FROM series;
SELECT * FROM reviewers;
SELECT * FROM reviews;

SELECT title,rating FROM reviews LEFT JOIN series ON series.id = reviews.series_id ORDER BY title;
SELECT title, AVG(rating) AS average FROM reviews LEFT JOIN series ON series.id = reviews.series_id GROUP BY title ORDER BY average;
SELECT first_name, last_name ,rating FROM reviewers LEFT JOIN reviews ON reviewers.id = reviews.reviewer_id ORDER BY reviewers.id;
SELECT title AS unreviewed_series FROM series LEFT JOIN reviews ON series.id = reviews.series_id WHERE rating IS NULL ;
SELECT genre,AVG(rating) AS avg_rating FROM series LEFT JOIN reviews ON series.id = reviews.series_id GROUP BY genre ORDER BY genre;

SELECT reviewers.id,first_name,last_name, COALESCE(COUNT(rating),0) AS 'COUNT',COALESCE(MIN(rating),0) AS 'MIN',COALESCE(MAX(rating),0) AS 'MAX',COALESCE(AVG(rating), 0) AS 'AVG',
CASE
WHEN COALESCE(AVG(rating), 0) = 0 THEN 'INACTIVE'
ELSE 'ACTIVE'
END AS 'STATUS'
FROM reviewers LEFT JOIN reviews ON reviewers.id = reviews.reviewer_id GROUP BY reviewers.id,first_name,last_name ;

SELECT 
    first_name,
    last_name,
    COUNT(rating) AS count,
    COALESCE(MIN(rating), 0) AS min,
    COALESCE(MAX(rating), 0) AS max,
    ROUND(COALESCE(AVG(rating), 0), 2) AS average,
    CASE
        WHEN COUNT(rating) >= 10 THEN 'POWERUSER'
        WHEN COUNT(rating) > 0 THEN 'ACTIVE'
        ELSE 'INACTIVE'
    END AS status
FROM
    reviewers
        LEFT JOIN
    reviews ON reviewers.id = reviews.reviewer_id
GROUP BY first_name , last_name;
USE w3schools;
CREATE VIEW full_reviews AS
SELECT title, released_year, genre, rating, first_name, last_name FROM reviews
JOIN series ON series.id = reviews.series_id
JOIN reviewers ON reviewers.id = reviews.reviewer_id;

SELECT released_year,AVG(rating)
FROM full_reviews
GROUP BY released_year WITH ROLLUP;



-- W3SCHOOLS DB
SELECT EmpId, CONCAT_WS(' ',emp_fname,emp_lname),orders_count,latest_order_date,emp_age,d.CustomerName FROM 
(
	SELECT employees.EmployeeID AS EmpID,
		FirstName AS emp_fname,
		LastName AS emp_lname,
		DATEDIFF(year,BirthDate,GETDATE()) AS emp_age,
		COALESCE(COUNT(OrderID),0) AS orders_count,
		MAX(OrderDate) AS latest_order_date
		FROM employees JOIN orders 
		ON employees.EmployeeID = orders.EmployeeID 
		GROUP BY employees.EmployeeID, employees.FirstName,employees.LastName,employees.BirthDate
)	AS c LEFT JOIN
(
	SELECT CustomerName,EmployeeID FROM customers,
	(
		SELECT CustomerID,EmployeeID FROM orders,
		(
			SELECT MAX(OrderID) as oid FROM orders GROUP BY EmployeeID
		) AS a
		WHERE a.oid = orders.OrderID
	) AS b WHERE customers.CustomerID = b.CustomerID
) AS d ON c.EmpID = d.EmployeeID 
ORDER BY 
CASE
WHEN emp_lname LIKE 'd%' THEN 1
ELSE 2
END
;
--TASK 1
SELECT COUNT(watch_id) FROM [event] e GROUP BY e.event_id;
--task 2
 SELECT * FROM [watch] w INNER JOIN
(
	
)