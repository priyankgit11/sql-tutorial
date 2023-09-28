CREATE TABLE employees (
    emp_no INT PRIMARY KEY IDENTITY(1,1),
    department VARCHAR(20),
    salary INT
);

INSERT INTO employees (department, salary) VALUES
('engineering', 80000),
('engineering', 69000),
('engineering', 70000),
('engineering', 103000),
('engineering', 67000),
('engineering', 89000),
('engineering', 91000),
('sales', 59000),
('sales', 70000),
('sales', 159000),
('sales', 72000),
('sales', 60000),
('sales', 61000),
('sales', 61000),
('customer service', 38000),
('customer service', 45000),
('customer service', 61000),
('customer service', 40000),
('customer service', 31000),
('customer service', 56000),
('customer service', 55000);

-- SQL FUNCTIONS
SELECT * FROM employees;
SELECT emp_no,department,salary,MIN(salary) OVER(),MAX(salary) OVER() FROM employees;
SELECT  MAX(salary) OVER(),MIN(salary) OVER() FROM employees;
SELECT emp_no,department,salary,SUM(salary) OVER(PARTITION BY department),MAX(salary) OVER() FROM employees;
SELECT emp_no,department,salary,SUM(salary) OVER(PARTITION BY department ORDER BY SALARY DESC),MAX(salary) OVER() FROM employees;
SELECT emp_no,department,salary,salary-LAG(salary) 
OVER(PARTITION BY department ORDER BY salary DESC)as salary_diff
FROM employees
-- USER DEFINED FUNCTIONS
CREATE FUNCTION poor_or_rich(@sal INT)RETURNS CHAR(4) AS 
BEGIN
	DECLARE @return_value CHAR(4);
	IF(@sal<=60000) SET @return_value='poor';
	ELSE SET @return_value = 'rich';
	RETURN @return_value;
END

CREATE FUNCTION get_emp_by_dept_name(@deptname VARCHAR(50)) RETURNS TABLE AS
RETURN (
SELECT * FROM employees WHERE department = @deptname
);
CREATE FUNCTION get_name(@deptname VARCHAR(50)) RETURNS TABLE AS
RETURN (
SELECT * FROM employees WHERE department = @deptname
);
SELECT * FROM dbo.get_emp_by_dept_name('engineering');
--ROW NUMBER
SELECT emp_no,department,salary,ROW_NUMBER() OVER(PARTITION BY department ORDER BY salary)AS row_num,
DENSE_RANK() OVER(PARTITION BY department ORDER BY salary) AS dense_rnk,
RANK() OVER(PARTITION BY department ORDER BY salary) AS rnk
FROM employees
;
-- OFFSET
SELECT *
FROM employees
ORDER BY emp_no
OFFSET 10 ROWS
FETCH NEXT 10 ROWS ONLY;
SELECT 5+'1'
DBCC SHOW_STATISTICS('dbo.employees','emp_no')

-- TEMPORARY TABLES
USE temp;
CREATE TABLE #temp_tab1(id INT PRIMARY KEY,
name VARCHAR(50)
);
CREATE TABLE ##temp_tab2
(
	emp_no INT PRIMARY KEY IDENTITY(1,1),
    department VARCHAR(20),
    salary INT
);
SELECT * INTO ##temp_tab2 FROM employees;
DECLARE @temp_var TABLE(empNo INT,dept VARCHAR(50),sal INT);
INSERT INTO @temp_var VALUES 
(1,'engineering', 91000),
(2,'sales', 59000),
(3,'customer service', 38000);
SELECT * FROM @temp_var;

--CURSORS
DECLARE cursor_emp CURSOR FOR
	SELECT emp_no,department,salary FROM employees;

OPEN cursor_emp;

DECLARE @empNo INT;
DECLARE @deptName VARCHAR(128);
DECLARE @sal INT;
FETCH NEXT FROM cursor_emp INTO @empNo, @deptName, @sal;
WHILE @@FETCH_STATUS = 0
    BEGIN
    PRINT CONCAT('Employee No.: ', @empNo, ' / Department: ', @deptName, ' / Salary: ', @sal);
    FETCH NEXT FROM cursor_emp INTO @empNo, @deptName, @sal;
    END;
 
-- close and deallocate cursor
CLOSE cursor_city_country;
DEALLOCATE cursor_city_country;

--WHILE

DECLARE @Counter INT 
SET @Counter=1
WHILE ( @Counter <= 20)
BEGIN
 
  IF @Counter % 2 =1
  BEGIN
  SET @Counter  = @Counter  + 1
  CONTINUE
  END
    PRINT 'The counter value is = ' + CONVERT(VARCHAR,@Counter)
    SET @Counter  = @Counter  + 1
END

DECLARE @Counter INT
DECLARE @DepName VARCHAR(100)
SET @Counter =0
WHILE(@Counter IS NOT NULL)
BEGIN
	SELECT Department = @DepName FROM employees WHERE emp_no=@Counter
	PRINT @DepName
END

-- TRY AND CATCH
BEGIN TRY
    SELECT 1/0 AS Error;
END TRY
BEGIN CATCH
  SELECT
    ERROR_NUMBER() AS ErrorNumber,
    ERROR_STATE() AS ErrorState,
    ERROR_SEVERITY() AS ErrorSeverity,
    ERROR_PROCEDURE() AS ErrorProcedure,
    ERROR_LINE() AS ErrorLine,
    ERROR_MESSAGE() AS ErrorMessage;
END CATCH;

--DATE FUNCTIONS
SELECT DATEPART(WEEKDAY, '2023-07-28');
Select CONVERT(VARCHAR,CAST('2023-09-08' AS DATE),110) as [YYYY/MM/DD]
SELECT DATEPART(MONTH,'2023-07-28');
SELECT EOMONTH('2023-07-07');

--STRING COMPARISION
SELECT UPPER ('Hello World');

-- STORED PROCEDURES
CREATE PROCEDURE GetDeptName AS
BEGIN
	SET NOCOUNT ON
	SELECT department FROM employees GROUP BY department;
END

EXEC GetDeptName;
sp_rename 'GetDeptName' , 'GetDept'

-- USER DEFINED TYPES

--ALTER TABLE papers
--ALTER COLUMN grade VARCHAR(50);
--SELECT * FROM papers;
--INSERT INTO papers VALUES ('Hello','World',5);

ALTER TABLE papers
ADD email [dbo].[email];
ALTER TABLE papers
ADD gmail VARCHAR(50)

CREATE TYPE PeopleTab
AS TABLE(
id INT PRIMARY KEY,
name VARCHAR(50)
);
