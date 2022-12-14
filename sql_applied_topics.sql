
    

/* SQL Insert Statement

Exercise: Select ten records from the “titles” table to get a better idea about its content.
Then, in the same table, insert information about employee number 999903. 
State that he/she is a “Senior Engineer”, who has started working in this position on 
October 1st, 1997. At the end, sort the records from the “titles” table in 
descending order to check if you have successfully inserted the new record.*/
SELECT
    *
FROM
    titles
LIMIT 10;

insert into titles
(
                emp_no,
    title,
    from_date
)
values
(
                999903,
    'Senior Engineer',
    '1997-10-01'
);

SELECT
    *
FROM
    titles
ORDER BY emp_no DESC;


/* SQL Update Statement 
Exercise: Change the “Business Analysis” department name to “Data Analysis”.*/
UPDATE departments 
SET 
    dept_name = 'Data Analysis'
WHERE
    dept_no = 'd010';
    

/* SQL Delete Statement
Exercise: Remove the department number 10 record from the “departments” table.*/
DELETE FROM departments 
WHERE
    dept_no = 'd010';
    

/* Aggregate Functions 
Exercise (Count): How many departments are there in the “employees” database? 
Use the ‘dept_emp’ table to answer the question. 

Exercise (Sum): What is the total amount of money spent on salaries for all 
contracts starting after the 1st of January 1997?

Exercise (Min & Max): 1. Which is the lowest employee number in the database?
2. Which is the highest employee number in the database?

Exercise (Avg): What is the average annual salary paid to employees who 
started after the 1st of January 1997?

Exercise (Round): Round the average amount of money spent on salaries for
all contracts that started after the 1st of January 1997 to a precision of cents.
 
Exercise (Coalesce): Select the department number and name from the 
‘departments_dup’ table and add a third column where you name the department number
(‘dept_no’) as ‘dept_info’. If ‘dept_no’ does not have a value, use ‘dept_name’.


Exercise (IfNull): Modify the code obtained from the previous exercise in
the following way. Apply the IFNULL() function to the values from the first 
and second column, so that ‘N/A’ is displayed whenever a department number has 
no value, and ‘Department name not provided’ is shown if there is no value for 
‘dept_name’.
 */
SELECT 
    COUNT(DISTINCT dept_no)
FROM
    dept_emp;
    
    
SELECT 
    SUM(salary)
FROM
    salaries
WHERE
    from_date > '1997-01-01';    

SELECT 
    MIN(emp_no)
FROM
    employees;

SELECT 
    MAX(emp_no)
FROM
    employees;

SELECT 
    AVG(salary)
FROM
    salaries
WHERE
    from_date > '1997-01-01';

SELECT
    ROUND(AVG(salary), 2)
FROM
    salaries
WHERE
    from_date > '1997-01-01';
    
SELECT 
    dept_no,
    dept_name,
    COALESCE(dept_no, dept_name) AS dept_info
FROM
    departments_dup
ORDER BY dept_no ASC;

SELECT 
    IFNULL(dept_no, 'N/A') AS dept_no,
    IFNULL(dept_name,
            'Department name not provided') AS dept_name,
    COALESCE(dept_no, dept_name) AS dept_info
FROM
    departments_dup
ORDER BY dept_no ASC;


/* Inner Joins 
Exercise: Extract a list containing information about all managers’ employee number, first and last name, department number, and hire date. */
SELECT 
    e.emp_no, e.first_name, e.last_name, dm.dept_no, e.hire_date
FROM
    employees e
        JOIN
    dept_manager dm ON e.emp_no = dm.emp_no;


/* Left Joins 
Exercise: Join the 'employees' and the 'dept_manager' tables to return a subset of all the employees 
whose last name is Markovitch. See if the output contains a manager with that name.*/
SELECT 
    e.emp_no,
    e.first_name,
    e.last_name,
    dm.dept_no,
    dm.from_date
FROM
    employees e
        LEFT JOIN
    dept_manager dm ON e.emp_no = dm.emp_no
WHERE
    e.last_name = 'Markovitch'
ORDER BY dm.dept_no DESC , e.emp_no;

/* Cross Joins
Exercise: Use a CROSS JOIN to return a list with all possible combinations between 
managers from the dept_manager table and department number 9.*/
SELECT 
    dm.*, d.*
FROM
    departments d
        CROSS JOIN
    dept_manager dm
WHERE
    d.dept_no = 'd009'
ORDER BY d.dept_no;

/* Join more than 2 tables 
Exercise: Select all managers’ first and last name, hire date, 
job title, start date, and department name.
*/ 
SELECT 
    e.first_name,
    e.last_name,
    e.hire_date,
    t.title,
    m.from_date,
    d.dept_name
FROM
    employees e
        JOIN
    dept_manager m ON e.emp_no = m.emp_no
        JOIN
    departments d ON m.dept_no = d.dept_no
        JOIN
    titles t ON e.emp_no = t.emp_no
WHERE
    t.title = 'Manager'
ORDER BY e.emp_no;

/* Union vs Union All 
Exercise: Go forward to the solution and execute the query. 
What do you think is the meaning of the minus sign before subset 
A in the last row (ORDER BY -a.emp_no DESC)? */
SELECT 
    *
FROM
    (SELECT 
        e.emp_no,
            e.first_name,
            e.last_name,
            NULL AS dept_no,
            NULL AS from_date
    FROM
        employees e
    WHERE
        last_name = 'Denis' UNION SELECT 
        NULL AS emp_no,
            NULL AS first_name,
            NULL AS last_name,
            dm.dept_no,
            dm.from_date
    FROM
        dept_manager dm) AS a
ORDER BY - a.emp_no DESC;

/* Subqueries with IN nested inside WHERE 
Exercise: Extract the information about all department managers 
who were hired between the 1st of January 1990 and the 1st of January 1995.*/
SELECT 
    *
FROM
    dept_manager
WHERE
    emp_no IN (SELECT 
            emp_no
        FROM
            employees
        WHERE
            hire_date BETWEEN '1990-01-01' AND '1995-01-01');

/* Subqueries nested in SELECT and FROM 
Starting your code with “DROP TABLE”, create a table called “emp_manager”
(emp_no – integer of 11, not null; dept_no – CHAR of 4, null; manager_no – integer of 11, not null).*/
DROP TABLE IF EXISTS emp_manager;

CREATE TABLE emp_manager (
    emp_no INT(11) NOT NULL,
    dept_no CHAR(4) NULL,
    manager_no INT(11) NOT NULL
);

/* SQL Views 
Exercise: Create a view that will extract the average salary of all managers registered in the database. Round this value to the nearest cent.
If you have worked correctly, after executing the view from the “Schemas” section in Workbench, you should obtain the value of 66924.27.*/
CREATE OR REPLACE VIEW v_manager_avg_salary AS
    SELECT 
        ROUND(AVG(salary), 2)
    FROM
        salaries s
            JOIN
        dept_manager m ON s.emp_no = m.emp_no;

/* Stored Procedures 
Exercise: Create a procedure that will provide the average salary of all employees.
Then, call the procedure.*/
DELIMITER $$
CREATE PROCEDURE avg_salary()
BEGIN

                SELECT

                                AVG(salary)

                FROM

                                salaries;

END$$
DELIMITER ;
CALL avg_salary;
CALL avg_salary();
CALL employees.avg_salary;
CALL employees.avg_salary();

/* User-defined functions 
Exercise: Create a function called ‘emp_info’ that takes for parameters the 
first and last name of an employee, and returns the salary from the newest contract of that employee.*/

DELIMITER $$
CREATE FUNCTION emp_info(p_first_name varchar(255), p_last_name varchar(255)) RETURNS decimal(10,2)
DETERMINISTIC NO SQL READS SQL DATA
BEGIN



                DECLARE v_max_from_date date;



    DECLARE v_salary decimal(10,2);



SELECT 
    MAX(from_date)
INTO v_max_from_date FROM
    employees e
        JOIN
    salaries s ON e.emp_no = s.emp_no
WHERE
    e.first_name = p_first_name
        AND e.last_name = p_last_name;



SELECT 
    s.salary
INTO v_salary FROM
    employees e
        JOIN
    salaries s ON e.emp_no = s.emp_no
WHERE
    e.first_name = p_first_name
        AND e.last_name = p_last_name
        AND s.from_date = v_max_from_date;

       

                RETURN v_salary;



END$$
DELIMITER ;
SELECT EMP_INFO('Aruna', 'Journel');

/* SQL Triggers 
Exercise: Create a trigger that checks if the hire date of an employee 
is higher than the current date. If true, set this date to be the current date. 
Format the output appropriately (YY-MM-DD).
*/
DELIMITER $$
CREATE TRIGGER trig_hire_date  
BEFORE INSERT ON employees
FOR EACH ROW  
BEGIN  

                IF NEW.hire_date > date_format(sysdate(), '%Y-%m-%d') THEN     

                                SET NEW.hire_date = date_format(sysdate(), '%Y-%m-%d');     

                END IF;  

END $$  

DELIMITER ;  

INSERT employees VALUES ('999904', '1970-01-31', 'John', 'Johnson', 'M', '2025-01-01');  

SELECT 
    *
FROM
    employees
ORDER BY emp_no DESC;

/* SQL Indexes
Exercise: Select all records from the ‘salaries’ table of people whose salary is higher than $89,000 per annum.
Then, create an index on the ‘salary’ column of that table, and check if it has sped up the 
search of the same SELECT statement.*/
SELECT
    *
FROM
    salaries
WHERE
    salary > 89000;

CREATE INDEX i_salary ON salaries(salary);

SELECT 
    *
FROM
    salaries
WHERE
    salary > 89000;
    
/* SQL CASE Statement
Exercise: Extract a dataset containing the following information about the managers: employee number,
first name, and last name. Add two columns at the end – one showing the difference between the maximum
and minimum salary of that employee, and another one saying whether this salary raise was higher than $30,000 or NOT.*/

SELECT 
    dm.emp_no,
    e.first_name,
    e.last_name,
    MAX(s.salary) - MIN(s.salary) AS salary_difference,
    CASE
        WHEN MAX(s.salary) - MIN(s.salary) > 30000 THEN 'Salary was raised by more then $30,000'
        ELSE 'Salary was NOT raised by more then $30,000'
    END AS salary_raise
FROM
    dept_manager dm
        JOIN
    employees e ON e.emp_no = dm.emp_no
        JOIN
    salaries s ON s.emp_no = dm.emp_no
GROUP BY s.emp_no;  





