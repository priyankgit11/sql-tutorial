USE staff;
SELECT * FROM EMPLOYEES;
SELECT * FROM DEPARTMENTS;
SELECT * FROM JOBS;
-- 1.Create a scalar function that accepts string as a parameter and return whether the string is correct mail Id or not
CREATE FUNCTION check_mail (@par VARCHAR(50)) RETURNS VARCHAR(5) AS
BEGIN
	DECLARE @output VARCHAR(5);
	IF (@par LIKE '%@%') SET @output = 1;
	ELSE SET @output = 0;
	RETURN @output
END
SELECT 
CASE
WHEN dbo.check_mail('asdf@gmail.com')=1 THEN 'true'
ELSE  'FALSE'
END AS check_mail;

-- 2. Create a tabular function that accepts one parameter as employee department and return the employees working in that department.
CREATE FUNCTION emp_in_dept(@par VARCHAR(50)) RETURNS TABLE AS
RETURN SELECT First_Name,Last_Name FROM EMPLOYEES WHERE Department_ID = (SELECT Department_ID FROM DEPARTMENTS WHERE Department_Name = @par);
SELECT * FROM emp_in_dept('IT');

-- 3. Create a function that returns the data of employee records based on the page number passed. Parameters required are PageNumber, PageSize (Hint: use Row_Number, Partition by) 

CREATE FUNCTION data_by_page_size(@pageNum INT,@pageSize INT) RETURNS TABLE AS
RETURN 
SELECT * FROM (
SELECT *,
NTILE(@pageSize) OVER(ORDER BY Employee_ID) AS Page_Size
FROM EMPLOYEES
) AS A
WHERE Page_Size = @pageNum;

SELECT * FROM data_by_page_size(3,20);

-- 4. ‘Select EmpId, FirstName, LastName, PhoneNumber, Email from Employees’ check the execution plan for the given query and save it. Now, optimize the query and then check the execution plan and save it.

SELECT Employee_ID ,First_Name,Last_Name,Phone_Number,Email INTO #temp_tab4 FROM EMPLOYEES 
SELECT * FROM #temp_tab4;
CREATE PROCEDURE sp_exec_fast AS
-- ALTERNATIVE(SAME OPTIMIZATION)
SELECT Employee_ID ,First_Name,Last_Name,Phone_Number,Email FROM EMPLOYEES;
EXEC sp_exec_fast;

-- 5. Create a stored procedure that prints the employee info in the following format: 'employeename' hired on 'hiredate' has a salary package of 'salarypackage'
CREATE PROCEDURE print_emp_hire_info AS
SELECT CONCAT_WS(' ',First_Name,Last_Name,'hired on',Hire_Date,'as salary package of',Salary) FROM EMPLOYEES;

exec print_emp_hire_info;