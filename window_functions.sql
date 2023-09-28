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

SELECT * FROM employees;
SELECT emp_no,department,salary,MIN(salary) OVER(),MAX(salary) OVER() FROM employees;
SELECT  MAX(salary) OVER(),MIN(salary) OVER() FROM employees;
SELECT emp_no,department,salary,SUM(salary) OVER(PARTITION BY department),MAX(salary) OVER() FROM employees;
SELECT emp_no,department,salary,SUM(salary) OVER(PARTITION BY department ORDER BY SALARY DESC),MAX(salary) OVER() FROM employees;
SELECT emp_no,department,salary,salary-LAG(salary) 
OVER(PARTITION BY department ORDER BY salary DESC)as salary_diff
FROM employees

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
