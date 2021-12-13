-- Retirement --
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

-- Only from 1952 ---
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';

-- Skill Drill Begins --

-- Only from 1953 ---
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31';

-- Only from 1954 ---
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31';

-- Only from 1955 ---
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31';

-- Skill Drill Ends --

-- Retirement eligibility Narrow --

SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Export Results --
SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT * FROM retirement_info;

-- JOIN ---

DROP TABLE retirement_info; -- delete this in order to create a new one with emp_no 

-- New table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT * FROM retirement_info;

-- INNER JOIN: departments and dept_manager tables
SELECT departments.dept_name,
     dept_manager.emp_no,
     dept_manager.from_date,
     dept_manager.to_date
FROM departments
INNER JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no;

-- Alias on the above JOIN table
-- (d)departments, (dm)dept_manager
SELECT d.dept_name,
	dm.emp_no,
	dm.from_date,
	dm.to_date,
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;


-- LEFT JOIN: retirement_info and dept_emp tables
SELECT retirement_info.emp_no,
	retirement_info.first_name,
	retirement_info.last_name,
    dept_emp.to_date
FROM retirement_info
LEFT JOIN dept_emp
ON retirement_info.emp_no = dept_emp.emp_no;

SELECT * FROM retirement_info;

-- Alias on the above JOIN table
-- (ri)retirement_info, (de)dept_emp
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	de.to_date
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no;

-- LEFT JOIN: retirement_info and dept_emp tables CURRENT EMP
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

-- Employee count by department number and SKILL DRILL
SELECT COUNT(ce.emp_no), de.dept_no
INTO current_emp_byorder
FROM current_emp as ce

	LEFT JOIN dept_emp as de
	ON ce.emp_no = de.emp_no
	
GROUP BY de.dept_no
ORDER BY de.dept_no;

-- LIST 1: EMPLOYEE INFORMATION
SELECT * FROM salaries
ORDER BY to_date DESC;

-- (e)employees, (s)salary, (de)dept_emp
SELECT e.emp_no, 
	e.first_name, 
	e.last_name,
	e.gender,
	s.salary,
	de.to_date
-- INTO emp_info
FROM employees as e
	INNER JOIN salaries as s
	ON (e.emp_no = s.emp_no)
	
	INNER JOIN dept_emp as de
	ON (e.emp_no = de.emp_no)
	
	WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
		AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
		AND (de.to_date = '9999-01-01' );
	
-- LIST 2: MANAGEMENT
-- List of managers per department
SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
--INTO manager_info
FROM dept_manager AS dm
    INNER JOIN departments AS d
    ON (dm.dept_no = d.dept_no)
	
    INNER JOIN current_emp AS ce
    ON (dm.emp_no = ce.emp_no);
	
-- LIST 3: DEPARTMENT RETIREEE
-- use inner joins on the (ce)current_emp, (d)departments, and (de)dept_emp
SELECT  ce.emp_no,
		ce.first_name,
		ce.last_name,
		d.dept_name
INTO dept_info
FROM current_emp as ce
	INNER JOIN dept_emp as de
	ON (ce.emp_no = de.emp_no)
	
	INNER JOIN departments as d
	ON (de.dept_no = d.dept_no);
	
SELECT * FROM dept_info;

-- TAILORED LIST
SELECT  ce.emp_no,
		ce.first_name,
		ce.last_name,
		d.dept_name
--INTO sales_retirement_info
FROM current_emp as ce
	INNER JOIN dept_emp as de
	ON (ce.emp_no = de.emp_no)
	INNER JOIN departments as d
	ON (de.dept_no = d.dept_no)
WHERE de.dept_no = 'd007'

-- SALES and DEVELOPMENT	
SELECT  ce.emp_no,
		ce.first_name,
		ce.last_name,
		d.dept_name
INTO sales_dev_retirement_info
FROM current_emp as ce
	INNER JOIN dept_emp as de
	ON (ce.emp_no = de.emp_no)
	INNER JOIN departments as d
	ON (de.dept_no = d.dept_no)
WHERE de.dept_no in ('d007','d005');

SELECT * FROM sales_dev_retirement_info;

------------------------------------------------------------------------------------------------------------------------------------

-- DELIVERABLE 1: The Number of Retiring Employees by Title
-- Export as retirement_titles.csv
SELECT  e.emp_no, 
		e.first_name, 
		e.last_name,
    	title.title,
    	title.from_date,
    	title.to_date
INTO retirement_titles
FROM employees as e
    INNER JOIN title
    ON (e.emp_no = title.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no;

SELECT * FROM retirement_titles;

-- Use Dictinct with Orderby to remove duplicate rows
-- Export as unique_titles.csv
SELECT DISTINCT ON (rt.emp_no) rt.emp_no,
					rt.first_name,
					rt.last_name,
					rt.title
INTO unique_titles
FROM retirement_titles as rt
ORDER BY rt.emp_no ASC, rt.to_date DESC;

SELECT * FROM unique_titles;

SELECT COUNT(*)
FROM unique_titles;

-- retrieve the number of employees by their most recent job title who are about to retire
SELECT title, COUNT(title) as count
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY count DESC;

SELECT * FROM retiring_titles;

------------------------------------------------------------------------------------------------------------------------------------
-- DELIVERABLE 2: The Employees Eligible for the Mentorship Program

SELECT DISTINCT ON (e.emp_no) e.emp_no, 
		e.first_name, 
		e.last_name,
		e.birth_date,
		de.from_date,
		de.to_date,
		ti.title
INTO mentorship_eligibilty
FROM employees as e
	INNER JOIN dept_emp as de
    ON (e.emp_no = de.emp_no)
	INNER JOIN title as ti
	ON (e.emp_no = ti.emp_no)
  	WHERE (de.to_date = '9999-01-01') AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY e.emp_no;

SELECT * FROM mentorship_eligibilty;

SELECT COUNT(*)
FROM mentorship_eligibilty;